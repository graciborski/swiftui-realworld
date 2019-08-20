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
            HStack{
                Image(systemName: "heart")
                Text("\(article.favoritesCount)")
            }
        }
    }
}

struct AuthorTimestampView: View {
    let author: Author
    let createdAt: Date
    var body: some View {
        HStack {
            Image(systemName: "house")
            VStack(alignment: .leading) {
                Text(author.username)
                Text(Current.dateFormatter().string(from: createdAt))
            }
        }
    }
}

#if DEBUG
struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticleList(articles: mockArticles)
        }
    }
}
#endif
