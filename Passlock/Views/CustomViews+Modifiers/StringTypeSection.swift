//
//  StringTypeSection.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/16.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct StringTypeSection: View {
    @State var mainTitle: String
    @State var variable: String
    @State var icon: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .font(.headline)

                Text(mainTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .font(.headline)
            }

            Text(variable)
                .fontWeight(.semibold)
                .font(.callout)
                .padding(.leading, 25)
            Divider()
        }.padding(.top, 5)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
    }
}

struct StringTypeSection_Previews: PreviewProvider {
    static var header = "Username"
    static var body = "nicat754"
    static var icon = "globe"
    static var previews: some View {
        StringTypeSection(mainTitle: header, variable: body, icon: icon).environment(\.colorScheme, .dark)
    }
}
