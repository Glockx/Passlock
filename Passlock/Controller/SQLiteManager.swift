//
//  SQLiteHelper.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SQLite
import SwiftUI

// MARK: SQLite Class

// SQLiteHelper is controller and model class of application for handling all SQLite functions with much simple and clean way.
public class SQLiteManager {
    var path: String!
    var db: Connection!
    @ObservedObject var itemStore: ItemStore = ItemStore.shared
    // Init SQL table for login credentials
    let loginCredentialsTable = Table("loginCredentials")
    let creditCardsTable = Table("creditCards")
    let notesTable = Table("notes")
    let identityTable = Table("identity")

    // MARK: Initializer of class

    init() {
        // Binding empty path string with path of database file
        path = createDBFilePath(fileName: "db.sqlite3")

        // removeDB(localPathName: "db.sqlite3")
        // Database connections are established using the Connection class. A connection is initialized with a path to a database. SQLite will attempt to create the database file if it does not already exist.
        do {
            db = try Connection(.uri(path), readonly: false)
            // Encrypting the database with Master Key.
            try db.key("another secret")

            print("DB has created!")
        } catch let error {
            print(error)
        }
        // Enable built-in logging system of SQLite framework.
        #if DEBUG
            db.trace { print($0) }
        #endif
    }

    // - Function: Create Table and Statement for each Data Template
    func createTablesForDataTypes() {
        do {
            // MARK: Login Credentials Expressions

            // Uniqe ID - Title of Data - Username - Password - Email - Name of the website.

            // Creating Expression for each variable of LoginCredentials structure.

            let loginCredentialsKind = Expression<String>("kind")
            let loginCredentialsId = Expression<String>("id")
            let loginCredentialsTitle = Expression<String?>("title")
            let loginCredentialsUsername = Expression<String?>("username")
            let loginCredentialsEmail = Expression<String?>("email")
            let loginCredentialsPassword = Expression<String?>("password")
            let loginCredentialsWebsite = Expression<String?>("website")

            // Creating table for login credentials in database
            try db.run(loginCredentialsTable.create(ifNotExists: true) { t in // CREATE TABLE "users" (
                t.column(loginCredentialsKind) // "kind" TEXT,
                t.column(loginCredentialsId, primaryKey: true) // "id" TEXT PRIMARY KEY NOT NULL,
                t.column(loginCredentialsTitle) // "title" TEXT,
                t.column(loginCredentialsUsername) // "username" TEXT,
                t.column(loginCredentialsPassword) // "password" TEXT,
                t.column(loginCredentialsEmail) // "email" TEXT,
                t.column(loginCredentialsWebsite) // "website" TEXT,)
            })

            // MARK: Credit Card Expressions

            // Uniqe ID - Title of Credit Card - Bank Name - Card Name - Card Holder Name - Expiration Date: Date - Card Pin: Int - CVV: Int .

            let creditCardKind = Expression<String>("kind")
            let creditCardId = Expression<String>("id")
            let creditCardTitle = Expression<String?>("title")
            let creditCardBankName = Expression<String?>("bankName")
            let creditCardCardNumber = Expression<String?>("cardNumber")
            let creditCardHolderName = Expression<String?>("cardHolderName")
            let creditCardExpirationDate = Expression<Date?>("expirationDate")
            let creditCardCardPin = Expression<Int?>("cardPin")
            let creditCardCardCVV = Expression<Int?>("cardCvv")

            // Creating table for credit cards in database
            try db.run(creditCardsTable.create(ifNotExists: true) { t in // CREATE TABLE "creditCards" (
                t.column(creditCardKind) // "kind" TEXT,
                t.column(creditCardId, primaryKey: true) // "id" TEXT PRIMARY KEY NOT NULL,
                t.column(creditCardTitle) // "title" TEXT,
                t.column(creditCardBankName) // "bankName" TEXT,
                t.column(creditCardCardNumber) // "cardNumber" TEXT,
                t.column(creditCardHolderName) // "cardHolderName" TEXT,
                t.column(creditCardExpirationDate) // "expirationDate" TEXT,
                t.column(creditCardCardPin) // "cardPin" TEXT,
                t.column(creditCardCardCVV) // cardCVV)
            })

            // MARK: Note Expressions

            // Uniqe ID - Title of Note - Date of Note - Text buffer.

            let noteKind = Expression<String>("kind")
            let noteId = Expression<String>("id")
            let noteTitle = Expression<String?>("title")
            let noteDate = Expression<Date>("date")
            let noteTextBlob = Expression<String>("textBlob")

            // Creating table for notes in database
            try db.run(notesTable.create(ifNotExists: true) { t in
                t.column(noteKind)
                t.column(noteId, primaryKey: true)
                t.column(noteTitle)
                t.column(noteDate)
                t.column(noteTextBlob)
            })

            // MARK: Identity Expressions

            // Uniqe ID - Name - Middle Name - Last Name - Gender - Birth Date - National ID Number
            let identityKind = Expression<String>("kind")
            let identityId = Expression<String>("id")
            let identityTitle = Expression<String>("title")
            let identityName = Expression<String>("name")
            let identityMiddlename = Expression<String>("middleName")
            let identityLastName = Expression<String>("lastName")
            let identityGender = Expression<String>("gender")
            let identityBirthDate = Expression<Date>("birthDate")
            let identityNationalID = Expression<String>("nationalID")

            // Creating table for notes in database
            try db.run(identityTable.create(ifNotExists: true) { t in
                t.column(identityKind)
                t.column(identityId, primaryKey: true)
                t.column(identityTitle)
                t.column(identityName)
                t.column(identityMiddlename)
                t.column(identityLastName)
                t.column(identityGender)
                t.column(identityBirthDate)
                t.column(identityNationalID)
            })

        } catch let error {
            print(error)
        }
    }

    // - Function: Inserting Item to Database.
    func insertItemToDB<T: Codable>(item: T, table: Table) {
        do {
            try db.run(table.insert(item))
        } catch let error {
            print(error)
        }
    }
    // - Function: Delete Item from Database.
    func deleteItemFromDb<T: Item>(item: T,table: Table) {
        do{
            let id = Expression<String>("id")
            let item = table.filter(id == item.id)
            try db.run(item.delete())
            
        }catch let err{
            print(err)
        }
    }
    
    // - Function: Retrieve and Print Login Credentials
    func retrieveItems() {
        for category in ItemTypes.allCases {
            do {
                switch category.rawValue {
                // Retrive each LoginItem from Database, Decode it as JSON(Codable) and attach it to LoginItem structure
                case "LoginItem":
                    let loadedUsers: [LoginItem] = try db.prepare(loginCredentialsTable).map { row in
                        try row.decode()
                    }
                    itemStore.loginItems = loadedUsers

                case "CreditCardItem":
                    let loadedUsers: [CreditCardItem] = try db.prepare(creditCardsTable).map { row in
                        try row.decode()
                    }
                    itemStore.creditCardItems = loadedUsers

                case "NoteItem":
                    let loadedUsers: [NoteItem] = try db.prepare(notesTable).map { row in
                        try row.decode()
                    }
                    itemStore.noteItems = loadedUsers

                case "IdentityItem":
                    let loadedUsers: [IdentityItem] = try db.prepare(identityTable).map { row in
                        try row.decode()
                    }
                    itemStore.identityItems = loadedUsers

                default:
                    print("no item found")
                }

            } catch let error {
                print(error)
            }
        }
    }

    // - Function: Retrive all Items from DB
//    func retrieveAllItems() {
//        let tables = [loginCredentialsTable, creditCardsTable, notesTable, identityTable]
//        var result: [Item] = []
//        // Check items from all database
//        tables.forEach { table in
//
//            do {
//                try db.prepare(table).map { row in
//                    result.removeAll()
//                    let itemType = try row.get(Expression<String>("kind"))
//                    // retrive items from table, convert it to suitable type
//                    let item = retrieveItems(item: ItemTypes(rawValue: itemType)!)
//                    // add coverted item to array of table contents
//                    result.append(item)
//                }
//
//            } catch let err {
//                print(err)
//            }
//        }
//        dump(result)
//    }

    // MARK: Helper Functions

    // - Function: Removing Database from "Documents" directory of app
    func removeDB(localPathName: String) {
        // Create file path string of db.sqlite file
        let file = createDBFilePath(fileName: localPathName)

        do {
            let fileManager = FileManager.default

            // Check if database file exists then remove it else throw error
            if fileManager.fileExists(atPath: file) {
                try fileManager.removeItem(atPath: file)
                print("File Has Found and Removed")
            } else {
                print("File Has Not Found")
            }
        } catch let error as NSError {
            print("An error took place: \(error)")
        }
    }

    // - Function: Create file path string of given file
    func createDBFilePath(fileName: String) -> String {
        // Get path of "Document" directory of application from sandbox
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // Add file name to the end of Document path String
        let fileURL = documentDirURL.appendingPathComponent(fileName).relativePath

        // Return full path of file as String
        return fileURL
    }
}


extension String {
     func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}
