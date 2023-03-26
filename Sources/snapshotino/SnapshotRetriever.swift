//
//  SnapshotRetriever.swift
//  snapshotino
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import Foundation
import UIKit

struct SnapshotRetriever {
    enum SnapshotRetrieverError: Error {
        case imageRetrievalError, imageCreationError
    }

    let fileManager: FileManager = .default

    /// Retrieves a snapshot image from the file system.
    ///
    /// - Parameters:
    ///   - snapshottable: The object to retrieve the snapshot for.
    ///   - filePath: The path of any file at the folder where the snapshot is placed.
    ///     This is usually the path of the test file if the snapshots are placed in the same directory as the test file.
    ///   - function: The calling method. This value is appended to the snapshot file name.
    ///
    /// - Returns: The snapshot image.
    ///
    /// - Throws: `SnapshotRetrieverError` if the image cannot be retrieved or created.
    func retrieveSnapshot(of snapshottable: Snapshottable, filePath: String = #file, function: String) throws -> UIImage {
        let retrieveFromURL = try SnapshotFileURLBuilder()
            .build(
                nextTo: filePath,
                forType: type(of: snapshottable),
                function: function
            )

        guard let imageData = fileManager.contents(atPath: retrieveFromURL.path) else {
            throw SnapshotRetrieverError.imageRetrievalError
        }

        guard let image = UIImage(data: imageData) else {
            throw SnapshotRetrieverError.imageCreationError
        }

        return image
    }
}
