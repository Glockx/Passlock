//
//  HomeView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    @State var showingDetail = false
    @ObservedObject var itemRepo: ItemStore = ItemStore.shared
    var body: some View {
        NavigationView {
            List {
                Group {
                    if !itemRepo.loginItems.isEmpty {
                        Text("LOGIN").fontWeight(.bold).padding(.top, 10).foregroundColor(.orange)
                        ForEach(itemRepo.loginItems, id: \.self) { item in
                            self.buildView(item: item)
                        }.onDelete(perform: loginDelete)
                        Divider()
                    }
                    if !itemRepo.identityItems.isEmpty {
                        Text("IDENTITY").fontWeight(.bold).padding(.top, 10).foregroundColor(.orange)

                        ForEach(itemRepo.identityItems, id: \.self) { item in
                            self.buildView(item: item)
                        }.onDelete(perform: identityDelete)

                        Divider()
                    }
                    if !itemRepo.creditCardItems.isEmpty {
                        Text("DEBIT CARD").fontWeight(.bold).foregroundColor(.orange)
                        ForEach(itemRepo.creditCardItems, id: \.self) { item in
                            self.buildView(item: item)
                        }.onDelete(perform: cardDelete)
                        Divider()
                    }
                    if !itemRepo.noteItems.isEmpty {
                        Text("NOTE").fontWeight(.bold).foregroundColor(.orange)
                        ForEach(itemRepo.noteItems) { item in
                            self.buildView(item: item)
                        }.onDelete(perform: noteDelete)
                    } else {
                        HStack {
                            Image(systemName: "tray.fill")
                                .foregroundColor(.orange)
                                .font(.title)

                            Text("Items has not added yet.")
                                .foregroundColor(.orange)
                                .font(.headline)
                                .fontWeight(.heavy)

                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    }
                }
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
            // To remove eparators from the list:
            UITableView.appearance().separatorColor = .clear
            
            // Retrieve Items on First Launch
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let SQLManager = delegate.SQLite

            SQLManager?.retrieveItems()
        }
    }

    // - Function: Delete Login Item
    private func loginDelete(at offsets: IndexSet) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let SQLManager = delegate.SQLite

        // For deleting Item from DB,first finding item from LoginItems array and passing it as argument
        for offset in offsets {
            let itemIndex = itemRepo.loginItems.index(itemRepo.loginItems.startIndex, offsetBy: offset)
            let item = itemRepo.loginItems[itemIndex]

            SQLManager!.deleteItemFromDb(item: item, table: SQLManager!.loginCredentialsTable)
        }

        // Remove Item from LoginItems array
        itemRepo.loginItems.remove(atOffsets: offsets)
    }

    // - Function: Delete Identity Item
    private func identityDelete(at offsets: IndexSet) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let SQLManager = delegate.SQLite

        // For deleting Item from DB,first finding item from identityItems array and passing it as argument
        for offset in offsets {
            let itemIndex = itemRepo.identityItems.index(itemRepo.identityItems.startIndex, offsetBy: offset)
            print(itemIndex)
            let item = itemRepo.identityItems[itemIndex]

            SQLManager!.deleteItemFromDb(item: item, table: SQLManager!.identityTable)
        }

        itemRepo.identityItems.remove(atOffsets: offsets)
    }

    // - Function: Delete Identity Item
    private func cardDelete(at offsets: IndexSet) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let SQLManager = delegate.SQLite

        // For deleting Item from DB,first finding item from creditCardItems array and passing it as argument
        for offset in offsets {
            let itemIndex = itemRepo.creditCardItems.index(itemRepo.creditCardItems.startIndex, offsetBy: offset)
            print(itemIndex)
            let item = itemRepo.creditCardItems[itemIndex]

            SQLManager!.deleteItemFromDb(item: item, table: SQLManager!.creditCardsTable)
        }

        itemRepo.creditCardItems.remove(atOffsets: offsets)
    }

    // - Function: Delete Identity Item
    private func noteDelete(at offsets: IndexSet) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let SQLManager = delegate.SQLite

        // For deleting Item from DB,first finding item from creditCardItems array and passing it as argument
        for offset in offsets {
            let itemIndex = itemRepo.noteItems.index(itemRepo.noteItems.startIndex, offsetBy: offset)
            print(itemIndex)
            let item = itemRepo.noteItems[itemIndex]

            SQLManager!.deleteItemFromDb(item: item, table: SQLManager!.notesTable)
        }

        itemRepo.noteItems.remove(atOffsets: offsets)
    }

    // - Function: Build Cell For Each type of Item
    func buildView<T: Item>(item: T) -> AnyView {
        switch item.kind {
        case "LoginItem":
            return AnyView(NavigationLink(destination: LoginItemDetailsView(LoginItem: item as! LoginItem)) { LoginItemCell(item: item as! LoginItem) })
        case "CreditCardItem": return AnyView(NavigationLink(destination: CrediCardItemDetailsView(creditCardItem: item as! CreditCardItem)) { CreditCardItemCell(creditCard: item as! CreditCardItem) })
        case "NoteItem": return AnyView(NavigationLink(destination: NoteItemDetailsView(noteItem: item as! NoteItem)) { NoteItemCell(noteItem: item as! NoteItem) })
        case "IdentityItem": return AnyView(NavigationLink(destination: IdentityItemDetailsView(identityItem: item as! IdentityItem)) { IdentityItemCell(identityItem: item as! IdentityItem) })
        default: return AnyView(EmptyView())
        }
    }

    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView().environment(\.colorScheme, .dark)
        }
    }
}
