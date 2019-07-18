//
//  LabelTextField.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 15/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct LabelTextField : View {
    var label: LocalizedStringKey
    var placeHolder: LocalizedStringKey
    @Binding var value: String
    @Binding var error: String
    
    var validation: ((String) -> String?)?

    @State var isLabelled: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            if $isLabelled.value {
                if $error.value.isEmpty {
                    Text(label)
                        .color(Color.gray)
                        .font(.caption).fontWeight(.semibold)
                        .transition(.move(edge: .bottom))
                        .transition(.opacity)
                } else {
                    Text($error.value)
                        .font(.caption).fontWeight(.semibold)
                        .color(Color.red)
                        .transition(.move(edge: .bottom))
                        .transition(.opacity)
                }
            }
            TextField($isLabelled.value ? "" : placeHolder, text: $value, onEditingChanged: { editing in
                withAnimation {
                    self.error = ""
                    if !editing {
                        self.error = self.validation?(self.value) ?? ""
                    }
                    self.isLabelled = editing
                        || !self.value.isEmpty
                        || !self.error.isEmpty
                }
            })
            Divider()
                .background($error.value.isEmpty ? Color.gray : Color.red)
        }.frame(height: 65, alignment: .bottomLeading)
    }
}

#if DEBUG
struct LabelTextField_Previews : PreviewProvider {
    @State static var email: String = ""
    @State static var error: String = ""
    static var previews: some View {
        LabelTextField(label: "Email", placeHolder: "Email", value: $email, error: $error)
    }
}
#endif
