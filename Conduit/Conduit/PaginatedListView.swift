//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct PaginatedListView<T, RowContent>: View where T: Identifiable, T: Equatable, RowContent: View {
    let store: Store<Paginated<T>, PaginatedAction<T>>
    let rowContent: (T) -> RowContent
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEach(viewStore.items, content: rowContent)
                Text(viewStore.fetching == Paginated.Fetching.loading ? "Loading" : "")
                    .frame(height: 80)
                    .onAppear {
                        viewStore.send(.fetchNextPage)
                    }
            }
        }
    }
}

#if DEBUG
struct PaginatedListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedListView(store: Store(initialState: Paginated<Article>(),
                                       reducer: paginatedReducer,
                                       environment: PaginatedEnvironment.mock),
                          rowContent: ArticleCell.init)
    }
}
#endif
