//  Copyright © 2019 Grzegorz Raciborski. All rights reserved.

import SwiftUI

struct TagsListView: View {
    let tags: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.tags, id:\.self) { tag in
                    Text(tag)
                }
            }
        }
    }
}

#if DEBUG
struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView(tags: Array((1000...1050).map(String.init)))
    }
}
#endif
