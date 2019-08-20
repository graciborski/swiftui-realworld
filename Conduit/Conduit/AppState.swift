//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation

enum FetchActions<T, E> {
    case startFetching
    case success(T)
    case failure
}

struct AppState {
    var globalFeed: [Article]
}
