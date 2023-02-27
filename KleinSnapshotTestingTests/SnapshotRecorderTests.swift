//
//  SnapshotRecorderTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import XCTest

final class SnapshotRecorderTests: XCTestCase {
    let fileManager: FileManager = .default
    var snapshotRecorder: SnapshotRecorder!
    var tempDirectory: URL!

    override func setUp() {
        super.setUp()
        snapshotRecorder = SnapshotRecorder()
        tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("SnapshotRecorderTests")
        do {
            try fileManager.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            XCTFail("Failed to create temp directory")
        }
    }

    override func tearDown() {
        super.tearDown()
        do {
            try fileManager.removeItem(at: tempDirectory)
        } catch {
            XCTFail("Failed to remove temp directory")
        }
    }

    func testRecordValidSnapshot() throws {
        let image = UIImage(systemName: "star")!
        let expectedFileName = "UIImage.png"
        let expectedDirectoryPath = tempDirectory.appendingPathComponent("__snapshots__").path

        let snapshotFilePath = tempDirectory.appendingPathComponent("TestViewController.swift")
        try snapshotRecorder.record(image, ofType: UIImage.self, nextTo: snapshotFilePath.path)

        let fileManager = fileManager
        let files = try fileManager.contentsOfDirectory(atPath: expectedDirectoryPath)

        XCTAssertEqual(files.count, 1)
        XCTAssertTrue(fileManager.fileExists(atPath: "\(expectedDirectoryPath)/\(expectedFileName)"))
    }

    func testRecordInvalidSnapshot() {
        let snapshotFilePath = tempDirectory.appendingPathComponent("TestViewController.swift")
        let invalidImage = UIImage(ciImage: CIImage()) // an invalid image that can't be processed

        XCTAssertThrowsError(
            try snapshotRecorder.record(invalidImage, ofType: UIImage.self, nextTo: snapshotFilePath.path)
        )
    }
}
