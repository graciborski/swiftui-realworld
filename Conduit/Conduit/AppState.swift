//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

enum AppAction {
    case globalFeed(PaginatedAction<Article>)
    var globalFeed: PaginatedAction<Article>? {
        get {
          guard case let .globalFeed(value) = self else { return nil }
          return value
        }
        set {
          guard case .globalFeed = self, let newValue = newValue else { return }
          self = .globalFeed(newValue)
        }
    }
}

struct AppState {
    var globalFeed = Paginated<Article>()
    var popularTags = ["one", "two", "three"]
}

let articlesFeedback = paginatedFeedback(fetchCommand: mapPublisherProducer(Paginated<Article>.Page.init)(Current.api.articles))

let appStore = Store<AppState, AppAction>(initialValue: AppState(),
                                          reducer: pullback(paginatedReducer, value: \.globalFeed, action: \.globalFeed),
                                          feedback: pullback(articlesFeedback, value: \.globalFeed, action: \.globalFeed, backAction: AppAction.globalFeed))
