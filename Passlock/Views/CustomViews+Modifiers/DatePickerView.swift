//
//  DatePickerView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/16.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct DatePickerView: View {
    @State var title: String
    @State var wakeUp: Date
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading, -30)
            DatePicker(selection: $wakeUp, in: ...Date(), displayedComponents: [.date]) {
                Text("Select a date")
            }.labelsHidden().border(Color.orange, width: 2)
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var label = "Birth date"
    static var date = Date()
    static var previews: some View {
        DatePickerView(title: label, wakeUp: date)
    }
}
