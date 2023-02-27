//
//  SnapshotFileURLBuilderTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import XCTest

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

        let url = try builder.build(nextTo: filePath, forType: SnapshotFileURLBuilderTests.self)

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/__snapshots__/SnapshotFileURLBuilderTests.png")
        XCTAssertFalse(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
    }

    func testBuildSnapshotFileURLWithMissingDirectory() throws {
        let filePath = tempDirectory.appendingPathComponent("test/image.png").path

        let url = try builder.build(nextTo: filePath, forType: SnapshotFileURLBuilderTests.self, subDirectory: "missing")

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/missing/SnapshotFileURLBuilderTests.png")
        XCTAssertFalse(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
    }

    func testBuildSnapshotFileURLWithMissingDirectoryAndCreateSubdirectory() throws {
        let filePath = tempDirectory.appendingPathComponent("test/image.png").path

        let url = try builder.build(nextTo: filePath, forType: SnapshotFileURLBuilderTests.self, subDirectory: "missing", createSubdirectoryIfMissing: true)

        XCTAssertEqual(url.path, "\(tempDirectory.path)/test/missing/SnapshotFileURLBuilderTests.png")
        XCTAssertTrue(fileManager.fileExists(atPath: url.deletingLastPathComponent().path))
        try fileManager.removeItem(at: tempDirectory)
    }
}
