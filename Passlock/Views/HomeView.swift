//
//  HomeView.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/10.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Home")
                .navigationBarTitle("Home", displayMode: .automatic)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
