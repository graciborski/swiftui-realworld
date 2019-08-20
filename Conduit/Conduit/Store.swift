//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation

// Store class borrowed from https://github.com/pointfreeco/episode-code-samples/tree/master/0070-composable-state-management-action-pullbacks
// (pointfree.co rocks!)

final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value

  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
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
