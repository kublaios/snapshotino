//
//  SnapshotRetrieverTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import XCTest

final class SnapshotRetrieverTests: XCTestCase {
    let retriever = SnapshotRetriever()
    let snapshotDir = NSTemporaryDirectory() + "/__snapshots__"
    let fileManager: FileManager = .default

    override func setUp() {
        super.setUp()

        try? fileManager.createDirectory(atPath: snapshotDir, withIntermediateDirectories: true, attributes: nil)
    }

    override func tearDown() {
        super.tearDown()

        try? fileManager.removeItem(atPath: snapshotDir)
    }

    func testRetrieveSnapshot_existingSnapshot_returnsImage() throws {
        // The stored image and the image in memory have different scales.
        // To work this around, we map a regular `UIImage` to another one with custom scale.
        let expectedImage = UIImage(
            cgImage: UIImage(systemName: "circle.fill")!.cgImage!,
            scale: 1.0,
            orientation: .up
        )
        let expectedImageData = expectedImage.pngData()!
        try expectedImageData.write(to: URL(fileURLWithPath: snapshotDir + "/MockSnapshottable.png"))

        let actualImage = try retriever.retrieveSnapshot(of: MockSnapshottable(), file: snapshotDir)

        XCTAssertTrue(expectedImage.compare(with: actualImage))
    }
    
    func testRetrieveSnapshot_nonexistentSnapshot_throwsError() throws {
        XCTAssertThrowsError(try retriever.retrieveSnapshot(of: MockSnapshottable()))
    }
    
    func testRetrieveSnapshot_invalidImageData_throwsError() throws {
        let mockSnapshottable = MockSnapshottable()
        let invalidImageData = "not an image".data(using: .utf8)!

        try invalidImageData.write(to: URL(fileURLWithPath: snapshotDir + "/MockSnapshottable.png"))
        
        XCTAssertThrowsError(try retriever.retrieveSnapshot(of: mockSnapshottable))
    }
}

private struct MockSnapshottable: Snapshottable {
    func inSnapshotWindow(sized: CGSize) -> SnapshotWindow {
        .init()
    }
}
