//
//  HomeView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI





struct HomeView: View
{
    
    @State var showingDetail = false
    @State private var allItems = [Item]()
    @State private var LoginItems = [LoginItem]()
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
                ItemCreation()
            }
        }.onAppear {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let SQLManager = delegate.SQLite

            self.allItems = SQLManager?.retrieveAllItems() as! [Item]
        }
    }
    
    
     //- Function: Build Cell For Each type of Item
//    func buildView<T: Item>(types: ItemTypes,item: T) -> AnyView
//    {
//
//        switch types {
//        case .LoginItem:
//            Item
//            return AnyView(LoginItemCell(title: "fa", username: "String"))
//        case "CreditCardItem": return AnyView(LoginItemCell())
//        case "NoteItem" :return AnyView(LoginItemCell())
//        case "IdentityItem": return AnyView(LoginItemCell())
//        default: return AnyView(EmptyView())
//        }
//    }

    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView().environment(\.colorScheme, .dark)
        }
    }
}
  extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
      init(values: Data, content: @escaping (Data.Element) -> Content) {
          self.init(values, id: \.self, content: content)
      }
  }
