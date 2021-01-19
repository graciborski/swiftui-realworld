//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine
import ComposableArchitecture

enum AppAction {
    case globalFeed(PaginatedAction<Article>)
}

struct AppState: Equatable {
    var globalFeed = Paginated<Article>()
    var popularTags = ["one", "two", "three"]
}

let appReducer: Reducer<AppState, AppAction, Environment> =
    paginatedReducer.pullback(state: \.globalFeed,
                              action: /AppAction.globalFeed,
                              environment: { globalEnvironment in
                                PaginatedEnvironment(fetchPage: { offset, limit in
                                    globalEnvironment.api.articles(offset, limit)
                                        .map(Paginated.Page.init).eraseToAnyPublisher()
                                })
                              })




