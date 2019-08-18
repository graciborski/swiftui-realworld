//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI

struct ArticleList: View {
    let articles: [Article]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(articles: [])
    }
}
#endif
