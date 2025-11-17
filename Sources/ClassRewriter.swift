//
//  ClassRewriter.swift
//  finilizer
//
//  Created by Nikita Koruts on 13.11.2025.
//

import Foundation
import SwiftSyntax
import SwiftParser

final class ClassRewriter: SyntaxRewriter {
    
    private let finilizableClasses: [ClassDeclInfo]
    
    init(finilizableClasses: [ClassDeclInfo]) {
        self.finilizableClasses = finilizableClasses
    }
    
    public func visit(paths: [URL]) {
        for url in paths {
            guard finilizableClasses.contains(where: { $0.filePath == url }),
                  let content = try? String(contentsOf: url, encoding: .utf8)
            else { continue }
            let source = Parser.parse(source: content)
            let modifiedFile = self.visit(source)
            try? "\(modifiedFile)".write(to: url, atomically: false, encoding: .utf8)
        }
    }
    
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard finilizableClasses.contains(where: { $0.name == node.name.text }) else {
            return DeclSyntax(super.visit(node))
        }
        
        var modifiersList: DeclModifierListSyntax
        if !node.modifiers.isEmpty {
            let leadingTrivia = !node.classKeyword.leadingTrivia.isEmpty ? Trivia.space : nil
            let finalModifier = DeclModifierSyntax(leadingTrivia: leadingTrivia, name: .keyword(.final))
            modifiersList = node.modifiers + [finalModifier]
        } else {
            let leadingTrivia = node.attributes.isEmpty ? node.leadingTrivia : .newline
            let finalModifier = DeclModifierSyntax(leadingTrivia: leadingTrivia, name: .keyword(.final))
            modifiersList = DeclModifierListSyntax(arrayLiteral: finalModifier)
        }

        let modifiedNode = node
            .with(\.classKeyword, .keyword(.class, leadingTrivia: .space, trailingTrivia: .space))
            .with(\.modifiers, modifiersList)
        return DeclSyntax(super.visit(modifiedNode))
    }
}
