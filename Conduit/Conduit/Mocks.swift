//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

extension Environment {
    static let mock = Environment(apiUrl: URL(string: "http://mockUrl.com")!,
                                  api: .mock,
                                  date: { .mock },
                                  calendar: .mock)
}

extension Api {
    static let mock: Api = {
        var api = Api()
        api.articles = { Result.Publisher(mockArticles).eraseToAnyPublisher() }
        return api
    }()
}

private func mockArticle(number: Int) -> Article {
    Article(title: "Title \(number)",
        slug: "slug_\(number)",
        body: "body \(number)",
        createdAt: .mock,
        updatedAt: .mock,
        tagList: [],
        description: "description \(number)",
        author: .mock,
        favorited: false,
        favoritesCount: 0)
}

let mockArticles: [Article] = (1...30).map(mockArticle(number:))

extension Author {
    static let mock = Author(username: "mockAuthor", bio: nil, image: "mockImage.jpg", following: false)
}

extension Calendar {
    static let mock = Calendar(identifier: .gregorian)
}

extension Date {
    static let mock = Date(timeIntervalSinceReferenceDate: 0)
}


