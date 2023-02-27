//
//  ContentView.swift
//  KleinSnapshotTesting
//
//  Created by Kubilay Erdogan on 2023-02-27.
//

import SwiftUI

struct ContentView: View {
    struct ViewModel {
        let imageName: String
        let text: String
    }
    let viewModel: ViewModel

    var body: some View {
        VStack {
            Image(systemName: viewModel.imageName)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Spacer()
            Image(systemName: viewModel.imageName)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(viewModel.text)
            Spacer()
            Text(viewModel.text)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: .init(imageName: "globe", text: "Hello, world")
        )
    }
}
