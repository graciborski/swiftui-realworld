//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

enum ApiError: Error {
    case failedRequest
    case invalidResponse
}

struct Api {
    var articles: () -> AnyPublisher<[Article], ApiError> = {
        let endpointUrl = Current.apiUrl.appendingPathComponent("articles")
        let publisher = URLSession.shared.dataTaskPublisher(for: endpointUrl)
            .map(\.data)
            .mapError { _ in ApiError.failedRequest }
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

