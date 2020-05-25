//
//  ModalModeKey.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/25.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import SwiftUI

// Currently only possible way to dissmis child modal view with parent is using Enviroment key so check here: https://stackoverflow.com/questions/59824443/dismiss-a-parent-modal-in-swiftui-from-a-navigationview

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}
