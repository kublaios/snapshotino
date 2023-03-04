//
//  UIImageTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-03.
//

import XCTest

final class UIImageTests: XCTestCase {
    private let imageSize = CGSize(width: 100, height: 100)
    private var renderer: UIGraphicsImageRenderer {
        UIGraphicsImageRenderer(size: imageSize)
    }

    func testCompareIdenticalImages() {
        XCTAssertTrue(makeImage(with: .red).compare(with: makeImage(with: .red)))
    }

    func testCompareDifferentImages() {
        XCTAssertFalse(makeImage(with: .green).compare(with: makeImage(with: .red)))
    }

    func testCompareWithTolerance() {
        let image1 = makeImage(with: .red)
        let image2 = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(origin: CGPoint(x: 1, y: 1), size: CGSize(width: 98, height: 98)))
            UIColor.green.setFill()
            ctx.fill(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
        }

        XCTAssertFalse(image1.compare(with: image2))
        XCTAssertTrue(image1.compare(with: image2, tolerance: 0.05))
    }

    private func makeImage(with color: UIColor) -> UIImage {
        renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: imageSize))
        }
    }
}
