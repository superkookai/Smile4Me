//
//  Smile4MeApp.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import SwiftUI
import LaunchAtLogin

@main
struct Smile4MeApp: App {
    var body: some Scene {
        MenuBarExtra("Smile4Me", image: "menuBarIcon") { //image size 32x32 pixel
            VStack(alignment: .leading) {
                JokeContentView()
                Divider()
                HStack {
                    LaunchAtLogin.Toggle()
                    Spacer()
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q")
                }
            }
            .padding()
            .frame(width: 400, height: 400)
        }
        .menuBarExtraStyle(.window)
    }
}
