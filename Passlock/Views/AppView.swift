//
//  ContentView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SwiftUI
import Valet

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
        }.accentColor(.orange)
         
    }
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environment(\.colorScheme, .dark)
    }
}
