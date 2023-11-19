import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

public func `case`(`let` proposedValue: TokenSyntax, equalsTo matchingSubject: TokenSyntax) -> MatchingPatternConditionSyntax {
    MatchingPatternConditionSyntax(
        pattern: ExpressionPatternSyntax(expression: MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: proposedValue))),
        initializer: InitializerClauseSyntax(value: DeclReferenceExprSyntax(baseName: matchingSubject))
    ).with(\.leadingTrivia, .space)
}

public func `case`(`let` proposedValue: TokenSyntax, bindings: [TokenSyntax], equalsTo matchingSubject: TokenSyntax) -> MatchingPatternConditionSyntax {
    MatchingPatternConditionSyntax(
        pattern: ValueBindingPatternSyntax(
            bindingSpecifier: TokenSyntax.keyword(.let),
            pattern: ExpressionPatternSyntax(
                expression: `case`(proposedValue, setters: bindings.map { (label: nil, identifier: $0) })
            )
        ),
        initializer: InitializerClauseSyntax(value: DeclReferenceExprSyntax(baseName: matchingSubject))
    ).with(\.leadingTrivia, .space)
}

public func `case`(_ caseItem: TokenSyntax, setters: [(label: String?, identifier: TokenSyntax)]) -> FunctionCallExprSyntax {
    FunctionCallExprSyntax(
        calledExpression: MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: caseItem)),
        leftParen: TokenSyntax(.leftParen, presence: .present),
        arguments: LabeledExprListSyntax(
            setters.mapIdentifyingLast { item, isLast in
                LabeledExprSyntax(
                    label: item.label,
                    expression: PatternExprSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: item.identifier
                        )
                    )
                ).with(\.trailingComma, isLast ? nil : TokenSyntax(.comma, presence: .present))
            }
        ),
        rightParen: TokenSyntax(.rightParen, presence: .present)
    )
}

public func `case`(_ caseItem: TokenSyntax, setters: [(label: String?, expression: MemberAccessExprSyntax)]) -> FunctionCallExprSyntax {
    FunctionCallExprSyntax(
        calledExpression: MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: caseItem)),
        leftParen: TokenSyntax(.leftParen, presence: .present),
        arguments: LabeledExprListSyntax(
            setters.mapIdentifyingLast { item, isLast in
                LabeledExprSyntax(
                    label: item.label,
                    expression: item.expression
                ).with(\.trailingComma, isLast ? nil : TokenSyntax(.comma, presence: .present))
            }
        ),
        rightParen: TokenSyntax(.rightParen, presence: .present)
    )
}
