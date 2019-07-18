//
//  InsideView.swift
//  LoginKit
//
//  Created by Guillaume Bellue on 18/07/2019.
//  Copyright © 2019 Guillaume Bellue. All rights reserved.
//

import SwiftUI

struct InsideView : View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack { Spacer() }
            Image("avatar").resizable()
                .frame(width: 120, height: 120)
            Text("Congratulations,\nyou're logged in!")
                .font(.largeTitle).fontWeight(.semibold)
                .lineSpacing(20)
                .lineLimit(nil)
                .padding(.top, 30)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            Spacer()
        }
        .padding()
        .navigationBarItems(trailing: Button(action: self.onDismiss, label: {
            Text("disconnect")
        }))
        .navigationBarBackButtonHidden(true)
        .padding(.top, 44)
        .edgesIgnoringSafeArea(.top)
        .background(Image("palm")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .aspectRatio(contentMode: .fill)
            .opacity(0.2))
    }
}

#if DEBUG
struct InsideView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView { InsideView(onDismiss: {}) }
    }
}
#endif
