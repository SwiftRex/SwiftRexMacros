import Foundation
import SwiftSyntax

enum DeclarationVisibility: String {
    static let attributeName = "visibility"
    case `private` = "private"
    case `fileprivate` = "fileprivate"
    case `internal` = "internal"
    case `public` = "public"

    var declModifierSyntax: DeclModifierSyntax {
        DeclModifierSyntax(
            name: TokenSyntax.keyword(
                {
                    switch self {
                    case .private: Keyword.private
                    case .fileprivate: Keyword.fileprivate
                    case .internal: Keyword.internal
                    case .public: Keyword.public
                    }
                }()
            )
        )
    }
}

extension AttributeSyntax {
    public var visibility: DeclModifierSyntax? {
        (
            arguments?
            .as(LabeledExprListSyntax.self)?
            .first(where: { $0.label?.text == DeclarationVisibility.attributeName })?
            .expression
            .as(MemberAccessExprSyntax.self)?
            .declName
            .as(DeclReferenceExprSyntax.self)?
            .baseName
            .text
        )
        .flatMap(DeclarationVisibility.init(rawValue:))
        .map(\.declModifierSyntax)
    }
}
