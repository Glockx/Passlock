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
    @EnvironmentObject var settings: UserSettings
    @State var errorMessage = ""
    @State var isAuthorized = false
    @State var lockTime = 0

    var body: some View {
        // Setting Main view of application with Home and Setting view
        TabView(selection: $selectedView) {
            if self.AuthService.isAuthorized || !settings.isAutoLockEnabled {
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
                    Button(action: { self.AuthService.authenticate { err in
                        self.errorMessage = err
                    } }, label: {
                        Image(systemName: "faceid")
                            .imageAsFaceID()

                    }).onAppear {
                        self.errorMessage = ""
                        self.AuthService.authenticate { err in
                            self.errorMessage = err
                        }
                    }.onDisappear {
                        // When user is authorized start tracking user inactivity again
                        (UIApplication.shared as? InactivityTrackingApplication)?.startTracking()
                    }
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .textAsError()
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .background(Color.orange)
            }

        }.accentColor(.orange)
            // Lock the app when user left
            .onReceive(AuthService.ApplicationStatePublisher) { notication in
                switch notication.name.rawValue {
                case "UIApplicationDidEnterBackgroundNotification":
                    print("App has become deacitve")
                    self.AuthService.isAuthorized = false
                default: break
                }
                // Observe user inactivity and lock the app
            }.onReceive(NotificationCenter.default.publisher(for: .applicationInactivityTimeOut)) { _ in
                self.AuthService.isAuthorized = false
            }
            .onAppear {
                // set autoLock Time
                (UIApplication.shared as? InactivityTrackingApplication)?.startTracking(timeOut: self.settings.autoLockTime)
            }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(lockTime: 100).environment(\.colorScheme, .dark)
    }
}
