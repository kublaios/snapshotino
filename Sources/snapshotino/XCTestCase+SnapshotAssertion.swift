//
//  XCTestCase+SnapshotAssertion.swift
//  snapshotino
//
//  Created by Kubilay Erdogan on 2023-03-03.
//

import XCTest

public extension XCTestCase {
    /// Asserts that the given `Snapshottable` object matches the previously recorded snapshot.
    ///
    /// - Parameters:
    ///   - snapshottable: A `Snapshottable` member to assert the snapshot for.
    ///     `SwiftUI.View`, `UIView`, and `UIViewController` already conform to this protocol.
    ///   - screenSize: Optional screen size to customize the size of the snapshot. Default is `414`x`896` (iPhone 11)
    ///   - record: Whether to save the snapshot in the file system.
    ///     The new snapshot will override the existing one.
    ///     The test will fail when this is set to `true`.
    ///   - tolerance: The tolerance for the snapshot comparison. Default is `0`, maximum is `1.0` (100%).
    func assertSnapshot(
        of snapshottable: Snapshottable,
        on screenSize: SnapshottableScreenSize = .iPhone11,
        record: Bool = false,
        tolerance: CGFloat = .zero,
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) throws {
        let filePath = file.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }
        let expectedImage = try snapshottable.snapshot(sized: screenSize, record: record, filePath: filePath, function: function)
        let actualImage = try SnapshotRetriever().retrieveSnapshot(of: snapshottable, filePath: filePath, function: function)

        add(makeAttachment(from: actualImage, label: "Actual image"))
        add(makeAttachment(from: expectedImage, label: "Expected image"))

        let isEqual = expectedImage.compare(with: actualImage, tolerance: tolerance)
        XCTAssertTrue(isEqual, file: file, line: line)
    }

    private func makeAttachment(from image: UIImage, label: String) -> XCTAttachment {
        let attachment = XCTAttachment(image: image)
        attachment.lifetime = .deleteOnSuccess
        attachment.name = label
        return attachment
    }
}
