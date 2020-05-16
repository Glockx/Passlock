//
//  LoginItemDetailsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/16.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct LoginItemDetailsView: View {
    @State var LoginItem: LoginItem
    var body: some View {
        Form {
            StringTypeSection(mainTitle: "Website:", variable: LoginItem.website, icon: "globe")
            StringTypeSection(mainTitle: "Username:", variable: LoginItem.username, icon: "person.fill")
            StringTypeSection(mainTitle: "Email:", variable: LoginItem.email, icon: "envelope.fill")
            StringTypeSection(mainTitle: "Password:", variable: LoginItem.password, icon: "shield.fill")

        }.padding(.top,30)
        .navigationBarTitle(LoginItem.title)
        .navigationBarBackButtonHidden(false)
    }
}

struct LoginItemDetailsView_Previews: PreviewProvider {
    static var item = LoginItem(id: "er", title: "Facebook - Nijat", username: "nicat754", email: "nicat754@gmail.com", password: "test123", website: "facebook.com")
    static var previews: some View {
        LoginItemDetailsView(LoginItem: item).environment(\.colorScheme, .dark)
    }
}
