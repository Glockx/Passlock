//
//  SettingsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import LocalAuthentication
import SwiftUI
struct SettingsView: View {
    // MARK: Intializing Verions and Build Numbers

    @State var version = Bundle.main.releaseVersionNumber
    @State var buildNumber = Bundle.main.buildVersionNumber
    @ObservedObject var settings = UserSettings()
    @EnvironmentObject var AuthService: AuthenticationService
    @State var timeList = [0.5, 1, 3, 5, 10, 15, 30, 60].map { $0 * 60 }
    @State private var selectedTimeIndex = 1
    @State private var text = ""
    @State var showingActivityController = false
    @State var showingDocumentViewController = false
    @State var showingErrorAlert = false
    @State var showingAlertWithTextView = false
    @State var newPath = ""
    var db = NSURL(fileURLWithPath: SQLiteManager().createDBFilePath(fileName: "db.sqlite3"))
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Master Key")) {
                    SecureField("Password", text: $text)
                    Button(action: {
                        // If pass is not save it to SecureEnclave with Biometrich Authentication
                        if !self.text.isEmpty {
                            KeyChainManager().storeKeyBioMetric(data: self.text)

                            let delegate = UIApplication.shared.delegate as! AppDelegate
                            let SQLManager = delegate.SQLite

                            SQLManager?.changeDBKey(key: KeyChainManager().retrieveKeyBioMetric())
                            self.text = ""
                        }
                    }, label: {
                        Text("Change Master Key")
                    })
                }
                Section(header: Text("Auto Lock Mode")) {
                    Toggle(isOn: $settings.isAutoLockEnabled) {
                        Text("Auto Lock")
                    }.onAppear {
                        UISwitch.appearance().onTintColor = UIColor.orange
                    }.onReceive(Just(self.settings.isAutoLockEnabled)) { value in

                        if !value {
                            (UIApplication.shared as? InactivityTrackingApplication)?.stopTracking()
                        }
                    }

                    Picker(selection: $selectedTimeIndex, label: Text("Set Auto Lock Time").foregroundColor(.orange)) {
                        ForEach(0 ..< timeList.count) {
                            if self.timeList[$0] == 30 {
                                Text("\(String(Int(self.timeList[$0]))) Seconds")
                            } else if self.timeList[$0] == 60 {
                                Text("\(String(Int(self.timeList[$0]) / 60)) Minute")
                            } else {
                                Text("\(String(Int(self.timeList[$0]) / 60)) Minutes")
                            }
                        }
                    }

                    Button(action: { self.AuthService.isAuthorized = false }, label: { Text("Lock the app!") })
                }
                Section(header: Text("File Management")) {
                    // Import Button
                    Button(action: { self.showingDocumentViewController.toggle() }, label: { Text("Import Database") }).sheet(isPresented: self.$showingDocumentViewController) {
                        FilePickerController { file in

                            if file.pathExtension == "sqlite3" {
                                self.showingAlertWithTextView.toggle()
                                self.newPath = file.absoluteString
                                print("newPath: ",self.newPath)
                            } else {
                                self.showingErrorAlert.toggle()
                            }
                        }
                    }.alert(isPresented: self.$showingErrorAlert) {
                        Alert(title: Text("Error"), message: Text("Please Choose Database file with '.sqlite3' extension!"), dismissButton: .destructive(Text("Okay")))
                    }

                    // Export Button
                    Button(action: {
                        self.showingActivityController.toggle()

                    }, label: { Text("Export Database") })
                        .sheet(isPresented: $showingActivityController) {
                            ExportActivityView(showingModal: self.$showingActivityController, activityItems: [self.db] as [Any], applicationActivities: nil)
                        }
                }
                .onReceive(Just(self.selectedTimeIndex)) { value in

                    // Set AutoLock Time
                    UserSettings().autoLockTime = Double(self.timeList[value])

                    // Reset Lock Timer
                    (UIApplication.shared as? InactivityTrackingApplication)?.stopTracking()
                    (UIApplication.shared as? InactivityTrackingApplication)?.startTracking(timeOut: Double(self.timeList[value]))
                }

                Text("Version: \(version!) - Build: \(buildNumber!)")
                    .multilineTextAlignment(.center)
                    .navigationBarTitle("Settings", displayMode: .automatic)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }.alert(isPresented: self.$showingAlertWithTextView, TextAlert(title: "If Database file is encrypted,please enter encryption key. \n Else new key for encryption.", action: { key in// the reason why we added alert to this View is that Text alert pushes Button text to middle of cell.
                if !key!.isEmpty{
                     //Replace old db encryption key with new key
                    KeyChainManager().storeKeyBioMetric(data: key!)

                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let SQLManager = delegate.SQLite

                    SQLManager?.changeDBKey(key: KeyChainManager().retrieveKeyBioMetric())
                    SQLManager?.connectToDb()
                }
            }))
        }.onAppear {
            // Index of saved autoLock time
            self.selectedTimeIndex = self.timeList.firstIndex(of: Double(Int(UserSettings().autoLockTime)))!
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
