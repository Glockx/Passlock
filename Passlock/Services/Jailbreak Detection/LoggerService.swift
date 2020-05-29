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

/// The name of class and functions being called differently on purpose for hardening reverse enginnering process. Because Jailbreak Bypassing libraries and attackers checking name of classes (such as: JailbreakDetection,checkJailbreak,checkJb,Jb and etc.) and functions for disabling jailbreak dedection easily.
public class LoggerService: ObservableObject {
    @Published var reason = ""

    @Published var isLogging = false
    var isLoggingPublisher: Published<Bool>.Publisher { $isLogging }
    var isLoggingPublished: Published<Bool> { _isLogging }

    var path = ["/Library/Frameworks/CydiaSubstrate", "/Library/Frameworks/CydiaSubstrate.framework", "/Library/Frameworks/SubstrateLoader.dylib", "/Library/MobileSubstrate/", "/usr/bin/cynject", "/usr/bin/sinject", "/user/lib/libsubstitute.0.dylib", "/Applications/Cydia.app", "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/private/var/lib/apt/", "/usr/libexec/cydia", "/var/lib/cydia", "/Library/MobileSubstrate/DynamicLibraries", "/Library/MobileSubstrate/DynamicLibraries/!ABypass2.dylib", "/Library/MobileSubstrate/DynamicLibraries/!ABypass2.plist", "/Library/MobileSubstrate/DynamicLibraries/zzzzzLiberty.dylib", "/Library/MobileSubstrate/DynamicLibraries/zzzzzLiberty.plist", "/Library/MobileSubstrate/DynamicLibraries/tsProtector.dylib", "/Library/MobileSubstrate/DynamicLibraries/TweakRestrictor.dylib", "/Library/MobileSubstrate/DynamicLibraries/JailProtect.dylib", "/Library/MobileSubstrate/DynamicLibraries/zzzzzzzzzNotifyChroot.dylib", "/usr/sbin/frida-server", "/etc/apt/sources.list.d/electra.list", "/.bootstrapped_electra", "/.cydia_no_stash", "/etc/apt"]

    func logAll() {
        loadLogFiles()
        canOpenLogFiles()
        createLogFiles()
        canOpenLogFiles()
        openSpecLogs()
    }

    // MARK: Checking Sandbox Violation

    /// By default Sandboxed apps unable write to the outside of application directory, but sandbox escaped apps able to do. So we checking whether we are able to write or not.
    func createLogFiles() {
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
                // NSLog("Able to create file outside of Sandbox")
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
                // NSLog("\n\n-----------------Error-----------------\n\n")
            }
            isLogging = true
        }
    }

    // MARK: Checking DYLD Libs

    /// Checking whether we are able to link a jailbreak library to app process.
    func loadLogFiles() {
        // name of Jailbreak packages
        let images = ["MobileSubstrate", "Substitute", "Substitute-loader", "substrate", "abypass", "tsProtector", "TweakRestrictor", "JailProtect", "UnSub", "Liberty", "zzzzzLiberty", "TweaksManager", "KernBypass", "cynject", "AppList", "MobileSafety", "PreferenceLoader", "rocketbootstrap", "SSLKillSwitch", "SSLKillSwitch2", "WeeLoader", "patcyh", "zzzzzzzzzNotifyChroot", "FridaGadget", "frida", "libcycript"]

        /// `_dyld_image_count` Returns the number of images that dyld(Low-Level Dynamic Linking) has mapped into the address space of the current process.
        for dyldImage in 0 ..< _dyld_image_count() {
            /// geting name of each dyld
            let dyld = _dyld_get_image_name(dyldImage)
            // If address space contains any listed dyld then device has been jailbroken.
            images.forEach { image in

                // Convert "C:String" type to Swift type String.
                let fromCstring = String(cString: dyld!)
                if fromCstring.range(of: image, options: .caseInsensitive) != nil {
                    // print("Has found: \(fromCstring)")
                    isLogging = true
                }
            }
        }

        /// `DYLD_INSERT_LIBRARIES` used for injecting environment variables.
        ///  The `getenv()` function searches the environment list to find the environment variable name, and returns a pointer to the corresponding value string.
        // By default sandboxed apps unable to perform this function due to kernel-level restrictions so we checking whether we are able to inject or not, if we can then device has been jailbroken.
        let env = getenv("DYLD_INSERT_LIBRARIES")
        if env != nil {
            // print("able to DYLD_INSERT_LIBRARIES")
            isLogging = true
        }
    }

    // MARK: CHECKING JB LIBRARY FILES AND URI SCHEMES

    // Checking Method: Validating existing of file present of jailbreak libraries and tools.
    func canOpenLogFiles() {
        path.forEach { path in
            if FileManager.default.fileExists(atPath: path) {
                // print(path)
                isLogging = true
            }
        }

        // Another Method: Checking URI scheme registration checks: iOS applications can register custom URI schemes. Applications uses this functionality to create clickable web links that can open parent application. Cydia registered the cydia:// URI scheme to allow direct links to apps available via Cydia. iOS allows applications to check which URI schemes are registered, so the presence of the cydia:// URI scheme is used to check if Cydia is installed and the device is jailbroken.

        // Package Manager Apps
        let distrubtion = [
            "undecimus://",
            "cydia://",
            "sileo://",
            "zbra://",
        ]

        for app in distrubtion {
            let url = URL(string: app)
            if UIApplication.shared.canOpenURL(url!) {
                // print("can open")
                isLogging = true
            }
        }
    }

    // MARK: Checking fork() execution

    // Jailbreaks frequently patch the behavior of the iOS application sandbox. As an example, calling fork() are disallowed on a stock iOS device: an iOS app may not spawn a child process.If you are able to successfully execute fork(), your code is likely running on a jailbroken device.
    func checkLogFileHasRemoved() {
        let pointerToFork = UnsafeMutableRawPointer(bitPattern: -2)
        // dlsym - obtain the address of a symbol from a dlopen object
        // Using for Calling fork() function from C library
        let forkPtr = dlsym(pointerToFork, "fork")

        typealias ForkType = @convention(c) () -> pid_t
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        let forkResult = fork()

        // If return value of fork() is greater than 0 it means that new process has been created.
        if forkResult >= 0 {
            if forkResult > 0 {
                // Terminate created process.
                kill(forkResult, SIGTERM)
            }
            isLogging = true
            // print("Fork was able to create a new process")
        }
    }

    // MARK: Open port checking

    // For preventing Reverse Enginnering attacks we are checking if ports of attacking tools are open
    func openSpecLogs() {
        let ports = [
            27042, // default Frida
            4444, // default Needle
        ]

        for port in ports {
            if checkLogsAreOpenable(port: port) {
                isLogging = true
            }
        }
    }

    // Checking Open Port
    func checkLogsAreOpenable(port: Int) -> Bool {
        func swapBytesIfNeeded(port: in_port_t) -> in_port_t {
            let littleEndian = Int(OSHostByteOrder()) == OSLittleEndian
            return littleEndian ? _OSSwapInt16(port) : port
        }

        /*     struct sockaddr_in {
               sa_family_t    sin_family; /* address family: AF_INET */
               in_port_t      sin_port;   /* port in network byte order */
               struct in_addr sin_addr;   /* internet address */
         };*/

        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1")
        serverAddress.sin_port = swapBytesIfNeeded(port: in_port_t(port))
        let sock = socket(AF_INET, SOCK_STREAM, 0)

        let result = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
            }
        }

        if result != -1 {
            return true // Port is opened
        }

        return false
    }
}
