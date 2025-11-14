// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftParser

@main struct ClassFinilizer {
    
    static func main() {
        let filePaths: [String] = [ /*TODO: Add paths*/ ]
        
        let visitor = ClassVisitor()
        filePaths.forEach { filePath in
            guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
                print("File doesn't exist.")
                return
            }
            let tree = Parser.parse(source: content)
            visitor.walk(tree)
        }
        let finilizableClasses = visitor.finalizableClasses
        print("Finilizable classes: \(finilizableClasses)")
    }
}
