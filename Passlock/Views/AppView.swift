//
//  ContentView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import Valet

struct AppView: View {
    // Current selected Tab item number
    @State var selectedView = 0
    @State private var shareShown = false
    @EnvironmentObject var AuthService: AuthenticationService
    @State var errorMessage = ""
    @State var isAuthorized = false

    var body: some View {
        // Setting Main view of application with Home and Setting view
        TabView(selection: $selectedView) {
            if self.AuthService.isAuthorized {
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
            } else {
                VStack(spacing: 30) {
                    Button(action: { self.AuthService.authenticate { _, err in
                        self.errorMessage = err
                    } }, label: {
                        Image(systemName: "faceid")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.all)
                            .background(Color.orange)
                            .cornerRadius(16)
                            .foregroundColor(.white)
                    }).onAppear {
                        self.errorMessage = ""
                        self.AuthService.authenticate { _, err in
                            self.errorMessage = err
                        }
                    }
                    if !errorMessage.isEmpty {
                        Text(errorMessage).padding(.all).background(Color.red).foregroundColor(.white).multilineTextAlignment(.center).border(Color.red, width: 3).cornerRadius(16)
                    }
                }
            }

        }.accentColor(.orange).onReceive(AuthService.ApplicationStatePublisher) { notication in
            switch notication.name.rawValue {
            case "UIApplicationDidEnterBackgroundNotification":
                print("App has become deacitve")
                self.AuthService.isAuthorized = false
            default: break
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environment(\.colorScheme, .dark)
    }
}
