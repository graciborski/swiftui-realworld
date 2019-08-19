//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation

struct Environment {
    var apiUrl = URL(string: "https://conduit.productionready.io/api")!
    var api = Api()
    var date: () -> Date = Date.init
    var calendar: () -> Calendar = { Calendar.current }
}

let Current = Environment()
