//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI
import Combine

var cancellables = Set<AnyCancellable>()

struct ContentView: View {
    @State var articles: [Article] = []
    var body: some View {
        ArticleList(articles: articles).onAppear {
            Current.api.articles(0, 20)
                .map(\.articles)
                .catchAll { _ in [] }
                .assign(to: \.articles, on: self)
                .store(in: &cancellables)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
