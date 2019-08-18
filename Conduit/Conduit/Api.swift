//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

struct Api {
    var articles: () -> Future<[Article], Never> = {
        let endpointUrl = Current.apiUrl.appendingPathComponent("articles")
        let publisher = URLSession.shared.dataTaskPublisher(for: endpointUrl)
            .map(\.data)
            .decode(type: ArticlesEnvelope.self, decoder: JSONDecoder())
            .map(\.articles)
            .eraseToAnyPublisher()

        return Publisher.
    }
}

