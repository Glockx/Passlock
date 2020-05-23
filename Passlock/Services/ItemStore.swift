//
//  ItemStore.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/14.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ItemStore: ObservableObject
{
    static let shared = ItemStore()
    public let itemPublisher = PassthroughSubject<Array<Item>, Never>()
    
    @Published var hasLaunched = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    @Published var loginItems = [LoginItem]()
    @Published var creditCardItems = [CreditCardItem]()
    @Published var identityItems = [IdentityItem]()
    @Published var noteItems = [NoteItem]()
    @Published var allItems:[Array<Item>] = []
}
