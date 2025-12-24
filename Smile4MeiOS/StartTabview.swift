//
//  ContentView.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import SwiftUI

struct StartTabview: View {
    @Environment(Router.self) var router
    
    var body: some View {
        TabView(selection: Bindable(router).selectedTab) {
            Tab("Jokes", systemImage: "face.smiling", value: 0) {
                JokeContentView()
            }
            
            Tab("Info", systemImage: "info.circle", value: 1) {
                InfoView()
            }
        }
    }
}

#Preview {
    StartTabview()
        .environment(Router())
}
