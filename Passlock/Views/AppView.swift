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
    @EnvironmentObject var logger: LoggerService
    @State private var passText = ""
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
                        VStack {
                            SecureField("Master Key", text: $passText, onCommit: {
                                let delegate = UIApplication.shared.delegate as! AppDelegate
                                let sqlManager = delegate.SQLite

                                if self.passText == sqlManager?.DBVersion {
                                    self.AuthService.isAuthorized = true
                                    self.passText = ""
                                } else {
                                    self.errorMessage = "Master key is wrong,please try again!"
                                }
                            })
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .frame(height: 50)
                                .border(Color.white, width: 3)
                                .cornerRadius(3)
                        }.padding(.horizontal, 30)

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

        }.alert(isPresented: self.$logger.isLogging) {
            Alert(title: Text("Attention!"),
                  message: Text(" Your Device Has Been Jailbroken! "),
                  dismissButton: .destructive(Text("Exit")) { exit(0) })
        }
        .accentColor(.orange)
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
            print("is first launch: ", self.settings.isFirstLaunch)
            // Check If db has connected and it is first launch of app
            if !self.AuthService.dbHasConnected {
                if !self.settings.isFirstLaunch {
                    self.AuthService.initDB()
                }
                // Check Jailbreak
                self.logger.logAll()
            }
            print("authorized")
            // set autoLock Time
            if self.settings.isAutoLockEnabled {
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
