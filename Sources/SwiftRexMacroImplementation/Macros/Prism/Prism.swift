import SwiftSyntax
import SwiftSyntaxMacros
import Foundation

public struct NoPrism: PeerMacro {
    public static let attributeName = "@NoPrism"

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(EnumCaseDeclSyntax.self) else {
            throw MacroError.notAnEnumCase
        }

        return []
    }
}

public struct PrismCase: PeerMacro {
    public static let attributeName = "@PrismCase"

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let enumCaseDeclaration = declaration.as(EnumCaseDeclSyntax.self) else {
            throw MacroError.notAnEnumCase
        }

        let cases = enumCaseDeclaration.elements.compactMap { $0.name.text.isEmpty ? nil : $0 }
        return cases.map(\.prism).map { $0.set(visibility: node.visibility) }.map(DeclSyntax.init)
        + cases.map(\.predicate).map { $0.set(visibility: node.visibility) }.map(DeclSyntax.init)
    }
}

public struct Prism: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError.notAnEnum
        }

        let cases = enumDeclaration
            .memberBlock
            .members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .filter { !$0.attributes.contains(where: { $0.trimmedDescription.starts(with: NoPrism.attributeName) || $0.trimmedDescription.starts(with: PrismCase.attributeName) }) }
            .flatMap {
                $0.elements.compactMap { $0.name.text.isEmpty ? nil : $0 }
            }

        let (prisms, predicates) = (
            cases
                .map(\.prism).map { $0.set(visibility: node.visibility) }
                .map { MemberBlockItemSyntax(decl: $0) },
            cases
                .map(\.predicate).map { $0.set(visibility: node.visibility) }
                .map { MemberBlockItemSyntax(decl: $0) }
        )

        return [
            prisms.isEmpty ? nil : ExtensionDeclSyntax(
                attributes: AttributeListSyntax(""),
                extendedType: type,
                memberBlock: .init(members: MemberBlockItemListSyntax(prisms))
            ),
            predicates.isEmpty ? nil : ExtensionDeclSyntax(
                attributes: AttributeListSyntax(""),
                extendedType: type,
                memberBlock: .init(members: MemberBlockItemListSyntax(predicates))
            )
        ].compactMap { $0 }
    }
}
