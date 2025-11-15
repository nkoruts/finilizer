// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSyntax
import SwiftParser

@main struct ClassFinilizer {
    
    static func main() {
        let filePaths: [String] = [ /*TODO: Add paths*/ ]
        
        let visitor = ClassVisitor()
        let trees: [SourceFileSyntax] = filePaths.compactMap {
            guard let content = try? String(contentsOfFile: $0, encoding: .utf8) else {
                print("File doesn't exist.")
                return nil
            }
            return Parser.parse(source: content)
        }
        trees.forEach { visitor.walk($0) }
        
        let rewriter = ClassRewriter(finilizableClasses: visitor.finalizableClasses)
        let _ = trees.map { rewriter.visit($0) }
    }
}
