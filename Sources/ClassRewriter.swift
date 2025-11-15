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
        let finalModifier = DeclModifierSyntax(name: .keyword(.final))
        let newModifiersList = [finalModifier] + node.modifiers
        let newNode = node.with(\.modifiers, newModifiersList)
        return DeclSyntax(super.visit(newNode))
    }
}
