//
//  ClassVisitor.swift
//  finilizer
//
//  Created by Nikita Koruts on 13.11.2025.
//

import Foundation
import SwiftSyntax
import SwiftParser

struct ClassDeclInfo {
    let name: String
    let filePath: URL
}

final class ClassVisitor: SyntaxVisitor {
    
    private var nonFinalClasses: [ClassDeclInfo] = []
    private var inheritedTypes: Set<String> = []
    private var currentFilePath: URL?
    
    public var finalizableClasses: [ClassDeclInfo] {
        nonFinalClasses.filter { !inheritedTypes.contains($0.name) }
    }
    
    init() {
        super.init(viewMode: .sourceAccurate)
    }
    
    public func visit(_ paths: [URL]) {
        for url in paths {
            guard let content = try? String(contentsOf: url, encoding: .utf8) else {
                print("File doesn't exist: \(url)")
                continue
            }
            let source = Parser.parse(source: content)
            self.currentFilePath = url
            self.walk(source)
        }
    }
    
    override func visitPost(_ node: ClassDeclSyntax) {
        guard let filePath = currentFilePath else { return }
        guard !node.modifiers.contains(where: { $0.name.text == "final" || $0.name.text == "open" }) else { return }
        let declInfo = ClassDeclInfo(name: node.name.text, filePath: filePath)
        nonFinalClasses.append(declInfo)
        
        guard let inherited = node.inheritanceClause?.inheritedTypes, !inherited.isEmpty else { return }
        inheritedTypes.formUnion(inherited.compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.text })
    }
}
