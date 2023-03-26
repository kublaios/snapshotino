//
//  SnapshotFileURLBuilderTests.swift
//  snapshotinoTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import XCTest
@testable import snapshotino

final class SnapshotFileURLBuilderTests: XCTestCase {
    let fileManager: FileManager = .default
    var builder: SnapshotFileURLBuilder!
    var tempDirectory: URL!

    override func setUp() {
        super.setUp()

        builder = SnapshotFileURLBuilder()
        tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
    }

    func testBuildSnapshotFileURL() throws {
        let filePath = tempDirectory.appendingPathComponent("test/image.png").path

        let url = try builder.build(
            nextTo: filePath,
            forType: SnapshotFileURLBuilderTests.self,
            function: #function
        )

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/__snapshots__/SnapshotFileURLBuilderTests_testBuildSnapshotFileURL.png")
        XCTAssertFalse(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
    }

    func testBuildSnapshotFileURLWithMissingDirectory() throws {
        let filePath = tempDirectory.appendingPathComponent("test/image.png").path

        let url = try builder.build(
            nextTo: filePath,
            forType: SnapshotFileURLBuilderTests.self,
            function: #function,
            subDirectory: "missing"
        )

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/missing/SnapshotFileURLBuilderTests_testBuildSnapshotFileURLWithMissingDirectory.png")
        XCTAssertFalse(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
    }

    func testBuildSnapshotFileURLWithMissingDirectoryAndCreateSubdirectory() throws {
        let filePath = tempDirectory.appendingPathComponent("test/image.png").path

        let url = try builder.build(
            nextTo: filePath,
            forType: SnapshotFileURLBuilderTests.self,
            function: #function,
            subDirectory: "missing",
            createSubdirectoryIfMissing: true
        )

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/missing/SnapshotFileURLBuilderTests_testBuildSnapshotFileURLWithMissingDirectoryAndCreateSubdirectory.png")
        XCTAssertTrue(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
        try fileManager.removeItem(at: tempDirectory)
    }
}
