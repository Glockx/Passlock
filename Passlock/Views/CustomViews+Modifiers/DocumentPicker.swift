//
//  DocumentPicker.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/06/01.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import MobileCoreServices
struct FilePickerController: UIViewControllerRepresentable {
    var callback: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
        // Update the controller
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(documentTypes: [String("public.item")], in: .open)

        controller.delegate = context.coordinator

        return controller
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController

        init(_ pickerController: FilePickerController) {
            parent = pickerController
           // print("Callback: \(parent.callback)")
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            //print("Selected a document: \(urls[0])")
            parent.callback(urls[0])
             let newUrls = urls.compactMap { (url: URL) -> URL? in
                   // Create file URL to temporary folder
                   var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                   // Apend filename (name+extension) to URL
                   tempURL.appendPathComponent(url.lastPathComponent)
                   do {
                       // If file with same name exists remove it (replace file with new one)
                       if FileManager.default.fileExists(atPath: tempURL.path) {
                           try FileManager.default.removeItem(atPath: tempURL.path)
                       }
                       // Move file from app_id-Inbox to tmp/filename
                    if url.startAccessingSecurityScopedResource() {
                        try FileManager.default.copyItem(atPath: url.path, toPath: tempURL.path)
                        
                    }
                    // Replace exsiting DB with new Db.
                    if FileManager.default.fileExists(atPath: SQLiteManager().createDBFilePath(fileName: "db.sqlite3")) {
                        try FileManager.default.removeItem(atPath: SQLiteManager().createDBFilePath(fileName: "db.sqlite3"))
                    }
                    let newDb = NSData(contentsOf: tempURL)
                    FileManager.default.createFile(atPath: SQLiteManager().createDBFilePath(fileName: "db.sqlite3"), contents: newDb! as Data, attributes: nil)
                       url.stopAccessingSecurityScopedResource()
                    return tempURL
                   } catch {
                       print(error.localizedDescription)
                       return nil
                   }
               }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was thrown away :(")
        }

        deinit {
            print("Coordinator going away")
        }
    }
}

// Activity Controller for exporting db to Files app.
struct ExportActivityView: UIViewControllerRepresentable {
    @Binding var showingModal:Bool
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ExportActivityView>) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: activityItems,
                                                applicationActivities: applicationActivities)
        activity.completionWithItemsHandler = {activity, success, items, error in
            self.showingModal.toggle()
        }
        
        return activity
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ExportActivityView>) {
    }
}
