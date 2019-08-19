//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation
import Combine

extension Publisher where Failure == Never {
    func promoteError<Err>() -> Publishers.MapError<Self, Err> where Err: Error {
        self.mapError { _ -> Err in fatalError() }
    }
}

