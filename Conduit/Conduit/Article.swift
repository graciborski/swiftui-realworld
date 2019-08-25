//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

struct Article: Decodable {
    let title: String
    let slug: String
    let body: String
    let createdAt: Date // "2019-08-18T06:21:23.420Z",
    let updatedAt: Date // "2019-08-18T06:21:23.420Z",
    let tagList: [String] // [ ],
    let description: String
    let author: Author
    let favorited: Bool
    let favoritesCount: Int
}

extension Article: Identifiable {
    var id: String {
        slug
    }
}

struct Author: Decodable {
    let username: String
    let bio: String?
    let image: String// "https://static.productionready.io/images/smiley-cyrus.jpg",
    let following: Bool
}

struct ArticlesEnvelope: Decodable {
    let articles: [Article]
    let articlesCount: Int
}

extension Paginated.Page where T == Article {
    init(_ articlesEnvelope: ArticlesEnvelope) {
        self.items = articlesEnvelope.articles
        self.totalCount = articlesEnvelope.articlesCount
    }
}

struct TagsEnvelope: Decodable {
    let tags: [String]
}
