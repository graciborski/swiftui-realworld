//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

extension Api {
    static let mock: Api = {
        var api = Api()
        api.articles = { Future.success(mockArticles) }
        return api
    }()
}

private func mockArticle(number: Int) -> Article {
    Article(title: "Title \(number)",
        slug: "slug_\(number)",
        body: "body \(number)",
        createdAt: mockDate,
        updatedAt: mockDate,
        tagList: [],
        description: "description \(number)",
        author: mockAuthor,
        favorited: false,
        favoritesCount: 0)
}

private let mockAuthor = Author(username: "mockAuthor", bio: nil, image: "mockImage.jpg", following: false)
private let mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 4, day: 2, hour: 20, minute: 10))!
let mockArticles: [Article] = (1...30).map(mockArticle(number:))
