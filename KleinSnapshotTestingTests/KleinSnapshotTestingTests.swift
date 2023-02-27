//
//  KleinSnapshotTestingTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-02-27.
//

import XCTest
@testable import KleinSnapshotTesting
import SwiftUI
import UIKit

extension XCTestCase {
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

final class KleinSnapshotTestingTests: XCTestCase {
    func testExample() throws {
        try assertSnapshot(of: SampleViewController())
    }

    func testMigirdi() throws {
        if let view = Bundle.main.loadNibNamed("SampleView", owner: self, options: nil)?.first as? SampleView {
            try assertSnapshot(of: view)
        }
    }

    func testZubizu() throws {
        try assertSnapshot(
            of: ContentView(viewModel: .init(imageName: "circle", text: "test")).asSnapshottableView
        )
    }
}
