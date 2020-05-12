//
//  Note.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation

// Intializing Note Data type which supports:
// Uniqe ID - Title of Note - Date of Note - Text buffer.
struct NoteItem: Item {
    let id: String
    let title: String
    let date: Date
    let textBlob: String
}
