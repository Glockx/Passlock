//
//  ItemButton.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/12.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

// MARK: Item Button Style

struct ItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 120, height: 120)
            .foregroundColor(Color.white)
            .background(Color.orange)
            .cornerRadius(10)
    }
}

// For Navigation we should make Item Button with Generic type to pass View as parameter
struct ItemButton<DestinationView: View>: View {
    @State var name: String
    @State var imageName: String
    @State var destination: DestinationView
    @State var showingDetail = false

    var body: some View {
        Button(action: { self.showingDetail.toggle() }, label: {
            VStack(spacing: 10) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                Text(name)
            }.sheet(isPresented: $showingDetail) {
                self.destination
            }
        }).buttonStyle(ItemButtonStyle())
    }
}

// MARK: FaceID Image Style

extension Image {
    func imageAsFaceID() -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .padding(.all)
            .background(Color.orange)
            .cornerRadius(16)
            .foregroundColor(.white)
            .shadow(radius: 20)
    }
}
