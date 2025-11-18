//
//  FileTreeReader.swift
//  finilizer
//
//  Created by Nikita Koruts on 16.11.2025.
//

import Foundation

struct FileTreeReader {
    
    public func readFromDirectory(path: URL) -> [URL] {
        guard FileManager.default.fileExists(atPath: path.path()) else {
            print("Directory not found at path: \(path)")
            return []
        }
        guard let enumerator = FileManager.default.enumerator(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            print("Files not found in this path: \(path)")
            return []
        }
        return enumerator.compactMap { element in
            guard let url = element as? URL, url.pathExtension == "swift" else { return nil }
            return url
        }
    }
}
