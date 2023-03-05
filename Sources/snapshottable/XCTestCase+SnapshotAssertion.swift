//
//  XCTestCase+SnapshotAssertion.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-03.
//

import XCTest

public extension XCTestCase {
    /// Asserts that the given `Snapshottable` object matches the previously recorded snapshot.
    ///
    /// - Parameters:
    ///   - snapshottable: The object to assert the snapshot for.
    ///   - record: Whether to record the snapshot if it does not exist. The test will fail when this is set to `true`.
    ///   - tolerance: The tolerance for the snapshot comparison. The default value is `0`, the maximum value is `1.0` (100%).
    func assertSnapshot(
        of snapshottable: Snapshottable,
        on screenSize: SnapshottableScreenSize = .iPhone11,
        record: Bool = false,
        tolerance: CGFloat = .zero,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let filePath = file.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }
        let actualImage = try snapshottable.snapshot(sized: screenSize, record: record, filePath: filePath)
        let expectedImage = try SnapshotRetriever().retrieveSnapshot(of: snapshottable, filePath: filePath)

        let isEqual = actualImage.compare(with: expectedImage, tolerance: tolerance)
        XCTAssertTrue(isEqual, file: file, line: line)
    }
}
