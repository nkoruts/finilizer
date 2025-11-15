//
//  ClassVisitor.swift
//  finilizer
//
//  Created by Nikita Koruts on 13.11.2025.
//

import Foundation
import SwiftSyntax

class ClassVisitor: SyntaxVisitor {
    private var nonFinalClasses: Set<String> = []
    private var inheritedTypes: Set<String> = []
    
    var finalizableClasses: Set<String> { nonFinalClasses.subtracting(inheritedTypes) }
    
    init() {
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visitPost(_ node: ClassDeclSyntax) {
        guard !node.modifiers.contains(where: { $0.name.text == "final" }) else { return }
        nonFinalClasses.insert(node.name.text)
        
        guard let inherited = node.inheritanceClause?.inheritedTypes, !inherited.isEmpty else { return }
        inheritedTypes.formUnion(inherited.compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.text })
    }
}
