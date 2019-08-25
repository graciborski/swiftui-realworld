//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI
import Combine

var cancellables = Set<AnyCancellable>()

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        PaginatedListView(paginated: store.value.globalFeed,
                          dispatchAction: { self.store.send(.globalFeed($0)) },
                          rowContent: ArticleCell.init)

    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: appStore)
    }
}
#endif
