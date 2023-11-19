import SwiftCompilerPlugin
import SwiftSyntaxMacros
import Foundation

@main
struct PrismPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Prism.self,
        PrismCase.self,
        NoPrism.self,
        MemberwiseInit.self,
        NoMemberwiseInit.self
    ]
}
