//
//  EnvironmentKeyMacro.swift
//
//
//  Created by Alejandro Maya on 31/05/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum EnvironmentKeyDiagnosticMessage: Identifiable, DiagnosticMessage {
    case missingDefaultValue

    var severity: DiagnosticSeverity { .error }
    var diagnosticID: MessageID { MessageID(domain: "EnvironmentKeyMacro", id: id) }

    var message: String {
        switch self {
        case .missingDefaultValue:
            "No default value provided."
        }
    }

    var id: String {
        switch self {
        case .missingDefaultValue:
            "noDefaultArgument"
        }
    }
}

public struct EnvironmentKeyMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self),
              let patternBinding = variableDeclaration.bindings.first,
              let patternName = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
            return []
        }

        let isOptional = patternBinding.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
        let hasDefaultValue = patternBinding.initializer != nil

        guard isOptional || hasDefaultValue else {
            context.diagnose(Diagnostic(node: Syntax(node), message: EnvironmentKeyDiagnosticMessage.missingDefaultValue))
            return []
        }

        let structName = structName(identifier: patternName)
        let defaultValueBinding = patternBinding
            .with(\.pattern, PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("defaultValue"))))
        let optionalInitializer = isOptional && !hasDefaultValue ? "= nil" : ""
        return [
            """
            private struct \(structName): EnvironmentKey {
                static let \(defaultValueBinding) \(raw: optionalInitializer)
            }
            """
        ]
    }
}

extension EnvironmentKeyMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self),
              let patternBinding = variableDeclaration.bindings.first,
              let patternName = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
            return []
        }

        let structName = structName(identifier: patternName)
        return [
            """
            get {
                self[\(structName).self]
            }
            """,
            """
            set {
                self[\(structName).self] = newValue
            }
            """
        ]
    }
}

private extension EnvironmentKeyMacro {
    static func structName(identifier: TokenSyntax) -> TokenSyntax {
        return TokenSyntax(
            stringLiteral: "EnvironmentKey" + identifier.text.prefix(1).capitalized + identifier.text.dropFirst()
        )
    }
}
