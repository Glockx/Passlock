//
//  Note.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation


struct NoteItem: Identifiable,Codable
{
    let id = UUID().uuidString
    let date: Date
    let textBlob: String
}
