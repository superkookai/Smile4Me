//
//  Smile4MeiOSApp.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import SwiftUI

@main
struct Smile4MeiOSApp: App {
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            StartTabview()
                .environment(router)
                .onOpenURL { url in
                    guard url.scheme == "s4m",
                          url.host() == "joke" else { return }
                    router.components = url.lastPathComponent
                    router.selectedTab = 0
                }
        }
    }
}
