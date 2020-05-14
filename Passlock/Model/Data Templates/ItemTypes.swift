//
//  ItemTypes.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/11.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation

enum ItemTypes: String, Codable,CaseIterable,RawRepresentable
{
    case LoginItem
    case CreditCardItem
    case NoteItem
    case IdentityItem
}

protocol Item: Codable
{
    var id: String { get set }
    var kind:String {get set}
}


// Intializing Identity Data type which supports:
// Uniqe ID - Name - Middle Name - Last Name - Gender - Birth Date - National ID Number
struct IdentityItem: Item, Equatable,Identifiable {
    var kind: String = "IdentityItem"
    var id: String
    let name: String
    let middleName: String
    let lastName: String
    let gender: String
    let birthDate: Date
    let nationalID: String
}

// Intializing Note Data type which supports:
// Uniqe ID - Title of Note - Date of Note - Text buffer.
struct NoteItem: Item, Equatable,Identifiable {
    var kind: String = "NoteItem"
    var id: String
    let title: String
    let date: Date
    let textBlob: String
}

// Intializing Credit Card Data type which supports:
// Uniqe ID - Title of Credit Card - Bank Name - Card Name - Card Holder Name - Expiration Date: Date - Card Pin: Int64 - CVV: Int64 .
struct CreditCardItem: Item, Equatable,Identifiable {
    var kind: String = "CreditCardItem"
    var id: String
    let title: String
    let bankName: String
    let cardNumber: String
    let cardHolderName: String
    let expirationDate: Date
    let cardPin: Int
    let cardCvv: Int
}

// Intializing Login Credentials Data type which supports:
// Uniqe ID - Title of Data - Username - Email - Password - Name of the website.
struct LoginItem: Item, Equatable,Identifiable {
    var kind: String = "LoginItem"
    var id: String
    let title: String
    let username: String
    let email: String
    let password: String
    let website: String
}
