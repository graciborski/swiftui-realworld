//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI
import Combine
import ComposableArchitecture


struct ContentView: View {
    let store: Store<AppState, AppAction>
    var body: some View {
        VStack {
            WithViewStore(self.store) { viewStore in
                TagsListView(tags: viewStore.popularTags)
                PaginatedListView(store: store.scope(state: \.globalFeed, action: AppAction.globalFeed),
                                  rowContent: ArticleCell.init)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(),
                                 reducer: appReducer,
                                 environment: Environment.mock))
    }
}
#endif
