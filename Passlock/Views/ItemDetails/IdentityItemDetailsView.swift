//
//  IdentityItemDetailsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/17.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct IdentityItemDetailsView: View {
    @State var identityItem: IdentityItem

    var body: some View {
        Form {
            StringTypeSection(mainTitle: "Name:", variable: identityItem.name, icon: "n.square.fill")
            StringTypeSection(mainTitle: "Middle Name:", variable: identityItem.middleName, icon: "m.square.fill")
            StringTypeSection(mainTitle: "Last Name:", variable: identityItem.lastName, icon: "l.square.fill")
            StringTypeSection(mainTitle: "Gender:", variable: identityItem.gender, icon: "person.crop.square.fill")
            StringTypeSection(mainTitle: "Birth Date:", variable: dateToString(date: identityItem.birthDate), icon: "calendar")
            StringTypeSection(mainTitle: "ID Number:", variable: identityItem.nationalID, icon: "number.square.fill")
        }.padding(.top, 30)
            .navigationBarTitle(identityItem.title)
            .navigationBarBackButtonHidden(false)
    }
}

private func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter.string(from: date)
}

struct IdentityItemDetailsView_Previews: PreviewProvider {
    static var item = IdentityItem(id: "afd", title: "Nijat Muzaffarli", name: "Nijat", middleName: "", lastName: "Muzaffarli", gender: "Male", birthDate: Date(), nationalID: "754128965")
    static var previews: some View {
        IdentityItemDetailsView(identityItem: item)
    }
}
