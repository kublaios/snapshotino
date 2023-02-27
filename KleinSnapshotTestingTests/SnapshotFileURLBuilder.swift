//
//  SnapshotFileURLBuilder.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import Foundation

struct SnapshotFileURLBuilder {
    enum SnapshotFileURLBuilderError: Error {
        case invalidFilePath, directoryCreationError
    }

    let fileManager: FileManager = .default

    func build(
        nextTo filePath: String,
        forType type: Any.Type,
        subDirectory: String = "__snapshots__",
        createSubdirectoryIfMissing: Bool = false
    ) throws -> URL {
        guard let index = filePath.lastIndex(of: "/") else {
            throw SnapshotFileURLBuilderError.invalidFilePath
        }

        let directory = String(filePath.prefix(upTo: index))

        if createSubdirectoryIfMissing {
            let snapshotsDirectoryURL = URL(fileURLWithPath: directory).appendingPathComponent(subDirectory, isDirectory: true)
            do {
                try fileManager.createDirectory(at: snapshotsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw SnapshotFileURLBuilderError.directoryCreationError
            }
        }

        let fileName = TypeNameExtractor
            .extract(from: "\(type)")
            .appending(".png")

        return URL(fileURLWithPath: directory)
            .appendingPathComponent(subDirectory, isDirectory: true)
            .appendingPathComponent(fileName)
    }
}
