//
//  ContentView.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import SwiftUI

struct StartTabview: View {
    var body: some View {
        TabView {
            Tab("Jokes", systemImage: "face.smiling") {
                JokeContentView()
            }
            
            Tab("Info", systemImage: "info.circle") {
                InfoView()
            }
        }
    }
}

#Preview {
    StartTabview()
}
