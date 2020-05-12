//
//  ItemButton.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/12.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI


struct ItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 110, height: 110)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct ItemButton: View {
    @State var name: String
    @State var imageName: String

    var body: some View {
        Button(action: {}, label: {
            VStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                Text(name)
            }
        }).buttonStyle(ItemButtonStyle())
    }
}
