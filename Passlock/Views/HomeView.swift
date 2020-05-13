//
//  HomeView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var showingDetail = false
    var body: some View {
        NavigationView {
            Text("Home")
                .navigationBarTitle("Home", displayMode: .automatic)
                .navigationBarItems(trailing: Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)

                }).sheet(isPresented: $showingDetail) {
                    ItemListView()
                }
        }
}

struct ItemListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showModal = false
    var body: some View {
        NavigationView {
            ZStack {
                HStack(spacing: 50) {
                    VStack(spacing: 50) {
                        ItemButton(name: "Login", imageName: "person.2.square.stack.fill", destination: LoginItemView())
                        
                        ItemButton(name: "Debt Card", imageName: "creditcard.fill", destination: LoginItemView())
                    }
                    VStack(spacing: 50) {
                        ItemButton(name: "Identity", imageName: "person.crop.square.fill", destination: LoginItemView())
                        ItemButton(name: "Note", imageName: "doc.text.fill", destination: LoginItemView())
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.colorScheme, .dark)
    }
}