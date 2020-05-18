//
//  CreditCardItemCell.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/17.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct CreditCardItemCell: View
{
     @State var creditCard: CreditCardItem
    var body: some View {
            HStack(spacing: 15) {
            Image(systemName: "c.square.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: 45, height: 45)

            VStack(alignment: .leading, spacing: 10) {
                Text(creditCard.bankName)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                Text(String("**** **** " + creditCard.cardNumber.suffix(4)))
                    .font(.headline)
            }
        }

    }
}

struct CreditCardItemCell_Previews: PreviewProvider
{
    static var item = CreditCardItem(id: "123", title: "Xalqlar", bankName: "Access", cardNumber: "1238541453545356", cardHolderName: "Nijat Muzaffarli", expirationDate: Date(), cardPin: 7894, cardCvv: 252)
    static var previews: some View {
        CreditCardItemCell(creditCard: item)
    }
}
