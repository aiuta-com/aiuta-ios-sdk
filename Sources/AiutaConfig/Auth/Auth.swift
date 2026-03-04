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

#if SWIFT_PACKAGE
import AiutaCore
#endif
import Foundation

extension Aiuta {
    /// Defines the authentication methods available for accessing Aiuta's services.
    /// https://docs.aiuta.com/sdk/developer/configuration/auth/
    ///
    /// Authentication is required to interact with Aiuta's APIs and services. This enum
    /// provides different methods to authenticate requests, depending on the use case
    /// and the type of access required.
    public enum Auth: Sendable {
        /// Authenticate all API requests using an API key.
        ///
        /// This method is suitable for scenarios where a static API key is sufficient
        /// to access Aiuta's services. The API key is provided by Aiuta and should be
        /// kept secure to prevent unauthorized access.
        ///
        /// - Parameters:
        ///   - apiKey: A string representing the API key issued by Aiuta. This key
        ///     is used to authenticate all requests made to Aiuta's services.
        ///     See https://docs.aiuta.com/api/getting-started/#obtaining-credentials
        ///     for instructions on how to obtain your API key.
        case apiKey(_ apiKey: String)

        /// Authenticate tryOn generation requests using a JSON Web Token (JWT),
        /// while authenticating all other requests using a Subscription ID.
        ///
        /// This method is designed for advanced use cases where tryOn requests
        /// require additional security provided by JWTs. The JWT is generated
        /// server-side and passed to the SDK for authentication. Other requests
        /// are authenticated using a Subscription ID, which is tied to your Aiuta account.
        ///
        /// - Parameters:
        ///   - subscriptionId: A string representing the Subscription ID associated
        ///     with your Aiuta account. This ID is used to authenticate non-tryOn requests.
        ///     See https://docs.aiuta.com/api/getting-started/#obtaining-credentials
        ///     for instructions on how to obtain your Subscription ID.
        ///   - jwtProvider: An object conforming to the `JwtProvider` protocol, responsible
        ///     for generating JWTs for tryOn requests. The JWT should be generated securely
        ///     on your server and passed to the SDK.
        ///     See [JWT server-side auth example](https://docs.aiuta.com/api/server-side-auth-component/)
        ///     to learn how to generate the JWT on your server side.
        case jwt(subscriptionId: String, jwtProvider: JwtProvider)
    }
}
