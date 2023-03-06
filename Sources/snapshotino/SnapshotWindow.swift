//
//  SnapshotWindow.swift
//  snapshotino
//
//  Created by Kubilay Erdogan on 2023-03-01.
//

import UIKit

/// This `UIWindow` subclass is used by `Snapshotino` as a wrapper around the object to take the snapshot for.
public final class SnapshotWindow: UIWindow {
    /// Returns top and bottom values that are equal to or greater than portrait safe area insets
    /// to get the same results from simulators/devices with and without the notch/home indicator.
    public override var safeAreaInsets: UIEdgeInsets {
        UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
    }

    var asImage: UIImage? {
        let data = UIGraphicsImageRenderer(bounds: bounds).pngData(actions: { action in
            layer.render(in: action.cgContext)
        })

        return UIImage(data: data)
    }
}
