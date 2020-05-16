//
//  LoginItemCell.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/13.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct LoginItemCell: View {
    @State var item: LoginItem
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: 45, height: 45)

            VStack(alignment: .leading, spacing: 10) {
                Text(item.website)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                Text(item.username)
                    .font(.headline)
            }
        }
    }
}

struct LoginItemCell_Previews: PreviewProvider {
    static var item = LoginItem(id: "er", title: "er", username: "er", email: "er", password: "er", website: "er")
    static var previews: some View {
        LoginItemCell(item: item)
    }
}
