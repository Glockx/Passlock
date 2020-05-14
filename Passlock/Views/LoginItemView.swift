//
//  LoginItemView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/12.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct LoginItemView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var website = ""
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State private var titleIsEmpty = true

    var body: some View {
        let binding = Binding<String>(get: {
            self.title
        }, set: {
            self.title = $0
            if $0 != "" {
                self.titleIsEmpty = false
            } else {
                self.titleIsEmpty = true
            }
        })

        return NavigationView {
            // Title of Data - Username - Email - Password - Name of the website.
            VStack(spacing: 20) {
                LabelTextField(label: "Title", placeHolder: "Fill in the Title...", text: binding).padding(.top, 15)
                    .autocapitalization(.none)
                LabelTextField(label: "Website", placeHolder: "Fill in the Website name...", text: $website)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                LabelTextField(label: "Username", placeHolder: "Fill in the Username...", text: $username)
                    .autocapitalization(.none)
                LabelTextField(label: "Email", placeHolder: "Fill in the Email...", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureLabelTextField(label: "Password", placeHolder: "Fill in the Password...", text: $password)
                    .autocapitalization(.none)

                    .navigationBarTitle("Credit Card", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Cancel").foregroundColor(.orange)
                    }))
                Button(action: {
                    // Function: Create LoginItem with user input and push to DB
                    let item = LoginItem(id: UUID().uuidString, title: self.title, username: self.username, email: self.email, password: self.password, website: self.website)
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let SQLManager = delegate.SQLite

                    // Push item to DB
                    SQLManager?.insertItemToDB(item: item, table: SQLManager!.loginCredentialsTable)
                    
                    // Dissmis Self
                    self.presentationMode.wrappedValue.dismiss()
                    
                    print()
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 45)
                }).frame(width: 300, height: 45)
                    .background(self.titleIsEmpty ? Color(.systemGray5) : Color.orange)
                    .cornerRadius(5)
                    .padding(.top, 25).padding(.horizontal, 30)
                    .disabled(self.titleIsEmpty ? true : false)
                Spacer()
            }
        }
    }
}

struct LoginItemView_Previews: PreviewProvider {
    static var previews: some View {
        LoginItemView(title: "", website: "", username: "", email: "", password: "").colorScheme(.dark)
    }
}
