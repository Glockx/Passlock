//
//  SQLiteHelper.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SQLite

// MARK: SQLite Class

// SQLiteHelper is controller and model class of application for handling all SQLite functions with much simple and clean way.
public class SQLiteHelper {
    var path: String!
    var db: Connection!

    // Init SQL table for login credentials
    let loginCredentialsTable = Table("loginCredentials")

    // MARK: Initializer of class

    init() {
        // Binding empty path string with path of database file
        path = createDBFilePath(fileName: "db.sqlite3")

        removeDB(localPathName: "db.sqlite3")
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

    func create() {
        do {
            let users = Table("users")
            let id = Expression<Int>("id")
            let email = Expression<String>("email")
            let name = Expression<String?>("name")

            try db.run(users.create(ifNotExists: true) { t in // CREATE TABLE "users" (
                t.column(id, primaryKey: .autoincrement) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(email) //     "email" TEXT NOT NULL,
                t.column(name) //     "name" TEXT
            }) // )

            try db.run(users.insert(email <- "aalice@tac.com", name <- "Alice"))

            for user in try db.prepare(users) {
                print("id: \(user[id]), email: \(user[email]), name: \(user[name])")
            }

        } catch let error {
            print(error)
        }
    }
    
    // - Function: Create Table and Statement for each Data Template
    func createTablesForDataTypes() {
        do {
            // MARK: Login Credentials Table and Expressions

            // Uniqe ID - Title of Data - Username - Password - Email - Name of the website.

            // Creating Expression for each variable of LoginCredentials structure.
            let loginCredentialsId = Expression<String>("id")
            let loginCredentialsTitle = Expression<String?>("title")
            let loginCredentialsUsername = Expression<String?>("username")
            let loginCredentialsPassword = Expression<String?>("password")
            let loginCredentialsEmail = Expression<String?>("email")
            let loginCredentialsWebsite = Expression<String?>("website")

            // Creating table for login credentials in database
            try db.run(loginCredentialsTable.create(ifNotExists: true) { t in // CREATE TABLE "users" (
                t.column(loginCredentialsId, primaryKey: true) // "id" TEXT PRIMARY KEY NOT NULL,
                t.column(loginCredentialsTitle) // "title" TEXT,
                t.column(loginCredentialsUsername) // "username" TEXT,
                t.column(loginCredentialsPassword) // "password" TEXT,
                t.column(loginCredentialsEmail) // "email" TEXT,
                t.column(loginCredentialsWebsite) // "website" TEXT,)
            })

            
            
        } catch let error {
            print(error)
        }
    }

    // - Function: Inserting Login Credentials
    func insertLoginCredentialItem(item: LoginItem) {
        do {
            try db.run(loginCredentialsTable.insert(item))
        } catch let error {
            print(error)
        }
    }

    // - Function: Retrive and Print Login Credentials
    func retrievingLoginCredentialItems() {
        do {
            // Retrive each LoginItem from Database, Decode it as JSON(Codable) and attach it to LoginItem structure
            let loadedUsers: [LoginItem] = try db.prepare(loginCredentialsTable).map { row in
                try row.decode()
            }
            
            loadedUsers.forEach({print($0)})

        } catch let error {
            print(error)
        }
    }

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
