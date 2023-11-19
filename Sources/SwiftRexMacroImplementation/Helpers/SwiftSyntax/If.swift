import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

public func `if`(
    _ condition: @autoclosure () -> ConditionElementSyntax,
    @CodeBlockItemListBuilder whenTrue: () -> CodeBlockItemListSyntax
) -> IfExprSyntax {
    IfExprSyntax(
        conditions: .init(itemsBuilder: {
            condition()
        }),
        body: .init(statementsBuilder: {
            whenTrue()
        })
    )
}

public func `if`(
    _ condition: @autoclosure () -> ConditionElementSyntax,
    @CodeBlockItemListBuilder whenTrue: () -> CodeBlockItemListSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> IfExprSyntax {
    IfExprSyntax(
        conditions: .init(itemsBuilder: {
            condition()
        }),
        body: .init(statementsBuilder: {
            whenTrue()
        }),
        elseKeyword: TokenSyntax(.keyword(.else), presence: .present),
        elseBody: .init(.init(statementsBuilder: {
            whenFalse()
        }))
    )
}

public func `if`(
    _ patternMatch: @autoclosure () -> MatchingPatternConditionSyntax,
    @CodeBlockItemListBuilder whenTrue: () -> CodeBlockItemListSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> IfExprSyntax {
    IfExprSyntax(
        conditions: .init(itemsBuilder: {
            patternMatch()
        }),
        body: .init(statementsBuilder: {
            whenTrue()
        }),
        elseKeyword: TokenSyntax(.keyword(.else), presence: .present),
        elseBody: .init(.init(statementsBuilder: {
            whenFalse()
        }))
    )
}

public func `if`(
    caseLet token: TokenSyntax,
    equalsTo: TokenSyntax,
    @CodeBlockItemListBuilder whenTrue: () -> CodeBlockItemListSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> IfExprSyntax {
    `if`(`case`(let: token, equalsTo: .`self`)) {
        whenTrue()
    } else: {
        whenFalse()
    }
}
