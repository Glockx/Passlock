//
//  IdentityItemCell.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/16.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct IdentityItemCell: View
{
    @State var identityItem: IdentityItem
    var body: some View {
              HStack(spacing: 15) {
              Image(systemName: "i.square.fill")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(.orange)
                  .frame(width: 45, height: 45)

              VStack(alignment: .leading, spacing: 10) {
                Text(identityItem.name)
                      .font(.title)
                      .fontWeight(.medium)
                      .foregroundColor(.orange)
                Text(identityItem.lastName)
                      .font(.headline)
              }
          }
    }
}

struct IdentityItemCell_Previews: PreviewProvider
{
    static var item = IdentityItem(id: "asd",title: "Nijat Muzaffarli", name: "Nijat", middleName: "", lastName: "Muzaffarli", gender: "Male", birthDate: Date(), nationalID: "56dfs2451")
    static var previews: some View {
        IdentityItemCell(identityItem: item)
    }
}
