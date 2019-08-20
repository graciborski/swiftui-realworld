//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI

struct ContentView: View {
    var body: some View {
        ArticleList(articles: mockArticles)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
