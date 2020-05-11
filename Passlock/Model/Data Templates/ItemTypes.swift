//
//  ItemTypes.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/11.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation

protocol Item: Codable {
}


enum ItemTypes: String{
    
    case LoginCredentials = "LoginCredentials"
    case CreditCard = "CreditCard"
    case Note = "Note"
    case Identity = "Identity"
}
