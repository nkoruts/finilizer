// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSyntax
import SwiftParser

@main struct ClassFinilizer {
    
    static func main() {
        print("Enter the path to the root directory:")
        guard let path = readLine(), !path.isEmpty else {
            print("Path not entered. Finished.")
            exit(1)
        }
        let directoryPath = URL(fileURLWithPath: path)
        let filePaths = FileTreeReader().readFromDirectory(path: directoryPath)
        let visitor = ClassVisitor()
        visitor.visit(filePaths)
        let finalizableClasses = visitor.finalizableClasses
        guard !finalizableClasses.isEmpty else { return }
        let rewriter = ClassRewriter(finilizableClasses: finalizableClasses)
        rewriter.visit(paths: filePaths)
    }
}
