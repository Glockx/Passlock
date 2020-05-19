//
//  SettingsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    // MARK: Intializing Verions and Build Numbers

    @State var version = Bundle.main.releaseVersionNumber
    @State var buildNumber = Bundle.main.buildVersionNumber
    @State private var enableAutoLockMode = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Master Key")) {
                    Button(action: {}, label: {
                        Text("Change Master Key")
                    })
                }
                Section(header: Text("Auto Lock Mode")) {
                    Toggle(isOn: $enableAutoLockMode) {
                        Text("Auto Lock")
                    }.onAppear {
                        UISwitch.appearance().onTintColor = UIColor.orange
                    }

                    Button(action: { print("Hello") }, label: {
                        Text("Set Auto Lock Time")
                    })
                }

                Text("Version: \(version!) - Build: \(buildNumber!)")
                    .multilineTextAlignment(.center)
                    .navigationBarTitle("Settings", displayMode: .automatic).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
