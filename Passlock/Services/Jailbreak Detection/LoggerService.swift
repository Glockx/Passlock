//
//  LoggerService.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/26.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UIKit

public class LoggerService: ObservableObject {
    @ObservedObject var authService: AuthenticationService = AuthenticationService.shared
    @Published var reason = ""
    @Published var isLogging = false
    var isLoggingPublisher: Published<Bool>.Publisher { $isLogging }
    var isLoggingPublished: Published<Bool> { _isLogging }

    var path = ["/Library/Frameworks/CydiaSubstrate", "/Library/Frameworks/CydiaSubstrate.framework", "/Library/Frameworks/SubstrateLoader.dylib", "/Library/MobileSubstrate/", "/usr/bin/cynject", "/usr/bin/sinject", "/user/lib/libsubstitute.0.dylib", "/Applications/Cydia.app", "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/private/var/lib/apt/", "/usr/libexec/cydia", "/var/lib/cydia", "/Library/MobileSubstrate/DynamicLibraries", "/Library/MobileSubstrate/DynamicLibraries/!ABypass2.dylib", "/Library/MobileSubstrate/DynamicLibraries/!ABypass2.plist", "/Library/MobileSubstrate/DynamicLibraries/zzzzzLiberty.dylib", "/Library/MobileSubstrate/DynamicLibraries/zzzzzLiberty.plist", "/Library/MobileSubstrate/DynamicLibraries/tsProtector.dylib", "/Library/MobileSubstrate/DynamicLibraries/TweakRestrictor.dylib", "/Library/MobileSubstrate/DynamicLibraries/JailProtect.dylib", "/Library/MobileSubstrate/DynamicLibraries/zzzzzzzzzNotifyChroot.dylib"]

    func logAll() {
        loadLibraries()
        canOpen()
        createFileOutsideSandbox()
    }

    /// By default Sandboxed apps unable write to the outside of application directory, but sandbox escaped apps able to do. So we checking whether we are able to write or not.
    func createFileOutsideSandbox() {
        let text = "Korea University is Rocking!"
        let ret1 = FileManager.default.createFile(atPath: "/var/mobile/Containers/Data/Application/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret2 = FileManager.default.createFile(atPath: "/private/var/mobile/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret3 = FileManager.default.createFile(atPath: "/tmp/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret4 = FileManager.default.createFile(atPath: "/var/mobile/Containers/Bundle/Application/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret5 = FileManager.default.createFile(atPath: "/private/var/mobile/Library/Caches/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret6 = FileManager.default.createFile(atPath: "/private/var/mobile/Library/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret7 = FileManager.default.createFile(atPath: "/private/var/tmp/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret8 = FileManager.default.createFile(atPath: "/private/var/mobile/Containers/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)
        let ret9 = FileManager.default.createFile(atPath: "/private/var/mobile/Downloads/test.txt", contents: (text as NSString).data(using: String.Encoding.utf8.rawValue), attributes: nil)

        if ret1 || ret2 || ret3 || ret4 || ret5 || ret6 || ret7 || ret8 || ret9 {
            do {
                NSLog("Able to create file outside of Sandbox")
                try FileManager.default.removeItem(atPath: "/var/mobile/Containers/Data/Application/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/mobile/test.txt")
                try FileManager.default.removeItem(atPath: "/tmp/test.txt")
                try FileManager.default.removeItem(atPath: "/var/mobile/Containers/Bundle/Application/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/mobile/Library/Caches/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/mobile/Library/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/tmp/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/mobile/Containers/test.txt")
                try FileManager.default.removeItem(atPath: "/private/var/mobile/Downloads/test.txt")
            } catch _ as NSError {
                NSLog("\n\n-----------------Error-----------------\n\n")
            }
            isLogging = true
        }
    }

    /// Checking whether we are able to link a jailbreak library to app process.
    func loadLibraries() {
        // name of Jailbreak packages
        let images = ["MobileSubstrate", "Substitute", "Substitute-loader", "substrate", "abypass", "tsProtector", "TweakRestrictor", "JailProtect", "UnSub", "Liberty", "zzzzzLiberty", "Tweaks Manager", "KernBypass", "cynject", "AppList", "MobileSafety", "PreferenceLoader", "rocketbootstrap", "SSLKillSwitch", "SSLKillSwitch2", "WeeLoader", "patcyh", "zzzzzzzzzNotifyChroot"]

        /// `_dyld_image_count` Returns the number of images that dyld(Low-Level Dynamic Linking) has mapped into the address space of the current process.
        for dyldImage in 0 ..< _dyld_image_count() {
            /// geting name of each dyld
            let dyld = _dyld_get_image_name(dyldImage)
            // if address space contains any listed dyld then device has been jailbroken.
            images.forEach { image in

                // Convert "C:String" type to Swift type String.
                let fromCstring = String(cString: dyld!)
                if fromCstring.range(of: image, options: .caseInsensitive) != nil {
                    print("Has found: \(fromCstring)")
                    isLogging = true
                } else {
                    isLogging = false
                }
            }
        }

        /// `DYLD_INSERT_LIBRARIES` used for injecting environment variables.
        ///  The `getenv()` function searches the environment list to find the environment variable name, and returns a pointer to the corresponding value string.
        // By default sandboxed apps unable to perform this function due to kernel-level restrictions so we checking whether we are able to inject or not, if we can then device has been jailbroken.
        let env = getenv("DYLD_INSERT_LIBRARIES")
        if env != nil {
            print("able to DYLD_INSERT_LIBRARIES")
            isLogging = true
        }
    }

    func canOpen() {
        path.forEach { path in
            if FileManager.default.fileExists(atPath: path) {
                print(path)
                isLogging = true
            }
        }
        let url = URL(string: "cydia://package/com.example.package")
        if UIApplication.shared.canOpenURL(url!) {
            print("can open")
            isLogging = true
        }
    }
}
