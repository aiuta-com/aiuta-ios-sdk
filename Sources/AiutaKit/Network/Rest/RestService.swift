// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Alamofire
import Foundation

@available(iOS 13.0.0, *)
@_spi(Aiuta) public actor RestService {
    private let provider: ApiProvider
    private let debugger: ApiDebugger?
    private let session = Session.default
    private let responseDecoder = JSONDecoder()
    private let parameterEncoder = JSONParameterEncoder()
    private let requestModifier: Session.RequestModifier

    public init(_ provider: ApiProvider, debugger: ApiDebugger? = nil) {
        self.provider = provider
        self.debugger = debugger

        let dateFormatter = DateFormatter { it in
            it.calendar = Calendar(identifier: .iso8601)
            it.timeZone = TimeZone(secondsFromGMT: 0)
            it.locale = Locale(identifier: .posix)
        }

        let supportedDateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd",
        ]

        responseDecoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            for dateFormat in supportedDateFormats {
                dateFormatter.dateFormat = dateFormat
                if let date = dateFormatter.date(from: dateStr) {
                    return date
                }
            }

            throw ApiError.failed("Unsupported date format")
        }

        responseDecoder.keyDecodingStrategy = .convertFromSnakeCase
        parameterEncoder.encoder.keyEncodingStrategy = .convertToSnakeCase

        requestModifier = { urlRequest in
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            urlRequest.timeoutInterval = 10
        }
    }
}

@available(iOS 13.0.0, *)
@_spi(Aiuta) extension RestService: ApiService {
    @MainActor public func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request,
                                                                                         debugger debugOperation: ApiDebuggerOperation?,
                                                                                         breadcrumbs: Breadcrumbs?) async throws -> ApiResponse<Response> {
        do {
            let url = try await buildUrl(request)
            let headers = try await buildHeaders(request)

            var shortUrl: String?
            var requestBody: String?
            var requestDebugger: ApiDebuggerRequest?
            let isDebug = debugger?.isEnabled == true

            if isDebug {
                shortUrl = try await shortenUrl(url)
                if request.hasBody { requestBody = String(decoding: try parameterEncoder.encoder.encode(request), as: UTF8.self) }
                requestDebugger = await buildDebugger(request, body: requestBody, shortUrl: shortUrl, debugger: debugOperation)
            }

            return try await withCheckedThrowingContinuation { [self] continuation in
                let dataRequest: DataRequest

                switch request.type {
                    case .plain:
                        if isDebug { trace(i: "▸", request.method.rawValue, shortUrl) }
                        dataRequest = session.request(url, method: request.method, headers: headers, requestModifier: requestModifier)
                    case .json:
                        if isDebug { trace(i: "▷", request.method.rawValue, shortUrl, requestBody) }
                        dataRequest = session.request(url, method: request.method,
                                                      parameters: request.hasBody ? request : nil,
                                                      encoder: parameterEncoder, headers: headers, requestModifier: requestModifier)
                    case .upload:
                        if isDebug { trace(i: "▸", request.method.rawValue, shortUrl) }
                        dataRequest = session.upload(multipartFormData: { request.multipartFormData($0) },
                                                     to: url, method: request.method, headers: headers, requestModifier: requestModifier)
                }

                dataRequest.responseString { [self] response in
                    let statusCode = response.response?.statusCode
                    let plainResponse = response.value
                    var plainError: String?
                    if isDebug, let error = response.error {
                        plainError = String(describing: error)
                    }

                    requestDebugger?.responseCode = statusCode

                    if statusCode == 304 {
                        if isDebug { trace(i: "◁", "Response",
                                           "\n\n ▷", request.method.rawValue, shortUrl, requestBody,
                                           "\n ◁", statusCode,
                                           "\n") }

                        requestDebugger?.responseBody = "<not modified>"
                        continuation.resume(throwing: ApiError.notModified)
                        return
                    }

                    requestDebugger?.responseBody = plainResponse
                    requestDebugger?.responseError = plainError

                    if isDebug {
                        switch request.type {
                            case .plain:
                                trace(i: "◂", "PLAIN Response",
                                      "\n\n ▸", request.method.rawValue, shortUrl,
                                      "\n ◂", statusCode, shortenString(response.value) ?? response.error,
                                      "\n")

                            case .json:
                                trace(i: "◁", "JSON Response",
                                      "\n\n ▷", request.method.rawValue, shortUrl, requestBody,
                                      "\n\n ◁", statusCode, shortenString(response.value) ?? response.error,
                                      "\n")

                            case .upload:
                                trace(i: "◂", "UPLOAD Response",
                                      "\n\n ▸", request.method.rawValue, shortUrl,
                                      "\n ◂", statusCode, shortenString(response.value) ?? response.error,
                                      "\n")
                        }
                    }

                    guard let statusCode else {
                        requestDebugger?.responseError = "<no response>"
                        continuation.resume(throwing: ApiError(response.error))
                        return
                    }

                    guard statusCode == 200 else {
                        dataRequest.responseDecodable(of: ApiError.Info.self, decoder: responseDecoder) { [self] response in
                            requestDebugger?.responseError = response.value?.error ?? plainError

                            continuation.resume(throwing: ApiError(
                                statusCode, with: response.value?.error ?? shortenString(plainResponse, maxLength: 200))
                            )
                        }

                        return
                    }

                    dataRequest.responseDecodable(of: Response.self, decoder: responseDecoder) { response in
                        if isDebug, let error = response.error {
                            requestDebugger?.responseError = plainError ?? String(describing: error)
                        }

                        if let result = response.value {
                            continuation.resume(returning: (response: result, headers: response.response?.headers))
                        } else {
                            continuation.resume(throwing: ApiError(response.error))
                        }
                    }
                }
            }
        } catch ApiError.notModified {
            throw ApiError.notModified
        } catch {
            let source = String(reflecting: type(of: request))
            (breadcrumbs ?? Breadcrumbs(on: source)).fire(error, label: error.localizedDescription, on: source)
            throw error
        }
    }
}

@available(iOS 13.0.0, *)
@MainActor private extension RestService {
    func buildUrl(_ request: ApiRequest) async throws -> String {
        let urlString = "\(try await provider.baseUrl)/\(request.urlPath)"
        guard var urlComponents = URLComponents(string: urlString) else {
            return urlString
        }
        if let queryItems = request.query?.items, !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url?.absoluteString ?? urlString
    }

    func buildHeaders(_ request: ApiRequest) async throws -> HTTPHeaders {
        guard request.requireAuth else { return request.headers }
        var headers = request.headers
        try await provider.authorize(headers: &headers)
        return headers
    }

    func buildDebugger(_ request: ApiRequest, body: String?, shortUrl: String?,
                       debugger debugOperation: ApiDebuggerOperation?) async -> ApiDebuggerRequest? {
        var debugOperation = debugOperation
        if debugOperation.isNil {
            debugOperation = await debugger?.startOperation(id: request.idString,
                                                            title: request.title,
                                                            subtitle: request.subtitle)
        }
        return await debugOperation?.addRequest(
            method: request.method.rawValue,
            url: shortUrl,
            body: body
        )
    }

    func shortenUrl(_ urlString: String) async throws -> String {
        urlString.replacingOccurrences(of: try await provider.baseUrl, with: "")
    }

    func shortenString(_ string: String?, maxLength: Int = 1200) -> String? {
        guard let string else { return nil }
        guard string.count > maxLength else { return string }
        return string.prefix(maxLength) + "..."
    }
}
