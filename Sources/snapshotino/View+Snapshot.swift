//
//  View+Snapshot.swift
//  snapshotino
//
//  Created by Kubilay Erdogan on 2023-02-28.
//

import SwiftUI
import UIKit

enum SnapshottableError: Error {
    case unavailableWindowSnapshot, recordingEnabled
}

// MARK: - Snapshottable protocol

public protocol Snapshottable {
    func inSnapshotWindow(sized: CGSize) -> SnapshotWindow
    func snapshot(sized: CGSize, record: Bool, filePath: String) throws -> UIImage
}

// MARK: - Snapshottable `snapshot(sized:record:file:)` default implementation

extension Snapshottable {
    /// Takes a snapshot of the object.
    ///
    /// - Parameters:
    ///   - sized: The size of the snapshot window.
    ///   - record: Whether to record the snapshot to the file system.
    ///   - filePath: The path of any file at the folder where the snapshot will be placed.
    ///     Ideally, this is the path of the test file so that the snapshots are placed in the same directory as the test file.
    ///
    /// - Returns: The snapshot image.
    ///
    /// - Throws: `SnapshottableError` if the snapshot cannot be taken or the snapshot is being recorded.
    public func snapshot(sized: CGSize, record: Bool = false, filePath: String = #file) throws -> UIImage {
        guard let snapshot = inSnapshotWindow(sized: sized).asImage else {
            throw SnapshottableError.unavailableWindowSnapshot
        }

        if record {
            try SnapshotRecorder().record(snapshot, ofType: type(of: self), nextTo: filePath)
            throw SnapshottableError.recordingEnabled
        }

        return snapshot
    }
}

// MARK: - Type erasure for making `SwiftUI.View` conform to `Snapshottable`

public struct SnapshottableView<Content>: View, Snapshottable where Content: View {
    let content: Content

    public var body: some View {
        content
    }

    public func inSnapshotWindow(sized: CGSize) -> SnapshotWindow {
        let window = SnapshotWindow(frame: .init(origin: .zero, size: sized))
        window.rootViewController = UIHostingController(rootView: self)
        window.isHidden = false
        return window
    }
}

// MARK: - `SwiftUI.View`+`Snapshottable`

public extension View {
    var asSnapshottableView: SnapshottableView<Self> {
        SnapshottableView(content: self)
    }
}

// MARK: - `UIView`+`Snapshottable`

extension UIView: Snapshottable {
    public func inSnapshotWindow(sized: CGSize) -> SnapshotWindow {
        let window = SnapshotWindow(frame: .init(origin: .zero, size: sized))
        window.rootViewController = {
            let controller = UIViewController()
            controller.view = self
            return controller
        }()
        window.isHidden = false
        return window
    }
}

// MARK: - `UIViewController`+`Snapshottable`

extension UIViewController: Snapshottable {
    public func inSnapshotWindow(sized: CGSize) -> SnapshotWindow {
        let window = SnapshotWindow(frame: .init(origin: .zero, size: sized))
        window.rootViewController = self
        window.isHidden = false
        return window
    }
}
