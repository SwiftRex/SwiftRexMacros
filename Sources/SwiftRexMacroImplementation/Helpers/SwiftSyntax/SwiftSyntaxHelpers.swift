import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension String {
    public var asToken: TokenSyntax {
        .identifier(self)
    }
}

protocol HasModifiers {
    var modifiers: DeclModifierListSyntax { get set }
}

extension InitializerDeclSyntax: HasModifiers { }
extension VariableDeclSyntax: HasModifiers { }

extension DeclSyntaxProtocol where Self: HasModifiers {
    func set(visibility: DeclModifierSyntax?) -> Self {
        visibility.map {
            with(\.modifiers, modifiers + [$0])
        } ?? self
    }
}

extension CodeBlockItemListSyntax {
    public static func block(_ expression: () -> ExprSyntaxProtocol) -> CodeBlockItemListSyntax {
        CodeBlockItemListSyntax {
            ExpressionStmtSyntax(expression: expression())
        }
    }
}

extension AccessorBlockSyntax.Accessors {
    public static func accessors(
        @CodeBlockItemListBuilder get getter: () -> CodeBlockItemListSyntax,
        @CodeBlockItemListBuilder set setter: () -> CodeBlockItemListSyntax
    ) -> AccessorBlockSyntax.Accessors {
        return .init(AccessorDeclListSyntax.init {
            AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                bodyBuilder: getter
            )
            AccessorDeclSyntax(
                accessorSpecifier: .keyword(.set),
                bodyBuilder: setter
            )
        })
    }
}

extension TypeAnnotationSyntax {
    public static func from<T>(_ t: T.Type) -> TypeAnnotationSyntax {
        TypeAnnotationSyntax(type: .from(t))
    }
}

extension TypeSyntaxProtocol where Self == IdentifierTypeSyntax {
    public static func from<T>(_ t: T.Type) -> IdentifierTypeSyntax {
        IdentifierTypeSyntax(name: .identifier(t is Void.Type ? "Void" : "\(t)"))
    }
}

extension TypeSyntaxProtocol {
    public var ︖: TypeSyntaxProtocol {
        OptionalTypeSyntax(wrappedType: self)
    }
}

extension Syntax {
    public static var `nil`: NilLiteralExprSyntax {
        NilLiteralExprSyntax()
    }
}

extension TokenSyntax {
    public static var `self`: TokenSyntax {
        .keyword(Keyword.`self`)
    }
}

public func voidTuple() -> TupleExprSyntax {
    TupleExprSyntax {
        LabeledExprListSyntax()
    }
}

