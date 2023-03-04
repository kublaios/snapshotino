//
//  SnapshotRecorder.swift
//  KleinSnapshotTestingTests
//
//  Created by Kubilay Erdogan on 2023-03-02.
//

import Foundation
import UIKit

struct SnapshotRecorder {
    enum SnapshotRecorderError: Error {
        case imageProcessingError, imageWritingError
    }

    /// Records a snapshot image to the file system.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot image to record.
    ///   - type: The Swift type of the object being snapshotted. It is used as the file name.
    ///   - filePath: The path of any file at the folder where the snapshot will be placed.
    ///     Ideally, this is the path of the test file so that the snapshots are placed in the same directory as the test file.
    ///
    /// - Throws: `SnapshotRecorderError` if the image cannot be processed or written to the file system.
    func record(_ snapshot: UIImage, ofType type: Any.Type, nextTo filePath: String) throws {
        guard let imageData = snapshot.pngData() else {
            throw SnapshotRecorderError.imageProcessingError
        }

        let recordAtURL = try SnapshotFileURLBuilder()
            .build(
                nextTo: filePath,
                forType: type,
                createSubdirectoryIfMissing: true
            )

        do {
            try imageData.write(to: recordAtURL)
        } catch {
            throw SnapshotRecorderError.imageWritingError
        }
    }
}
