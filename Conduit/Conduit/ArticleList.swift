//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI

struct ArticleList: View {
    let articles: [Article]
    var body: some View {
        List(articles, rowContent: ArticleCell.init(article:))
    }
}

struct ArticleCell: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AuthorTimestampView(author: article.author, createdAt: article.createdAt)
                Spacer()
                FavoriteButton(article: article)
            }
            Text(article.title)
            Text(article.description)
            Text("Read more...")
        }
    }
}

struct FavoriteButton: View {
    let article: Article
    var body: some View {
        Button(action: { fatalError() }) {
            HStack(spacing: 5) {
                Image(systemName: article.favorited ? "heart.fill" : "heart")
                Text("\(article.favoritesCount)")
            }
            .padding(6)
        }
        .overlay(
            Capsule(style: .continuous)
                .stroke(accent, style: StrokeStyle(lineWidth: 1))
        )
    }
}

let accent = Color(rgb: 0x5CB85C)
let grey = Color(rgb: 0xBBBBBB)
let textBlackish = Color(rgb: 0x373a3c)
let tagBackground = Color(rgb: 0x818a91)

struct AuthorTimestampView: View {
    let author: Author
    let createdAt: Date
    var body: some View {
        HStack {
            Image(systemName: "house")
            VStack(alignment: .leading) {
                Text(author.username)
                    .foregroundColor(accent)
                Text(Current.dateFormatter().string(from: createdAt))
                    .foregroundColor(grey)
                    .font(.caption)
            }
        }
    }
}

#if DEBUG
struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ArticleCell(article: mockArticle(number: 1))
        }
    }
}
#endif
