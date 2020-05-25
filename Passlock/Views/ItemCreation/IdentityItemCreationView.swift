//
//  IdentityItemCreationView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/16.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct IdentityItemCreationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var name = ""
    @State var middleName = ""
    @State var lastName = ""
    @State var gender = ""
    @State var birthDate = ""
    @State var nationID = ""
    @State var birth = Date()
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
            ScrollView {
                VStack(spacing: 20) {
                    // Name - Middle Name - Last Name - Gender - Birth Date - National ID Number
                    LabelTextField(label: "Title", placeHolder: "Fill in the Title...", text: binding).padding(.top, 15)
                        .autocapitalization(.none)
                    LabelTextField(label: "Name", placeHolder: "Fill in the Name...", text: $name)
                        .autocapitalization(.none)
                    LabelTextField(label: "Middle Name (Optional)", placeHolder: "Fill in the Middle Name...", text: $middleName)
                        .autocapitalization(.none)
                    LabelTextField(label: "Last Name", placeHolder: "Fill in the Last Name...", text: $lastName)
                        .autocapitalization(.none)
                    LabelTextField(label: "Gender", placeHolder: "Fill in the Gender...", text: $gender)
                        .autocapitalization(.none)
                    DatePickerView(title: "Birth Date", wakeUp: birth)
                    LabelTextField(label: "National ID Number", placeHolder: "Fill in the National ID Number...", text: $nationID).autocapitalization(.none)
                        .navigationBarTitle("Identity", displayMode: .inline)
                        .navigationBarItems(leading: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Cancel").foregroundColor(.orange)
                        }), trailing: Button(action: {
                            self.saveItem()
                        }, label: {
                            Text("Done").foregroundColor(self.titleIsEmpty ? Color(.systemGray2) : Color.orange)
                        }).disabled(self.titleIsEmpty ? true : false))
                }
                Button(action: {
                    self.saveItem()
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

    func saveItem() {
        // Function: Create LoginItem with user input and push to DB
        let item = IdentityItem(id: UUID().uuidString, title: title, name: name, middleName: middleName, lastName: lastName, gender: gender, birthDate: birth, nationalID: nationID)

        let delegate = UIApplication.shared.delegate as! AppDelegate
        let SQLManager = delegate.SQLite

        // Push item to DB
        SQLManager?.insertItemToDB(item: item, table: SQLManager!.identityTable)

        // Send changes to ItemStore
        SQLManager?.retrieveItems()

        // Dissmis Self
        presentationMode.wrappedValue.dismiss()
    }
}

struct IdentityItemCreationView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityItemCreationView().environment(\.colorScheme, .dark)
    }
}
