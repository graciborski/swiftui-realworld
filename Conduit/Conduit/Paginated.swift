//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

enum PaginatedAction<T> {
    case fetchNextPage
    case appendPage(Paginated<T>.Page)
    case fetchFailed(ApiError)
    case clear
}

func paginatedFeedback<T>(pageSize: Int = 20, fetchCommand: @escaping (Int, Int) -> AnyPublisher<Paginated<T>.Page, ApiError>)
    -> (Paginated<T>, Paginated<T>, PaginatedAction<T>)
    -> AnyPublisher<PaginatedAction<T>, Never> {
        return { oldState, newState, action in
            switch action {
            case .fetchNextPage:
                if oldState.state != .loading && newState.state == .loading {
                    return fetchCommand(newState.items.count, newState.totalCount)
                        .map(PaginatedAction<T>.appendPage)
                        .catchAll(PaginatedAction<T>.fetchFailed)
                        .eraseToAnyPublisher()
                } else {
                    return Optional.Publisher(nil).eraseToAnyPublisher()
                }
            default:
               return Optional.Publisher(nil).eraseToAnyPublisher()
        }
    }
}

func paginatedReducer<T>(paginated: inout Paginated<T>, action: PaginatedAction<T>) {
    switch action {
    case let .appendPage(page):
        paginated.items.append(contentsOf: page.items)
        paginated.totalCount = page.totalCount
        paginated.state = .notLoading
    case let .fetchFailed(error):
        paginated.state = .failed(error)
    case .clear:
        paginated = .init()
    case .fetchNextPage:
        if paginated.items.count < paginated.totalCount {
            paginated.state = .loading
        }
    }
}

struct Paginated<T> {
    enum State: Equatable {
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
    var state: State = .initial
   
}

func mapPublisherProducer<Input, A, B, Err>(_ f: @escaping (A) -> B ) -> (@escaping (Input) -> AnyPublisher<A, Err>) -> (Input) -> AnyPublisher<B, Err> {
    { originalPublisherProducer in { input in
            originalPublisherProducer(input).map(f).eraseToAnyPublisher()
        }
    }
}

func mapPublisherProducer<Input1, Input2, A, B, Err>(_ f: @escaping (A) -> B ) -> (@escaping (Input1, Input2) -> AnyPublisher<A, Err>) -> (Input1, Input2) -> AnyPublisher<B, Err> {
    { originalPublisherProducer in { input1, input2 in
            originalPublisherProducer(input1, input2).map(f).eraseToAnyPublisher()
        }
    }
}
