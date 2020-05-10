//
//  SQLiteHelper.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/06.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SQLite

class SQLIiteHelper {
    func create() {
        let path = createDBFilePath(fileName: "db")
            do {
                removeDB(localPathName: path)
                
                
                let db = try Connection(path)
                
                #if DEBUG
                    db.trace { print($0) }
                #endif
                
                try db.key("another secret")
                
                print("DB has created!")
                
                let users = Table("users")
                
                let id = Expression<Int64>("id")
                let email = Expression<String>("email")
                let balance = Expression<Double>("balance")
                let verified = Expression<Bool>("verified")
                let name = Expression<String?>("name")
                
                try db.run(users.create (ifNotExists: true){ t in       // CREATE TABLE "users" (
                    t.column(id, primaryKey: .autoincrement)            //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(email)                                     //     "email" TEXT NOT NULL,
                    t.column(name)                                      //     "name" TEXT
                })                                                      // )
                
                try db.run(users.insert(email <- "aalice@tac.com", name <- "Alice"))
                
                for user in try db.prepare(users){
                    print("id: \(user[id]), email: \(user[email]), name: \(user[name])")
                }
                
                
            } catch let error {
                print(error)
            }
        }
    }

func createDBFilePath(fileName: String) -> String
{
    let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = documentDirURL.appendingPathComponent("\(fileName).sqlite").relativePath
    return fileURL
}

func removeDB(localPathName: String) {
        let file = createDBFilePath(fileName: localPathName)
    do {
        let fileManager = FileManager.default

        // Check if file exists
        if fileManager.fileExists(atPath: file){
             try fileManager.removeItem(atPath: file)
        }
    } catch let error as NSError {
        print("An error took place: \(error)")
    }
}
