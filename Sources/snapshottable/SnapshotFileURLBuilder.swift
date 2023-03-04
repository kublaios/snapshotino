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

    /// Builds a URL for the snapshot file path.
    ///
    /// - Parameters:
    ///   - filePath: The path of any file at the folder where the snapshot will be placed.
    ///     Ideally, this is the path of the test file so that the snapshots are placed in the same directory as the test file.
    ///   - type: The Swift type of the object being snapshotted. It is used to create the file name.
    ///   - subDirectory: Optional subdirectory name. Defaults to `__snapshots__`.
    ///   - createSubdirectoryIfMissing: Whether to create the subdirectory if it is missing.
    ///
    /// - Returns: The URL of the snapshot file path.
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
