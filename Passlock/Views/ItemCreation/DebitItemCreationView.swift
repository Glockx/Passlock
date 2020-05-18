//
//  DebitItemCreationView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/17.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct DebitItemCreationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var bankName = ""
    @State var cardName = ""
    @State var cardNumber = ""
    @State var cardHolder = ""
    @State var expiration = Date()
    @State var cardPin = ""
    @State var cvv = ""
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
                    // Title of Credit Card - Bank Name - Card Number - Card Name - Card Holder Name - Expiration Date: Date - Card Pin: Int64 - CVV: Int64
                    LabelTextField(label: "Title", placeHolder: "Fill in the Title...", text: binding).padding(.top, 15)
                        .autocapitalization(.none)
                    LabelTextField(label: "Bank Name", placeHolder: "Fill in the Bank Name...", text: $bankName)
                    LabelTextField(label: "Card Number", placeHolder: "Fill in the Card Number...", text: $cardNumber).keyboardType(.decimalPad)
                    LabelTextField(label: "Card Holder Name", placeHolder: "Fill in the Card Holder Name...", text: $cardHolder).autocapitalization(.none)
                    DatePickerView(title: "Expiration Date", wakeUp: expiration)
                    SecureLabelTextField(label: "Card Pin", placeHolder: "Fill in the Card Pin...", text: $cardPin).keyboardType(.decimalPad)
                    SecureLabelTextField(label: "Card CVC", placeHolder: "Fill in the Card CVC...", text: $cvv).keyboardType(.decimalPad)
                        .navigationBarTitle("Debit Card", displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Cancel").foregroundColor(.orange)
                        }))
                    Button(action: {
                        // Function: Create LoginItem with user input and push to DB
                        let item = CreditCardItem(id: UUID().uuidString, title: self.title, bankName: self.bankName, cardNumber: self.cardNumber, cardHolderName: self.cardHolder, expirationDate: self.expiration, cardPin: Int(self.cardPin) ?? 0, cardCvv: Int(self.cvv) ?? 0)

                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let SQLManager = delegate.SQLite

                        // Push item to DB
                        SQLManager?.insertItemToDB(item: item, table: SQLManager!.creditCardsTable)

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
}

struct DebitItemCreationView_Previews: PreviewProvider {
    static var previews: some View {
        DebitItemCreationView().environment(\.colorScheme, .dark)
    }
}
