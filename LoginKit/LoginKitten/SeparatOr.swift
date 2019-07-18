//
//  SeparatOr.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct SeparatOr : View {
    var body: some View {
        ZStack {
            Divider().padding(.vertical, 50)
            Text(Strings.Common.or)
                .padding(.horizontal)
                .foregroundColor(Color.gray)
                .background(Color(red: 250/255.0, green: 250/255.0, blue: 250/255.0))
        }
    }
}

#if DEBUG
struct SeparatOr_Previews : PreviewProvider {
    static var previews: some View {
        SeparatOr()
    }
}
#endif
