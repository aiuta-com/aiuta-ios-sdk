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

    private let responseDecoder = JSONDecoder()
    private let parameterEncoder = JSONParameterEncoder()
    private let requestModifier: Session.RequestModifier
    private let uploadsModifier: Session.RequestModifier

    private let codeOk = 200
    private let codeNotModified = 304

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

        uploadsModifier = { urlRequest in
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            urlRequest.timeoutInterval = 60
        }
    }
}

@available(iOS 13.0.0, *)
private extension RestService {
    @MainActor func sendRequest<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request,
                                                                                      debugger debugOperation: ApiDebuggerOperation?) async throws -> ApiResponse<Response> {
        /// request

        let url = try await buildUrl(request)
        let headers = try await buildHeaders(request)
        let parameters = request.hasBody ? request : nil

        var shortUrl: String?
        var requestBody: String?
        var requestDebugger: ApiDebuggerRequest?
        let isDebug = debugger?.isEnabled == true

        if isDebug {
            shortUrl = try await shortenUrl(url)
            if request.hasBody { requestBody = String(decoding: try parameterEncoder.encoder.encode(request), as: UTF8.self) }
            requestDebugger = await buildDebugger(request, body: requestBody, shortUrl: shortUrl, debugger: debugOperation)
        }

        let session = Session.default
        let dataRequest: DataRequest

        switch request.type {
            case .plain:
                if isDebug { trace(i: "▸", request.method.rawValue, shortUrl, headers.keys) }
                dataRequest = session.request(url, method: request.method,
                                              headers: headers, requestModifier: requestModifier)
            case .json:
                if isDebug { trace(i: "▷", request.method.rawValue, shortUrl, headers.keys, requestBody ?? "") }
                dataRequest = session.request(url, method: request.method,
                                              parameters: parameters, encoder: parameterEncoder,
                                              headers: headers, requestModifier: requestModifier)
            case .upload:
                if isDebug { trace(i: "▸", request.method.rawValue, shortUrl, headers.keys) }
                dataRequest = session.upload(multipartFormData: { request.multipartFormData($0) },
                                             to: url, method: request.method,
                                             headers: headers, requestModifier: uploadsModifier)
        }

        /// response

        let rawResponse = await dataRequest.rawResponse()
        let statusCode = rawResponse.response?.statusCode

        if statusCode == codeNotModified {
            if isDebug { trace(i: "◁", "Response",
                               "\n\n ▷", request.method.rawValue, shortUrl, headers.keys, requestBody ?? "",
                               "\n ◁", statusCode,
                               "\n") }

            requestDebugger?.responseBody = "<not modified>"
            throw ApiError.notModified
        }

        if isDebug {
            switch request.type {
                case .plain:
                    trace(i: "◂", "PLAIN Response",
                          "\n\n ▸", request.method.rawValue, shortUrl, headers.keys,
                          "\n ◂", statusCode, shortenString(rawResponse.value) ?? rawResponse.error,
                          "\n")

                case .json:
                    trace(i: "◁", "JSON Response",
                          "\n\n ▷", request.method.rawValue, shortUrl, headers.keys, requestBody ?? "",
                          "\n ◁", statusCode, shortenString(rawResponse.value) ?? rawResponse.error,
                          "\n")

                case .upload:
                    trace(i: "◂", "UPLOAD Response",
                          "\n\n ▸", request.method.rawValue, shortUrl, headers.keys,
                          "\n ◂", statusCode, shortenString(rawResponse.value) ?? rawResponse.error,
                          "\n")
            }
        }

        var rawErrorString: String?
        if isDebug, let error = rawResponse.error {
            rawErrorString = String(describing: error)
        }

        requestDebugger?.responseCode = statusCode
        requestDebugger?.responseError = rawErrorString
        requestDebugger?.responseBody = rawResponse.value

        guard let statusCode else {
            requestDebugger?.responseError = "<no response>"
            throw ApiError(rawResponse.error)
        }

        guard statusCode == codeOk else {
            let errorInfo = await dataRequest.decodeResponse(of: ApiError.Info.self, decoder: responseDecoder)
            requestDebugger?.responseError = errorInfo.value?.error ?? rawErrorString
            throw ApiError(statusCode, with: errorInfo.value?.error ?? shortenString(rawResponse.value, maxLength: 300))
        }

        let response = await dataRequest.decodeResponse(of: Response.self, decoder: responseDecoder)
        if isDebug, let error = response.error { requestDebugger?.responseError = rawErrorString ?? String(describing: error) }
        guard let result = response.value else { throw ApiError(response.error) }
        return (response: result, headers: response.response?.headers)
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
        try await provider.authorize(headers: &headers, for: request)
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

@available(iOS 13.0.0, *)
@_spi(Aiuta) extension RestService: ApiService {
    @MainActor public func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request,
                                                                                         debugger debugOperation: ApiDebuggerOperation?,
                                                                                         breadcrumbs: Breadcrumbs?) async throws -> ApiResponse<Response> {
        let source = String(reflecting: type(of: request))
        breadcrumbs?.add(on: source)
        do {
            return try await sendRequest(request, debugger: debugOperation)
        } catch ApiError.notModified {
            throw ApiError.notModified
        } catch {
            let breadcrumbs = breadcrumbs ?? Breadcrumbs(on: source)
            breadcrumbs.fire(error, label: error.localizedDescription, on: source)
            throw error
        }
    }
}
