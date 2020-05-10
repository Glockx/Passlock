//
//  SettingsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Intializing Verions and Build Numbers

    @State var version = Bundle.main.releaseVersionNumber
    @State var buildNumber = Bundle.main.buildVersionNumber

    var body: some View {
        NavigationView {
            Text("Version: \(version!) - Build: \(buildNumber!)")
                .navigationBarTitle("Settings", displayMode: .automatic)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
