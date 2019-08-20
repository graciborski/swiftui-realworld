//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

enum ApiError: Error {
    case failedRequest
    case invalidResponse
    case unauthorized
}

struct Api {
    var articles: () -> AnyPublisher<[Article], ApiError> = {
        let endpointUrl = Current.apiUrl.appendingPathComponent("articles")
        let publisher = URLSession.shared.dataTaskPublisher(for: endpointUrl)
            .mapError { _ in .invalidResponse }
            .flatMap { (dataAndResponse) -> Result<Data, ApiError>.Publisher in
                let (data, response) = dataAndResponse;
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if 200...299 ~= statusCode {
                    return .init(data)
                } else if 401 == statusCode {
                    return .init(.unauthorized)
                } else if 400...500 ~= statusCode {
                    return .init(.failedRequest)
                }
                return .init(.failedRequest)
            }
            .decode(type: ArticlesEnvelope.self, decoder: JSONDecoder())
            .mapError { error -> ApiError in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.invalidResponse
                }
            }
            .map(\.articles)
            .eraseToAnyPublisher()
        return publisher
    }
}

