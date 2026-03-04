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

extension Aiuta.Auth {
    /// Protocol defining the requirements for a JWT provider.
    ///
    /// A JWT provider is responsible for generating JSON Web Tokens (JWTs) required
    /// for authenticating tryOn requests. The implementation of this protocol should
    /// securely generate and return a JWT based on the provided request parameters.
    public protocol JwtProvider: Sendable {
        /// Generates a JWT for the specified request parameters.
        ///
        /// This method is called by the SDK whenever a tryOn request requires authentication
        /// using a JWT. The implementation should securely generate the JWT on the server
        /// and return it to the SDK. The `requestParams` can be used to include additional
        /// context in the JWT generation process, ensuring the token is specific to the
        /// request being made.
        ///
        /// - Parameters:
        ///   - requestParams: A dictionary containing key-value pairs representing
        ///     the parameters of the request that requires a JWT. These parameters
        ///     can be used to customize the JWT generation process.
        ///
        /// - Returns: A string representing the generated JWT token.
        ///
        /// - Throws: An error if the JWT cannot be generated. If an error is thrown,
        ///   the SDK will be unable to complete the tryOn request and will display
        ///   an error message to the user.
        ///
        /// See [JWT server-side auth example](https://docs.aiuta.com/api/server-side-auth-component/)
        /// for more details on securely generating JWTs.
        @available(iOS 13.0.0, *)
        func getJwt(requestParams: [String: String]) async throws -> String
    }
}
