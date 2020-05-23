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
    @State var errorMessage = ""
    @State private var shareShown = false
    @EnvironmentObject var AuthService: AuthenticationService
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        // Setting Main view of application with Home and Setting view
        TabView(selection: $selectedView) {
            if self.AuthService.isAuthorized || !settings.isAutoLockEnabled {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }.tag(0).onAppear {}

                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(1)
            } else {
                if !self.settings.isFirstLaunch {
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
                        .edgesIgnoringSafeArea(.all)
                } else {
                    BoardingView().onAppear()
                }
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
                // authenticated successfully
                
                if !self.AuthService.dbHasConnected {
                    self.AuthService.initDB()
                }
                print("authorized")
                // set autoLock Time
                if self.settings.isAutoLockEnabled{
                    (UIApplication.shared as? InactivityTrackingApplication)?.startTracking(timeOut: self.settings.autoLockTime)
                }
                
            }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environment(\.colorScheme, .dark)
    }
}
