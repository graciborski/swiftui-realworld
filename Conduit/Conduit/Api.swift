//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

enum ApiError: Error {
    case failedRequest
    case invalidResponse
    case unauthorized
}

struct Api {
    var articles: (Int, Int) -> AnyPublisher<ArticlesEnvelope, ApiError> = { offset, limit in
        var urlComponents = URLComponents()
        urlComponents.path = "api/articles"
        urlComponents.queryItems = [
           URLQueryItem(name: "offset", value: String(offset)),
           URLQueryItem(name: "limit", value: String(limit))
        ]
        let url = urlComponents.url(relativeTo: Current.apiUrl)!
      
        let publisher = getUrl(url)
            .decode(type: ArticlesEnvelope.self, decoder: jsonDecoder)
            .mapError { error -> ApiError in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
        return publisher
    }
    
    var tags: () -> AnyPublisher<[String], ApiError> = {
        getUrl(Current.apiUrl.appendingPathComponent("api/tags"))
            .decode(type: TagsEnvelope.self, decoder: jsonDecoder)
            .mapError { error -> ApiError in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.invalidResponse
                }
        }
        .map(\.tags)
        .eraseToAnyPublisher()
    }
}

private func getUrl(_ url: URL) -> AnyPublisher<Data, ApiError> {
    return URLSession.shared.dataTaskPublisher(for: url)
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
    }.eraseToAnyPublisher()
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = Current.dateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter
} ()

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
    
        guard let date = dateFormatter.date(from: dateStr) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        }
        return date
    })
    return decoder
}()

