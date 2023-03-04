//
//  XCTestCase+SnapshotAssertion.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-03.
//

import XCTest

extension XCTestCase {
    /// Asserts that the given `Snapshottable` object matches the previously recorded snapshot.
    ///
    /// - Parameters:
    ///   - snapshottable: The object to assert the snapshot for.
    ///   - record: Whether to record the snapshot if it does not exist. The test will fail when this is set to `true`.
    ///   - tolerance: The tolerance for the snapshot comparison. The default value is `0`, the maximum value is `1.0` (100%).
    func assertSnapshot(
        of snapshottable: Snapshottable,
        record: Bool = false,
        tolerance: CGFloat = .zero,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let actualImage = try snapshottable.snapshot(record: record)
        let expectedImage = try SnapshotRetriever().retrieveSnapshot(of: snapshottable)

        let isEqual = actualImage.compare(with: expectedImage, tolerance: tolerance)
        XCTAssertTrue(isEqual, file: file, line: line)
    }
}
