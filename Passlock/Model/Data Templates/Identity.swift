//
//  Identity.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation

// Intializing Identity Data type which supports:
// Uniqe ID - Name - Middle Name - Last Name - Gender - Birth Date - National ID Number
struct IdentityItem: Item
{
    let id: String
    let name: String
    let middleName: String
    let lastName: String
    let gender: String
    let birthDate: Date
    let nationalID: String
}
