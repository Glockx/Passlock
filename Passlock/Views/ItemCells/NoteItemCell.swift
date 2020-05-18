//
//  NoteItemCell.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/18.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct NoteItemCell: View
{
    @State var noteItem: NoteItem
    var body: some View {
            HStack(spacing: 15) {
            Image(systemName: "c.square.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: 45, height: 45)

            VStack(alignment: .leading, spacing: 10) {
                Text(noteItem.title)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                Text(String(noteItem.textBlob).prefix(30) + "...")
                    .font(.headline)
                .lineLimit(1)
            }
        }
    }
}

struct NoteItemCell_Previews: PreviewProvider
{
    static var item = NoteItem(id: "sjdf", title: "Mekteb", date: Date(), textBlob: "Salam Necesen? adipiscing elit. Praesent vitae magna nec nulla porta dignissim. Nullam in sollicitudin odio, id luctus lorem. Etiam aliquam eleifend maximus. Aenean bibendum, massa a feugiat eleifend, nunc odio blandit dui, id pretium urna risus ut dui. Quisque efficitur fringilla erat, ut commodo lorem lacinia sit amet. Vivamus sit amet nibh ac justo consequat pellentesque. Integer quis lorem nec justo lacinia scelerisque quis nec nunc. Morbi id nisl nec augue congue efficitur sed et erat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et eleifend nibh, ac molestie orci. Vestibulum nibh risus, vulputate ut euismod et, pretium at felis.")
    static var previews: some View {
        NoteItemCell(noteItem: item)
    }
}
