//
//  NoteItemDetailsView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/18.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct NoteItemDetailsView: View {
    @State var noteItem: NoteItem
    @State var isEditing = false
    @State var text = "salam necesen"
    var body: some View {
        let textBinding = Binding<String>(get: { self.noteItem.textBlob }, set: { self.text = $0 })
        return VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: -7) {
                Image(systemName: "doc.text.fill")
                    .font(.headline)
                    .foregroundColor(.orange)

                Text("Note: ")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 15)

                Text(dateToString(date: noteItem.date))
                    .foregroundColor(.orange)
                    .font(.headline)
            }.padding(.leading)

            NoteTextField(text: textBinding, isEditing: $isEditing, isEditable: false)
                .border(Color.orange, width: 3)
                .padding([.bottom, .horizontal], 15)

        }.padding(.top, 30)
            .navigationBarTitle(noteItem.title)
            .navigationBarBackButtonHidden(false)
    }
}

private func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter.string(from: date)
}

struct NoteItemDetailsView_Previews: PreviewProvider {
    static var item = NoteItem(id: "sjdf", title: "Mekteb", date: Date(timeIntervalSince1970: 45357532), textBlob: "Salam Necesen? adipiscing elit. Praesent vitae magna nec nulla porta dignissim. Nullam in sollicitudin odio, id luctus lorem. Etiam aliquam eleifend maximus. Aenean bibendum, massa a feugiat eleifend, nunc odio blandit dui, id pretium urna risus ut dui. Quisque efficitur fringilla erat, ut commodo lorem lacinia sit amet. Vivamus sit amet nibh ac justo consequat pellentesque. Integer quis lorem nec justo lacinia scelerisque quis nec nunc. Morbi id nisl nec augue congue efficitur sed et erat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et eleifend nibh, ac molestie orci. Vestibulum nibh risus, vulputate ut euismod et, pretium at felis.")

    static var previews: some View {
        NoteItemDetailsView(noteItem: item)
    }
}
