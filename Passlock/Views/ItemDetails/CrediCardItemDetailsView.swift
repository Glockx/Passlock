//
//  CrediCardItemDetailsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/17.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct CrediCardItemDetailsView: View
{
    @State var creditCardItem: CreditCardItem
    var body: some View {
        Form{
            //Title of Credit Card - Bank Name - Card Name - Card Holder Name - Expiration Date: Date - Card Pin: Int64 - CVV: Int64
            StringTypeSection(mainTitle: "Bank Name:", variable: creditCardItem.bankName, icon: "b.square.fill")
            StringTypeSection(mainTitle: "Card Holder:", variable: creditCardItem.cardHolderName, icon: "person.fill")
            StringTypeSection(mainTitle: "Card Number:", variable: creditCardItem.cardNumber, icon: "creditcard.fill")
            StringTypeSection(mainTitle: "Expiry Date:", variable:  dateToString(date: creditCardItem.expirationDate), icon: "calendar")
            StringTypeSection(mainTitle: "CVC:", variable: String(creditCardItem.cardCvv), icon: "lock.shield.fill")
            StringTypeSection(mainTitle: "Card Pin:", variable: String(creditCardItem.cardPin), icon: "shield.fill")
        }.padding(.top, 30)
        .navigationBarTitle(creditCardItem.title)
        .navigationBarBackButtonHidden(false)
    }
}

private func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"

    return dateFormatter.string(from: date)
}

struct CrediCardItemDetailsView_Previews: PreviewProvider
{
     static var item = CreditCardItem(id: "123", title: "Xalqlar", bankName: "Access", cardNumber: "1238541453545356", cardHolderName: "Nijat Muzaffarli", expirationDate: Date(), cardPin: 7894, cardCvv: 224)
    static var previews: some View {
        CrediCardItemDetailsView(creditCardItem: item)
    }
}
