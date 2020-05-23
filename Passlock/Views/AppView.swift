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
    @State private var isTimerActive = true

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
            }
            // Setting AutoLock Serivce
            .onReceive(AuthService.timer) { _ in

                // Countdown the locking time.
                if self.lockTime > 0 {
                    self.lockTime -= 1
                } else { // lock app
                    self.AuthService.isAuthorized = false
                    // reset autoLock time
                    self.lockTime = self.settings.autoLockTime
                    // stop timer
                    self.AuthService.stopTimer()
                }
                print(self.lockTime)
            }
            .onAppear {
                // set autoLock Time
                self.lockTime = self.settings.autoLockTime
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(lockTime: 100).environment(\.colorScheme, .dark)
    }
}
