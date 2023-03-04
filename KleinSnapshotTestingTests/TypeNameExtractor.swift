//
//  TypeNameExtractor.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import Foundation

enum TypeNameExtractor {
    /// Extracts the type name from a string.
    static func extract(from string: String) -> String {
        var result = string
        var start = string.startIndex
        var end = string.endIndex

        // Look for the first '<' character
        guard let firstStart = string.firstIndex(of: "<") else {
            return result
        }

        // Look for the last '>' character by reversing the string
        guard let lastEnd = string.reversed().firstIndex(of: ">") else {
            return result
        }

        // Make sure the braces are in the right order (< and then >)
        guard firstStart < lastEnd.base else {
            return result
        }

        end = string.index(before: string.endIndex)
        start = string.index(after: firstStart)

        // If there are more '<' and '>' characters, recursively call the method
        if firstStart != lastEnd.base {
            let innerString = String(string[start..<end])
            result = extract(from: innerString)
        } else {
            result = String(string[start..<lastEnd.base])
        }

        return result
    }
}
