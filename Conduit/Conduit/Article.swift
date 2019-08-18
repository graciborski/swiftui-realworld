//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation

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

