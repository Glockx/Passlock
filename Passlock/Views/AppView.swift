//
//  ContentView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SwiftUI

struct AppView: View {
    // Current selected Tab item number
    @State var selectedView = 0
    
    var body: some View {
        // Setting Main view of application with Home and Setting view
        TabView(selection: $selectedView) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Main")
                }.tag(0)

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(1)
        }.onAppear(perform:
            {
            // Accessing SQLiteHelper from Delegetion of app
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let sql = delegate.self?.SQLite
                
            let test = LoginItem(title: "facebook", username: "nicat754", email: "nicat754@gmail.com", password: "123", website: "facebook.com")
                
            sql?.insertLoginCredentialItem(item: test)
                sql?.printt()
        })
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
