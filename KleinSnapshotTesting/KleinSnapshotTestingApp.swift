//
//  KleinSnapshotTestingApp.swift
//  KleinSnapshotTesting
//
//  Created by Kubilay Erdogan on 2023-02-27.
//

import SwiftUI
import UIKit

@main
struct KleinSnapshotTestingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: .init(imageName: "globe", text: "KleinApp")
            )
        }
    }
}
