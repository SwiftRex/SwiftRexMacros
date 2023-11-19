import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

public func `guard`(
    _ patternMatch: @autoclosure () -> MatchingPatternConditionSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> GuardStmtSyntax {
    GuardStmtSyntax(conditions: .init(itemsBuilder: {
        patternMatch()
    })) {
        whenFalse()
    }
}

public func `guard`(
    _ condition: @autoclosure () -> ConditionElementSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> GuardStmtSyntax {
    GuardStmtSyntax(conditions: .init(itemsBuilder: {
        condition()
    })) {
        whenFalse()
    }
}

public func `guard`(
    @ConditionElementListBuilder _ conditions: () -> ConditionElementListSyntax,
    @CodeBlockItemListBuilder else whenFalse: () -> CodeBlockItemListSyntax
) -> GuardStmtSyntax {
    GuardStmtSyntax(conditions: .init(itemsBuilder: conditions)) {
        whenFalse()
    }
}
