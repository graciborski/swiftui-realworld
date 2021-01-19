//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine
import ComposableArchitecture

enum PaginatedAction<T> where T: Equatable {
    case fetchNextPage
    case appendPage(Paginated<T>.Page)
    case fetchFailed(ApiError)
    case clear
}

struct PaginatedEnvironment {
    var fetchPage: (Int, Int) -> AnyPublisher<Paginated<Article>.Page, ApiError>
}

extension PaginatedEnvironment {
    static let mock = PaginatedEnvironment(fetchPage: { offset, limit in Result.failure(ApiError.failedRequest).publisher.eraseToAnyPublisher() })
}

let paginatedReducer = Reducer<Paginated<Article>, PaginatedAction<Article>, PaginatedEnvironment>
{ store, action, environment in
    switch action {
    case let .appendPage(page):
        store.items.append(contentsOf: page.items)
        store.totalCount = page.totalCount
        store.fetching = .notLoading
        return .none
    case let .fetchFailed(error):
        store.fetching = .failed(error)
        return .none

    case .clear:
        store = .init()
        return .none

    case .fetchNextPage:
        if store.fetching == .initial
            || (store.items.count < store.totalCount && store.fetching != .loading) {
            store.fetching = .loading
            return environment.fetchPage(store.items.count, store.pageSize)
                .map(PaginatedAction<Article>.appendPage)
                .catchAll(PaginatedAction<Article>.fetchFailed)
                .eraseToEffect()
        }
        else {
            return .none
        }
    }
}


struct Paginated<T>: Equatable where T: Equatable {
    let pageSize = 20
    enum Fetching: Equatable {
        case initial
        case loading
        case notLoading
        case failed(ApiError)
    }
    
    struct Page {
        var items: [T] = []
        var totalCount: Int = 0
    }
    
    var items: [T] = []
    var totalCount: Int = 0
    var fetching: Fetching = .initial
   
}
