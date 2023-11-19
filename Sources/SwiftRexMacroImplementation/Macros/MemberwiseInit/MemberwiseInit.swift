import SwiftSyntax
import SwiftSyntaxMacros
import Foundation

public struct NoMemberwiseInit: PeerMacro {
    public static let attributeName = "@NoMemberwiseInit"

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(VariableDeclSyntax.self) else {
            throw MacroError.notAVariableDeclaration
        }

        return []
    }
}

struct Property {
    let propertyName: TokenSyntax
    let propertyType: TypeSyntaxProtocol
    let defaultValue: InitializerClauseSyntax?
}

public struct MemberwiseInit: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.notAStruct
        }

        let members = structDeclaration
            .memberBlock
            .members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { !$0.attributes.contains(where: { $0.trimmedDescription.starts(with: NoMemberwiseInit.attributeName) }) }
            .flatMap { line in
                line
                    .bindings
                    .reversed()
                    .reduce((properties: [Property](), lastKnownType: TypeSyntaxProtocol?.none)) { accumulator, current in
                        switch line.bindingSpecifier.tokenKind {
                        case TokenKind.keyword(.let):
                            if current.initializer != nil {
                                return accumulator
                            }
                        case TokenKind.keyword(.var):
                            if current.accessorBlock?.accessors.kind == .codeBlockItemList {
                                return accumulator
                            }
                            if current.accessorBlock?.accessors.kind == .accessorDeclList, 
                                let accessorDecl = current.accessorBlock?.accessors.as(AccessorDeclListSyntax.self),
                               accessorDecl.contains(where: { $0.accessorSpecifier.tokenKind == .keyword(.get) }) {
                                return accumulator
                            }
                            break
                        default:
                            return accumulator
                        }

                        let (properties, lastKnownType) = accumulator
                        let defaultValue = current.initializer
                        let newType: TypeSyntaxProtocol? =
                            (current.typeAnnotation?.type).map(inferType(from:))
                            ?? defaultValue.flatMap(inferType(from:))

                        guard let propertyName = current.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
                            return (properties: properties, lastKnownType: newType ?? lastKnownType)
                        }

                        guard let propertyType = newType ?? lastKnownType else {
                            return (properties: properties, lastKnownType: newType ?? lastKnownType)
                        }

                        return (
                            properties: [.init(propertyName: propertyName, propertyType: propertyType, defaultValue: defaultValue)] + properties,
                            lastKnownType: propertyType
                        )
                    }
                    .properties
            }

        return [
            ExtensionDeclSyntax(
                extendedType: type,
                memberBlock: .init(members: MemberBlockItemListSyntax.init(itemsBuilder: {
                    InitializerDeclSyntax(
                        signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: .init(itemsBuilder: {
                            for member in members {
                                FunctionParameterSyntax(
                                    firstName: member.propertyName,
                                    type: member.propertyType,
                                    defaultValue: member.defaultValue
                                )
                            }
                        }))),
                        bodyBuilder: {
                            for member in members {
                                InfixOperatorExprSyntax(
                                    leftOperand: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .`self`),
                                        declName: DeclReferenceExprSyntax(baseName: member.propertyName)
                                    ),
                                    operator: AssignmentExprSyntax(),
                                    rightOperand: DeclReferenceExprSyntax(baseName: member.propertyName)
                                )
                            }
                        }
                    ).set(visibility: node.visibility)
                }))
            )
        ]
    }
}

func inferType(from typeSyntax: TypeSyntax) -> TypeSyntaxProtocol? {
    if let tuple = typeSyntax.as(TupleTypeSyntax.self),
       tuple.elements.count == 1,
       let singleTupleElement = tuple.elements.first {
        return inferType(from: singleTupleElement.type)
    }
    if let closure = typeSyntax.as(FunctionTypeSyntax.self) {
        return AttributedTypeSyntax(
            attributes: AttributeListSyntax(itemsBuilder: {
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(name: .keyword(.escaping))
                )
            }),
            baseType: closure
        )
    }
    return typeSyntax.with(\.trailingTrivia, Trivia())
}

func inferType(from initializer: InitializerClauseSyntax) -> TypeSyntaxProtocol? {
    if let tuple = initializer.value.as(TupleExprSyntax.self),
       tuple.elements.count == 1,
       let singleTupleElement = tuple.elements.first {
        return inferType(from: singleTupleElement.expression)
    }
    return inferType(from: initializer.value)
}

func inferType(from expressionSyntax: ExprSyntax) -> TypeSyntaxProtocol? {
    if expressionSyntax.as(StringLiteralExprSyntax.self) != nil { return .from(String.self) }
    if expressionSyntax.as(IntegerLiteralExprSyntax.self) != nil { return .from(Int.self) }
    if expressionSyntax.as(FloatLiteralExprSyntax.self) != nil { return .from(Double.self) }
    if expressionSyntax.as(BooleanLiteralExprSyntax.self) != nil { return .from(Bool.self) }
    if let tuple = expressionSyntax.as(TupleExprSyntax.self) {
        return TupleTypeSyntax(elements: .init(itemsBuilder: {
            for element in tuple.elements {
                if let innerType = inferType(from: element.expression) {
                    TupleTypeElementSyntax(
                        firstName: element.label,
                        colon: element.label != nil ? TokenSyntax.colonToken() : nil,
                        type: innerType
                    )
                }
            }
        }))
    }

    if let functionCall = expressionSyntax.as(FunctionCallExprSyntax.self) {
        if let name = functionCall.calledExpression.as(MemberAccessExprSyntax.self)?.base?.as(DeclReferenceExprSyntax.self)?.baseName {
            return IdentifierTypeSyntax(name: name)
        }

        if let name = functionCall.calledExpression.as(ArrayExprSyntax.self)?.elements.first?.expression.as(DeclReferenceExprSyntax.self)?.baseName {
            return ArrayTypeSyntax(element: IdentifierTypeSyntax(name: name))
        }

        if let element = functionCall.calledExpression.as(DictionaryExprSyntax.self)?.content.as(DictionaryElementListSyntax.self)?.first,
           let key = element.key.as(DeclReferenceExprSyntax.self)?.baseName,
           let value = element.value.as(DeclReferenceExprSyntax.self)?.baseName{
            return DictionaryTypeSyntax(key: IdentifierTypeSyntax(name: key), value: IdentifierTypeSyntax(name: value))
        }

        if let name = functionCall.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName {
            return IdentifierTypeSyntax(name: name)
        }

        return TypeSyntax(stringLiteral: functionCall.calledExpression.description)
    }

    if let name = expressionSyntax.as(MemberAccessExprSyntax.self)?.base?.as(DeclReferenceExprSyntax.self)?.baseName {
        return IdentifierTypeSyntax(name: name)
    }

    if let name = expressionSyntax.as(MemberAccessExprSyntax.self)?.base?.as(OptionalChainingExprSyntax.self)?.expression.as(DeclReferenceExprSyntax.self)?.baseName {
        return OptionalTypeSyntax(wrappedType: IdentifierTypeSyntax(name: name))
    }

    if let name = expressionSyntax.as(MemberAccessExprSyntax.self)?.base {
        return TypeSyntax(stringLiteral: name.description)
    }

    return nil
}
