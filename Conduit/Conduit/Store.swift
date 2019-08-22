//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

// Store class borrowed from https://github.com/pointfreeco/episode-code-samples/tree/master/0070-composable-state-management-action-pullbacks
// (pointfree.co rocks!)

final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    let feedback: (Value, Value, Action) -> AnyPublisher<Action, Never>
    private var cancellables = [AnyCancellable]()
    @Published private(set) var value: Value
    
    init(initialValue: Value,
         reducer: @escaping (inout Value, Action) -> Void,
         feedback: @escaping (Value, Value, Action) -> AnyPublisher<Action, Never>) {
        self.reducer = reducer
        self.value = initialValue
        self.feedback = feedback
    }
    
    func send(_ action: Action) {
        let oldValue = self.value
        self.reducer(&self.value, action)
        self.feedback(oldValue, value, action)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ feedback: @escaping (LocalValue, LocalValue, LocalAction) -> AnyPublisher<LocalAction, Never>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>,
    backAction: @escaping (LocalAction) -> GlobalAction
) -> (GlobalValue, GlobalValue, GlobalAction) -> AnyPublisher<GlobalAction, Never> {
    return { oldGlobalValue, newGlobalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return Optional.Publisher(nil).eraseToAnyPublisher() }
        return feedback(oldGlobalValue[keyPath: value], newGlobalValue[keyPath: value], localAction).map(backAction).eraseToAnyPublisher()
    }
}

func combine<Value, Action>(_ feedbacks: (Value, Value, Action) -> AnyPublisher<Action, Never>...)
    -> (Value, Value, Action)
    -> AnyPublisher<Action, Never> {
        return { oldValue, newValue, action in
            let publishers = feedbacks.map { feedback in feedback(oldValue, newValue, action) }
            return Publishers.MergeMany(publishers).eraseToAnyPublisher()
        }
}
