//
//  CreditCardModel.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation


// Intializing Login Credentials Data type which supports:
// Uniqe ID - Title of Credit Card - Bank Name - Card Name - Card Holder Name - Expiration Date - CVV.
struct CreditCardItem: Identifiable,Codable
{
    let id = UUID().uuidString
    let title: String
    let bankName: String
    let cardNumber: String
    let cardHolderName: String
    let expirationDate: Date
    let cvv: Int
}
