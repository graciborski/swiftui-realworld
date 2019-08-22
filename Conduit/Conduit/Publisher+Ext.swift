//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

extension Publisher {
    func catchAll(_ f: @escaping (Failure) -> Output) -> AnyPublisher<Output, Never>  {
        self.catch { Result<Output, Never>.Publisher(.success(f($0))) }.eraseToAnyPublisher()
    }
}
