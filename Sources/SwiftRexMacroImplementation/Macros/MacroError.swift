import Foundation

public enum MacroError: Error, CustomDebugStringConvertible, CustomStringConvertible {
    case notAnEnum
    case notAnEnumCase
    case notAStruct
    case notAVariableDeclaration

    public var debugDescription: String {
        description
    }

    public var description: String {
        switch self {
        case .notAnEnum: return "This macro has to be attached to an Enum declaration"
        case .notAnEnumCase: return "This macro has to be attached to an Enum Case"
        case .notAStruct: return "This macro has to be attached to a Struct declaration"
        case .notAVariableDeclaration: return "This macro has to be attached to a variable declaration"
        }
    }
}
