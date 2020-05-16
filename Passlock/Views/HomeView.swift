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
    @ObservedObject var itemRepo: ItemStore = ItemStore.shared
    var body: some View {
        NavigationView {
            List(itemRepo.loginItems) { item in
                self.buildView(item: item)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(trailing: Button(action: {
                self.showingDetail.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)

            }).sheet(isPresented: $showingDetail) {
                ItemCreation()
            }
        }.onAppear {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let SQLManager = delegate.SQLite

            SQLManager?.retrieveItems()
            self.itemRepo.allItems = [self.itemRepo.creditCardItems, self.itemRepo.identityItems, self.itemRepo.loginItems, self.itemRepo.noteItems]
        }
    }

    // - Function: Build Cell For Each type of Item
    func buildView<T: Item>(item: T) -> AnyView {
        switch item.kind {
        case "LoginItem":
            return AnyView(NavigationLink(destination: LoginItemDetailsView(LoginItem: item as! LoginItem)){LoginItemCell(item: item as! LoginItem)})
//        case "CreditCardItem": return AnyView(LoginItemCell())
//        case "NoteItem" :return AnyView(LoginItemCell())
//        case "IdentityItem": return AnyView(LoginItemCell())
        default: return AnyView(EmptyView())
        }
    }

    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView().environment(\.colorScheme, .dark)
        }
    }
}
