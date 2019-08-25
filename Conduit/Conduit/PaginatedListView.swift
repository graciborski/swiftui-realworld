//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI

struct PaginatedListView<T, RowContent>: View where T: Identifiable, RowContent: View {
    let paginated: Paginated<T>
    let dispatchAction: (PaginatedAction<T>) -> Void
    let rowContent: (T) -> RowContent
    var body: some View {
        List {
            ForEach(paginated.items, content: rowContent)
            Text(paginated.state == .loading ? "Loading" : "")
                .frame(height: 80)
                .onAppear {
                    self.dispatchAction(.fetchNextPage)
            }
        }
    }
}

#if DEBUG
struct PaginatedListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedListView(paginated: Paginated(items: Array(mockArticles.prefix(upTo: 3)),
                                               totalCount: 50,
                                               state: .loading),
                          dispatchAction: { _ in },
                          rowContent: ArticleCell.init)
    }
}
#endif
