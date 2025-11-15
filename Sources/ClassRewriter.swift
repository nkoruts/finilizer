//
//  ClassRewriter.swift
//  finilizer
//
//  Created by Nikita Koruts on 13.11.2025.
//

import Foundation
import SwiftSyntax

class ClassRewriter: SyntaxRewriter {
    private let finilizableClasses: Set<String>
    
    init(finilizableClasses: Set<String>) {
        self.finilizableClasses = finilizableClasses
    }
    
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard finilizableClasses.contains(node.name.text) else { return DeclSyntax(super.visit(node)) }
        
        var modifiersList: DeclModifierListSyntax
        if !node.modifiers.isEmpty {
            let existingModifiers = node.modifiers.compactMap { DeclModifierSyntax(name: $0.name) }
            let leadingTrivia = !node.classKeyword.leadingTrivia.isEmpty ? Trivia.space : nil
            let finalModifier = DeclModifierSyntax(leadingTrivia: leadingTrivia, name: .keyword(.final))
            modifiersList = DeclModifierListSyntax(existingModifiers + [finalModifier])
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
