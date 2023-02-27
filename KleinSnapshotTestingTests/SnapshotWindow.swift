//
//  SnapshotWindow.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-01.
//

import UIKit

final class SnapshotWindow: UIWindow {
    override var safeAreaInsets: UIEdgeInsets {
        // To get same results from simulators with and without notch/home indicator,
        // we use the values that are equal to or greater than the safe area insets.
        UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
    }

    var asImage: UIImage? {
        let data = UIGraphicsImageRenderer(bounds: bounds).pngData(actions: { action in
            layer.render(in: action.cgContext)
        })

        return UIImage(data: data)
    }
}
