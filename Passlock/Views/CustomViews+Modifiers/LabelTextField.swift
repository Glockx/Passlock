//
//  LabelTextField.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/12.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct LabelTextField: View {
    var label: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading)
        {
            Text(label)
                .font(.headline)
            TextField(placeHolder, text: $text)
                .padding(.all,10)
                .frame(height: 40)
                .border(Color.orange,width: 3)
            .cornerRadius(3)
        }
        .padding(.horizontal,15)
    }
}

struct SecureLabelTextField: View {
    var label: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading)
        {
            Text(label)
                .font(.headline)
            SecureField(placeHolder, text: $text)
                .padding(.all,10)
                .frame(height: 40)
            .border(Color.orange,width: 3)
            .cornerRadius(3)
        }
        .padding(.horizontal,15)
    }
}

struct LabelTextField_Previews: PreviewProvider
{
    @State static var name = ""
    static var previews: some View {
        LabelTextField(label: "Hello", placeHolder: "Test",text: $name).colorScheme(.dark)
    }
}
