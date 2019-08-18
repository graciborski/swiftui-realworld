//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Combine

extension Future {
    static func success(_ value: Output) -> Future<Output, Failure> {
        return Future { (completionHandler: @escaping (Result<Output, Failure>) -> Void) -> Void in
            completionHandler(.success(value))
        }
    }
}
