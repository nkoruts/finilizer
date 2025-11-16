// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSyntax
import SwiftParser

@main struct ClassFinilizer {
    
    static func main() {
        print("Enter the path to the root directory:")
        guard let directoryPath = readLine(), !input.isEmpty else {
            print("Path not entered. Finished.")
            exit(1)
        }
        
        let filePaths = FileTreeReader().readFromDirectory(with: directoryPath)
        let visitor = ClassVisitor()
        let trees: [SourceFileSyntax] = filePaths.compactMap {
            guard let content = try? String(contentsOf: $0, encoding: .utf8) else {
                print("File doesn't exist.")
                return nil
            }
            return Parser.parse(source: content)
        }
        visitor.walk(through: trees)
        
        let finalizableClasses = visitor.finalizableClasses
        guard !finalizableClasses.isEmpty else { return }
        let rewriter = ClassRewriter(finilizableClasses: finalizableClasses)
        trees.enumerated().forEach { index, tree in
            guard index < filePaths.count else { return }
            let modifiedTree = rewriter.visit(tree)
            try? "\(modifiedTree)".write(to: filePaths[index], atomically: false, encoding: .utf8)
        }
    }
}
