//
//  NoteItemCreationView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/18.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct NoteItemCreationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var note = ""
    @State private var titleIsEmpty = true
    @State private var isEditing = false
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

        // Title of Note - Date of Note - Text buffer.
        return NavigationView {
            VStack {
                LabelTextField(label: "Title", placeHolder: "Fill in the Title...", text: binding).autocapitalization(.none).padding(.vertical, 15)
                VStack(alignment: .leading)
                {
                    Text("Note").font(.headline).padding(.horizontal,15)
                    
                    NoteTextField(text: $note, isEditing: $isEditing, placeholder: "Enter The Note...",placeholderHorizontalPadding: 10, placeholderVerticalPadding: 10)
                        
                        .border(Color.orange, width: 3)
                        .padding(.horizontal, 15)
                        .navigationBarTitle("Login", displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Cancel").foregroundColor(.orange)
                        }))
                }

                Button(action: {
                    // Function: Create LoginItem with user input and push to DB
                    let item = NoteItem(id: UUID().uuidString, title: self.title, date: Date(), textBlob: self.note)

                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let SQLManager = delegate.SQLite

                    // Push item to DB
                    SQLManager?.insertItemToDB(item: item, table: SQLManager!.notesTable)

                    // Send changes to ItemStore
                    SQLManager?.retrieveItems()

                    // Dissmis Self
                    self.presentationMode.wrappedValue.dismiss()
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

struct NoteItemCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NoteItemCreationView()
    }
}
