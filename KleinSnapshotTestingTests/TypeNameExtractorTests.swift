//
//  TypeNameExtractorTests.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import XCTest

final class TypeNameExtractorTests: XCTestCase {
    func testExtractWithAngleBrackets() {
        assert(input: "Snapshottable<View>", expected: "View")
    }

    func testExtractWithNestedAngleBrackets() {
        assert(input: "Dictionary<Int, Array<UIView>>", expected: "UIView")
    }

    func testExtractWithUnorderedAngleBrackets() {
        assert(input: "Array>View<", expected: "Array>View<")
    }

    func testExtractWithUnorderedNestedAngleBrackets() {
        assert(input: "Dictionary>Array>View<<", expected: "Dictionary>Array>View<<")
    }

    func testExtractWithoutAngleBrackets() {
        assert(input: "UIView", expected: "UIView")
    }

    func testExtractWithNonAlphanumericCharacters() {
        assert(input: "#($R@($R{#@R$:#@!R$:@!($%R$@%)", expected: "#($R@($R{#@R$:#@!R$:@!($%R$@%)")
    }

    func testExtractWithAnyInput() {
        assert(input: "Any input", expected: "Any input")
    }

    private func assert(input: String, expected: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(
            TypeNameExtractor.extract(from: input),
            expected,
            file: file,
            line: line
        )
    }
}
