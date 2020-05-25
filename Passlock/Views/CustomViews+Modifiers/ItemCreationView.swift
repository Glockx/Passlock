
//
//  ItemCreationView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/13.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct ItemCreation: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showModal = false
    var body: some View {
        NavigationView {
            ZStack {
                HStack(spacing: 50) {
                    VStack(spacing: 50) {
                        ItemButton(name: "Login", imageName: "person.2.square.stack.fill", destination: LoginItemView())
                        ItemButton(name: "Debit Card", imageName: "creditcard.fill", destination: DebitItemCreationView())
                    }
                    VStack(spacing: 50) {
                        ItemButton(name: "Identity", imageName: "person.crop.square.fill", destination: IdentityItemCreationView())
                        ItemButton(name: "Note", imageName: "doc.text.fill", destination: NoteItemCreationView())
                    }
                }
            }
            .navigationBarTitle(Text("New Item"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done").foregroundColor(.orange)
            }))
        }
    }
}

struct ItemCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCreation().environment(\.colorScheme, .dark)
    }
}
