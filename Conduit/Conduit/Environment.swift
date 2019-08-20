//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import Foundation

struct Environment {
    var apiUrl = URL(string: "https://conduit.productionready.io/api")!
    var api = Api()
    var date: () -> Date = Date.init
    var calendar: Calendar = Calendar.autoupdatingCurrent
    var locale = Locale.autoupdatingCurrent
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Current.calendar
        formatter.locale = Current.locale
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }
}

let Current = Environment()
