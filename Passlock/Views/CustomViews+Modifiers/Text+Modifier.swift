//
//  Text+Modifier.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/19.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

extension Text {
    func textAsError() -> some View {
        padding(.all)
            .background(Color(red: 0.86, green: 0.86, blue: 0.86))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .border(Color(red: 0.86, green: 0.86, blue: 0.86), width: 3)
            .cornerRadius(16)
        .shadow(radius: 20)
    }
}
