//
//  CreditCardModel.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation

// Intializing Credit Card Data type which supports:
// Uniqe ID - Title of Credit Card - Bank Name - Card Name - Card Holder Name - Expiration Date: Date - Card Pin: Int64 - CVV: Int64 .
struct CreditCardItem: Item {
    let id: String
    let title: String
    let bankName: String
    let cardNumber: String
    let cardHolderName: String
    let expirationDate: Date
    let cardPin: Int
    let cardCvv: Int
}
