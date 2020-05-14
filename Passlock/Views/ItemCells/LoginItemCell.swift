//
//  LoginItemCell.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/13.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct LoginItemCell: View
{
    @State var title: String
    @State var username: String
    var body: some View
    {
        HStack(spacing: 15){
            Image(systemName: "person.2.square.stack.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                
            VStack(alignment: .leading,spacing: 10){
                Text("Facebook.com")
                    .font(.title)
                    .fontWeight(.medium)
                Text("nicat754")
                    .font(.headline)
            }
        }
        
    }
}

struct LoginItemCell_Previews: PreviewProvider {
    static var previews: some View {
        LoginItemCell(title: "XXX", username: "Glockx")
    }
}
