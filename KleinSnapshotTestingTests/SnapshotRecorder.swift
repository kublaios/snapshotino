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
            // Write the image data to the file
            try imageData.write(to: recordAtURL)
        } catch {
            throw SnapshotRecorderError.imageWritingError
        }
    }
}
