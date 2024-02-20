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

import AiutaKit
import Alamofire
import Foundation

final class ApiService {
    enum ApiError: Error, LocalizedError {
        case afError(AFError?)
        case statusCode(Int, String?)
        case failed(String?)

        var errorDescription: String? {
            switch self {
                case let .afError(afError):
                    if let afError {
                        return afError.errorDescription
                    } else { return "Unknown error" }
                case let .statusCode(code, rawResponse):
                    if let rawResponse { return "\(code): \(rawResponse)" }
                    else { return "Response code \(code)" }
                case let .failed(description):
                    let reason: String
                    if let description { reason = "\(description)\n" } else { reason = "" }
                    return "\(reason)Please check your internet\nconnection or try again later."
            }
        }
    }

    private let baseUrl: String
    private let apiKey: String

    private let session = Session.default
    private var responseDecoder = JSONDecoder()
    private var parameterEncoder = JSONParameterEncoder()

    init(baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        responseDecoder.dateDecodingStrategy = .formatted(formatter)
        responseDecoder.keyDecodingStrategy = .convertFromSnakeCase
        parameterEncoder.encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func request<Request: Encodable & ApiRequest, Response: Decodable>(_ request: Request) async throws -> Response {
        try await self.request(request).0
    }

    func request<Request: Encodable & ApiRequest, Response: Decodable>(_ request: Request) async throws -> (Response, HTTPHeaders?) {
        let url = buildUrl(request)
        let shortUrl = shortenUrl(url)
        let headers = try await buildHeaders(request)
        let timeOut: Session.RequestModifier = { $0.timeoutInterval = 10 }

        return try await withCheckedThrowingContinuation { [self] continuation in
            let dataRequest: DataRequest
            var plainResponse: String?
            switch request.type {
                case .plain:
                    trace(i: "▸", request.method.rawValue, url)
                    dataRequest = session.request(url,
                                                  method: request.method,
                                                  headers: headers,
                                                  requestModifier: timeOut)
                case .json:
                    trace(i: "▷", request.method.rawValue, url, request)
                    dataRequest = session.request(url,
                                                  method: request.method,
                                                  parameters: request.hasBody ? request : nil,
                                                  encoder: parameterEncoder,
                                                  headers: headers,
                                                  requestModifier: timeOut)
                case .upload:
                    trace(i: "▸", request.method.rawValue, url)
                    dataRequest = session.upload(multipartFormData: { multipartFormData in
                                                     request.multipartFormData(multipartFormData)
                                                 },
                                                 to: url,
                                                 method: request.method,
                                                 headers: headers,
                                                 requestModifier: timeOut)
            }

            dataRequest.responseString { [self] response in
                plainResponse = response.value

                switch request.type {
                    case .plain:
                        trace(i: "◂", "PLAIN Response",
                              "\n\n ▸", request.method.rawValue, shortUrl,
                              "\n ◂", response.response?.statusCode, shortenString(response.value) ?? response.error,
                              "\n")

                    case .json:
                        trace(i: "◁", "JSON Response",
                              "\n\n ▷", request.method.rawValue, shortUrl, request.hasBody ? request : "",
                              "\n ◁", response.response?.statusCode, shortenString(response.value) ?? response.error,
                              "\n")

                    case .upload:
                        trace(i: "◂", "UPLOAD Response",
                              "\n\n ▸", request.method.rawValue, shortUrl,
                              "\n ◂", response.response?.statusCode, shortenString(response.value) ?? response.error,
                              "\n")
                }

            }.responseDecodable(of: Response.self, decoder: responseDecoder) { response in
                let statusCode = response.response?.statusCode ?? 200

                if let error = response.error {
                    trace(statusCode, error)

                    switch error {
                        case let .sessionTaskFailed(error: sessionError):
                            continuation.resume(throwing: ApiError.failed(sessionError.localizedDescription))
                            return
                        default: break
                    }
                }

                guard statusCode == 200 else {
                    continuation.resume(throwing: ApiError.statusCode(statusCode, plainResponse))
                    return
                }

                if let result = response.value {
                    continuation.resume(returning: (result, response.response?.headers))
                } else {
                    continuation.resume(throwing: ApiError.afError(response.error))
                }
            }
        }
    }
}

private extension ApiService {
    func buildUrl(_ request: ApiRequest) -> String {
        let urlString = "\(baseUrl)/\(request.urlPath)"
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
        headers.add(.xApiKey(apiKey))
        return headers
    }

    func shortenUrl(_ urlString: String) -> String {
        urlString.replacingOccurrences(of: baseUrl, with: "")
    }

    func shortenString(_ string: String?, maxLength: Int = 1200) -> String? {
        guard let string else { return nil }
        guard string.count > maxLength else { return string }
        return string.prefix(maxLength) + "..."
    }
}

public extension HTTPHeader {
    static func ifNoneMatch(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "if-none-match", value: value)
    }

    static func xApiKey(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "x-api-key", value: value)
    }
}
