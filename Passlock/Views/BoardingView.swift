//
//  BoardingView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/23.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct BoardingView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var AuthService: AuthenticationService
    @State var password = ""

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("LockPass")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }.padding(.top, 50)
            Spacer()
            VStack {
                Text("Welcome To LockPass.\nPlease Enter Master Key:")
                    .font(.system(size: 25))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.white)
                    SecureField("Secret Key...", text: $password, onCommit: {
                        KeyChainManager().storeKeyBioMetric(data: self.password)
                        self.AuthService.initDB()
                        self.settings.isFirstLaunch = false
                        self.AuthService.isAuthorized = true
                        print(self.settings.isFirstLaunch)
                        self.presentation.wrappedValue.dismiss()
                    })
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .frame(height: 50)
                .border(Color.white, width: 3)
                .cornerRadius(3)

            }.padding(.horizontal, 30)
//            Button(action: {
//                // KeyChainManager().storeKeyBioMetric(data: self.password)
//                self.AuthService.initDB()
//                self.settings.isFirstLaunch = false
//                self.AuthService.isAuthorized = true
//                print(self.settings.isFirstLaunch)
//                self.presentation.wrappedValue.dismiss()
//            }, label: { Text("Click me").foregroundColor(.white) })
            Spacer()
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.orange)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView().environment(\.colorScheme, .dark)
    }
}
