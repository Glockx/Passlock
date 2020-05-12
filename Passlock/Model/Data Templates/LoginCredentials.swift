//
//  LoginCredentials.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import CryptoKit
import Foundation

// Intializing Login Credentials Data type which supports:
// Uniqe ID - Title of Data - Username - Email - Password - Name of the website.
struct LoginItem: Item {
    let id: String
    let title: String
    let username: String
    let email: String
    let password: String
    let website: String
}
