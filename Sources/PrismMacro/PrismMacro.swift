import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public enum PrismError: Error, CustomDebugStringConvertible, CustomStringConvertible {
    case notAnEnum
    case notAnEnumCase

    public var debugDescription: String {
        description
    }

    public var description: String {
        switch self {
        case .notAnEnum: return "This macro has to be attached to an Enum declaration"
        case .notAnEnumCase: return "This macro has to be attached to an Enum Case"
        }
    }
}

public struct NoPrism: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(EnumCaseDeclSyntax.self) else {
            throw PrismError.notAnEnumCase
        }

        return []
    }
}

public struct PrismCase: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let enumCaseDeclaration = declaration.as(EnumCaseDeclSyntax.self) else {
            throw PrismError.notAnEnumCase
        }

        let cases = enumCaseDeclaration.elements.compactMap { "\($0.name)".isEmpty ? nil : $0 }
        return cases.map(\.prism).map { "\(node.visibility) \($0)" }
        + cases.map(\.predicate).map { "\(node.visibility) \($0)" }
    }
}

extension AttributeSyntax {
    public var visibility: TokenSyntax {
        arguments?
        .as(LabeledExprListSyntax.self)?
        .first(where: { $0.label?.text == "visibility" })?
        .expression
        .as(MemberAccessExprSyntax.self)?
        .declName
        .as(DeclReferenceExprSyntax.self)?
        .baseName
        ?? TokenSyntax(stringLiteral: "")
    }
}

public struct Prism: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            throw PrismError.notAnEnum
        }

        let cases = enumDeclaration
            .memberBlock
            .members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .filter { !$0.attributes.contains(where: { $0.trimmedDescription.starts(with: "@NoPrism") || $0.trimmedDescription.starts(with: "@PrismCase") }) }
            .flatMap {
                $0.elements.compactMap { "\($0.name)".isEmpty ? nil : $0 }
            }

        return cases.map(\.prism).map { "\(node.visibility) \($0)" }
        + cases.map(\.predicate).map { "\(node.visibility) \($0)" }
    }
}

extension EnumCaseElementListSyntax.Element {
    fileprivate var predicate: DeclSyntax {
        "var is\(raw: name.text.uppercaseFirst()): Bool { if case .\(raw: name.text) = self { true } else { false } }"
    }

    fileprivate var prism: DeclSyntax {
        "var \(name): \(raw: parameterClause.formattedType())? { \(extractedAssociatedValues()) }"
    }
}

extension String {
    fileprivate func uppercaseFirst() -> String {
        guard let first = self.first else { return "" }
        return "\(first.uppercased())\(dropFirst())"
    }
}

extension EnumCaseElementListSyntax.Element {
    fileprivate func extractedAssociatedValues() -> DeclSyntax {
        guard let associatedValues = parameterClause else { return guardForVoid() }

        let associatedValueNames: [(isNamed: Bool, name: String)] = associatedValues.parameters.enumerated().map { index, param in
            if let name = param.firstName {
                return (isNamed: true, name: name.text)
            } else {
                return (isNamed: false, name: "\(index)")
            }
        }

        if associatedValueNames.count == 1 {
            return """
                   get {
                       guard case let .\(raw: name.text)(value) = self else { return nil }
                       return value
                   }
                   set {
                       guard case .\(raw: name.text) = self, let newValue = newValue else { return }
                       self = .\(raw: name.text)(\(raw: associatedValueNames.map { $0.isNamed ? "\($0.name): newValue" : "newValue" }.joined(separator: ", ")))
                   }
                   """
        }

        return """
               get {
                   guard case let .\(raw: name.text)(\(raw: associatedValueNames.map { $0.isNamed ? $0.name : "associatedValue\($0.name)" }.joined(separator: ", "))) = self else { return nil }
                   return (\(raw: associatedValueNames.map { $0.isNamed ? "\($0.name): \($0.name)" : "associatedValue\($0.name)" }.joined(separator: ", ")))
               }
               set {
                   guard case .\(raw: name.text) = self, let newValue = newValue else { return }
                   self = .\(raw: name.text)(\(raw: associatedValueNames.map { $0.isNamed ? "\($0.name): newValue.\($0.name)" : associatedValueNames.count > 1 ? "newValue.\($0.name)" : "newValue" }.joined(separator: ", ")))
               }
               """
    }

    private func guardForVoid() -> DeclSyntax {
        "if case .\(raw: name.text) = self { () } else { nil }"
    }
}

extension Optional<EnumCaseParameterClauseSyntax> {
    fileprivate func formattedType() -> String {
        guard
            let associatedValues = self?.parameters,
            let first = associatedValues.first
        else { return "Void" }

        if associatedValues.count == 1 {
            return "\(first.type)"
        }

        return "(" + associatedValues.map(\.tupleElement).joined(separator: ", ") + ")"
    }
}

extension EnumCaseParameterListSyntax.Element {
    fileprivate var tupleElement: String {
        guard let name = firstName else { return "\(type)" }
        return "\(name): \(type)"
    }
}

@main
struct PrismPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Prism.self,
        PrismCase.self,
        NoPrism.self
    ]
}
