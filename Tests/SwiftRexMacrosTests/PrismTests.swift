import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftRexMacroImplementation)
import SwiftRexMacroImplementation

let testMacros: [String: Macro.Type] = [
    "Prism": Prism.self,
    "PrismCase": PrismCase.self,
    "NoPrism": NoPrism.self,
    "MemberwiseInit": MemberwiseInit.self,
    "NoMemberwiseInit": NoMemberwiseInit.self
    // "NoMemberwiseInitDefaultValue": NoMemberwiseInitDefaultValue.self,
]
#endif

final class PrismTests: XCTestCase {
    func testPrismEmptyEnum() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color { }
            """,
            expandedSource: """
            enum Color { }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismInStructError() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            struct Color { }
            """,
            expandedSource: """
            struct Color { }
            """,
            diagnostics: [
                .init(message: "This macro has to be attached to an Enum declaration", line: 1, column: 1)
            ],
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCase() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red
            }
            """,
            expandedSource:
            """
            enum Color {
                case red

                var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithSingleUnnamedAssociatedValue() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(Double)

                var red: Double? {
                    get {
                        guard case let .red(value) = self else {
                            return nil
                        }
                        return value
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(newValue)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithSingleNamedAssociatedValue() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(brightness: Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(brightness: Double)

                var red: Double? {
                    get {
                        guard case let .red(value) = self else {
                            return nil
                        }
                        return value
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(brightness: newValue)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithDualUnnamedAssociatedValues() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(Double, Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(Double, Double)

                var red: (Double, Double)? {
                    get {
                        guard case let .red(associatedValue0, associatedValue1) = self else {
                            return nil
                        }
                        return (associatedValue0, associatedValue1)
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(newValue.0, newValue.1)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithDualNamedAssociatedValues() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(brightness: Double, opacity: Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(brightness: Double, opacity: Double)

                var red: (brightness: Double, opacity: Double)? {
                    get {
                        guard case let .red(brightness, opacity) = self else {
                            return nil
                        }
                        return (brightness: brightness, opacity: opacity)
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(brightness: newValue.brightness, opacity: newValue.opacity)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithDualAssociatedValuesOnlyFirstNamed() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(brightness: Double, Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(brightness: Double, Double)

                var red: (brightness: Double, Double)? {
                    get {
                        guard case let .red(brightness, associatedValue1) = self else {
                            return nil
                        }
                        return (brightness: brightness, associatedValue1)
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(brightness: newValue.brightness, newValue.1)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseWithDualAssociatedValuesOnlySecondNamed() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red(Double, opacity: Double)
            }
            """,
            expandedSource:
            """
            enum Color {
                case red(Double, opacity: Double)

                var red: (Double, opacity: Double)? {
                    get {
                        guard case let .red(associatedValue0, opacity) = self else {
                            return nil
                        }
                        return (associatedValue0, opacity: opacity)
                    }
                    set {
                        guard case .red = self, let newValue = newValue else {
                            return
                        }
                        self = .red(newValue.0, opacity: newValue.opacity)
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCasePublic() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .public)
            enum Color {
                case red
            }
            """,
            expandedSource:
            """
            enum Color {
                case red

                public var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseInternal() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .internal)
            enum Color {
                case red
            }
            """,
            expandedSource:
            """
            enum Color {
                case red

                internal var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                internal var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCaseFilePrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .fileprivate)
            enum Color {
                case red
            }
            """,
            expandedSource:
            """
            enum Color {
                case red

                fileprivate var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                fileprivate var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismSingleCasePrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .private)
            enum Color {
                case red
            }
            """,
            expandedSource:
            """
            enum Color {
                case red

                private var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                private var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismMultipleCasesInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .public)
            enum Color {
                case red, green, blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red, green, blue

                public var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var blue: Void? {
                    if case .blue = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }

                public var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }

                public var isBlue: Bool {
                    if case .blue = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismMultipleCasesVertical() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .public)
            enum Color {
                case red
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green
                case blue

                public var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var blue: Void? {
                    if case .blue = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }

                public var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }

                public var isBlue: Bool {
                    if case .blue = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseSingle() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseMultipleInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase
                case green, blue
                case white
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green, blue

                var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                var blue: Void? {
                    if case .blue = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }

                var isBlue: Bool {
                    if case .blue = self {
                        true
                    } else {
                        false
                    }
                }
                case white
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseSinglePublic() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase(visibility: .public)
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                public var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseSingleInternal() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase(visibility: .internal)
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                internal var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                internal var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseSingleFilePrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase(visibility: .fileprivate)
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                fileprivate var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                fileprivate var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismCaseSinglePrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            enum Color {
                case red
                @PrismCase(visibility: .private)
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                private var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                private var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testPrismPublicPrismCaseInternal() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .public)
            enum Color {
                case red
                @PrismCase(visibility: .internal)
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green

                internal var green: Void? {
                    if case .green = self {
                        ()
                    } else {
                        nil
                    }
                }

                internal var isGreen: Bool {
                    if case .green = self {
                        true
                    } else {
                        false
                    }
                }
                case blue

                public var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var blue: Void? {
                    if case .blue = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }

                public var isBlue: Bool {
                    if case .blue = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testNoPrismSingle() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red
                @NoPrism
                case green
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green
                case blue

                var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                var blue: Void? {
                    if case .blue = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }

                var isBlue: Bool {
                    if case .blue = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testNoPrismMultipleInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red
                @NoPrism
                case green, blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green, blue

                var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testNoPrismMultipleVertical() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism
            enum Color {
                case red
                @NoPrism
                case green
                @NoPrism
                case blue
            }
            """,
            expandedSource:
            """
            enum Color {
                case red
                case green
                case blue

                var red: Void? {
                    if case .red = self {
                        ()
                    } else {
                        nil
                    }
                }

                var isRed: Bool {
                    if case .red = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMixed() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @Prism(visibility: .public)
            enum Bla {
                case x, y, z
                case zzzz, xxxx
                @PrismCase(visibility: .private)
                case a(String)
                case b
                case c(Int, other: Date)
                case d(first: Int = 3, other: Date)
                case e(Int, Date)
                case someLongName
                @NoPrism
                case toBeIgnored
                @NoPrism
                case both, are, too, be, ignored

                var blablabla: String { "aaaa" }
                func blebleble() -> Int { 3 }
            }
            """,
            expandedSource:
            """
            enum Bla {
                case x, y, z
                case zzzz, xxxx
                case a(String)

                private var a: String? {
                    get {
                        guard case let .a(value) = self else {
                            return nil
                        }
                        return value
                    }
                    set {
                        guard case .a = self, let newValue = newValue else {
                            return
                        }
                        self = .a(newValue)
                    }
                }

                private var isA: Bool {
                    if case .a = self {
                        true
                    } else {
                        false
                    }
                }
                case b
                case c(Int, other: Date)
                case d(first: Int = 3, other: Date)
                case e(Int, Date)
                case someLongName
                case toBeIgnored
                case both, are, too, be, ignored

                var blablabla: String { "aaaa" }
                func blebleble() -> Int { 3 }

                public var x: Void? {
                    if case .x = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var y: Void? {
                    if case .y = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var z: Void? {
                    if case .z = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var zzzz: Void? {
                    if case .zzzz = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var xxxx: Void? {
                    if case .xxxx = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var b: Void? {
                    if case .b = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var c: (Int, other: Date)? {
                    get {
                        guard case let .c(associatedValue0, other) = self else {
                            return nil
                        }
                        return (associatedValue0, other: other)
                    }
                    set {
                        guard case .c = self, let newValue = newValue else {
                            return
                        }
                        self = .c(newValue.0, other: newValue.other)
                    }
                }

                public var d: (first: Int , other: Date)? {
                    get {
                        guard case let .d(first, other) = self else {
                            return nil
                        }
                        return (first: first, other: other)
                    }
                    set {
                        guard case .d = self, let newValue = newValue else {
                            return
                        }
                        self = .d(first: newValue.first, other: newValue.other)
                    }
                }

                public var e: (Int, Date)? {
                    get {
                        guard case let .e(associatedValue0, associatedValue1) = self else {
                            return nil
                        }
                        return (associatedValue0, associatedValue1)
                    }
                    set {
                        guard case .e = self, let newValue = newValue else {
                            return
                        }
                        self = .e(newValue.0, newValue.1)
                    }
                }

                public var someLongName: Void? {
                    if case .someLongName = self {
                        ()
                    } else {
                        nil
                    }
                }

                public var isX: Bool {
                    if case .x = self {
                        true
                    } else {
                        false
                    }
                }

                public var isY: Bool {
                    if case .y = self {
                        true
                    } else {
                        false
                    }
                }

                public var isZ: Bool {
                    if case .z = self {
                        true
                    } else {
                        false
                    }
                }

                public var isZzzz: Bool {
                    if case .zzzz = self {
                        true
                    } else {
                        false
                    }
                }

                public var isXxxx: Bool {
                    if case .xxxx = self {
                        true
                    } else {
                        false
                    }
                }

                public var isB: Bool {
                    if case .b = self {
                        true
                    } else {
                        false
                    }
                }

                public var isC: Bool {
                    if case .c = self {
                        true
                    } else {
                        false
                    }
                }

                public var isD: Bool {
                    if case .d = self {
                        true
                    } else {
                        false
                    }
                }

                public var isE: Bool {
                    if case .e = self {
                        true
                    } else {
                        false
                    }
                }
            
                public var isSomeLongName: Bool {
                    if case .someLongName = self {
                        true
                    } else {
                        false
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
