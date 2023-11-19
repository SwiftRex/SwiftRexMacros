import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftRexMacroImplementation)
import SwiftRexMacroImplementation
#endif

final class MemberwiseInitTests: XCTestCase {
    func testMemberwiseInitEmpty() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard { }
            """,
            expandedSource: """
            struct BlackjackCard { }

            extension BlackjackCard {
                init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitEmptyPublic() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit(visibility: .public)
            struct BlackjackCard { }
            """,
            expandedSource: """
            struct BlackjackCard { }

            extension BlackjackCard {
                public init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInClassError() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            class BlackjackCard { }
            """,
            expandedSource: """
            class BlackjackCard { }
            """,
            diagnostics: [
                .init(message: "This macro has to be attached to a Struct declaration", line: 1, column: 1)
            ],
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstant() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantTupleType() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: (String, String)
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: (String, String)
            }

            extension BlackjackCard {
                init(suit: (String, String)) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantNamedTupleType() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: (a: String, b: String)
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: (a: String, b: String)
            }

            extension BlackjackCard {
                init(suit: (a: String, b: String)) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantPublic() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit(visibility: .public)
            struct BlackjackCard {
                let suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
            }

            extension BlackjackCard {
                public init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantInternal() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit(visibility: .internal)
            struct BlackjackCard {
                let suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
            }

            extension BlackjackCard {
                internal init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantFilePrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit(visibility: .fileprivate)
            struct BlackjackCard {
                let suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
            }

            extension BlackjackCard {
                fileprivate init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantPrivate() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit(visibility: .private)
            struct BlackjackCard {
                let suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
            }

            extension BlackjackCard {
                private init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitTwoConstants() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: String
                let value: Int
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String
                let value: Int
            }

            extension BlackjackCard {
                init(suit: String, value: Int) {
                    self.suit = suit
                    self.value = value
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitTwoConstantsInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit, value: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit, value: String
            }

            extension BlackjackCard {
                init(suit: String, value: String) {
                    self.suit = suit
                    self.value = value
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitThreeConstantsInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit, value, type: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit, value, type: String
            }

            extension BlackjackCard {
                init(suit: String, value: String, type: String) {
                    self.suit = suit
                    self.value = value
                    self.type = type
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitThreeConstantsInlineOneNotAssigned() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit = "diamonds", value = "3", type: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit = "diamonds", value = "3", type: String
            }

            extension BlackjackCard {
                init(type: String) {
                    self.type = type
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitFourDifferentConstantsInline() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit, type: String, value, count: Int
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit, type: String, value, count: Int
            }

            extension BlackjackCard {
                init(suit: String, type: String, value: Int, count: Int) {
                    self.suit = suit
                    self.type = type
                    self.value = value
                    self.count = count
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitFourDifferentConstantsInlineSomeAssigned() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit = "diamonds", type: String, value = 3, count: Int
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit = "diamonds", type: String, value = 3, count: Int
            }

            extension BlackjackCard {
                init(type: String, count: Int) {
                    self.type = type
                    self.count = count
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func testMemberwiseInitConstantAssigned() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: String = "diamonds"
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: String = "diamonds"
            }

            extension BlackjackCard {
                init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleVariable() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitVariableAssigned() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String = "diamonds"
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String = "diamonds"
            }

            extension BlackjackCard {
                init(suit: String = "diamonds") {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitDetuplerizeDeeply() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: ((((String))))
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: ((((String))))
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitDetuplerizeDeeplyATuple() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: ((((String, Int))))
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: ((((String, Int))))
            }

            extension BlackjackCard {
                init(suit: (String, Int)) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantClosure() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: () -> String
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: () -> String
            }

            extension BlackjackCard {
                init(suit: @escaping () -> String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantClosureToOptional() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: () -> String?
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: () -> String?
            }

            extension BlackjackCard {
                init(suit: @escaping () -> String?) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantClosureInParens() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: (() -> String)
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: (() -> String)
            }

            extension BlackjackCard {
                init(suit: @escaping () -> String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitSingleConstantClosureOptionalNoEscapingAttribute() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                let suit: (() -> String)?
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                let suit: (() -> String)?
            }

            extension BlackjackCard {
                init(suit: (() -> String)?) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitComputedVariableDoesntGenerateParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    "diamonds"
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    "diamonds"
                }
            }

            extension BlackjackCard {
                init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitVariableWithDidSetGeneratesParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    didSet {
                    }
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    didSet {
                    }
                }
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitVariableWithWillSetGeneratesParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    willSet {
                    }
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    willSet {
                    }
                }
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitVariableWithWillSetAndDidSetGeneratesParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    willSet {
                    }
                    didSet {
                    }
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    willSet {
                    }
                    didSet {
                    }
                }
            }

            extension BlackjackCard {
                init(suit: String) {
                    self.suit = suit
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitComputedVariableWithGetterAndSetterDoesntGenerateParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    get { "diamonds" }
                    set { }
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    get { "diamonds" }
                    set { }
                }
            }

            extension BlackjackCard {
                init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitComputedVariableWithGetterDoesntGenerateParameter() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var suit: String {
                    get { "diamonds" }
                }
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var suit: String {
                    get { "diamonds" }
                }
            }

            extension BlackjackCard {
                init() {
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferString() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var string = "String"
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var string = "String"
            }

            extension BlackjackCard {
                init(string : String = "String") {
                    self.string = string
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferInt() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var int = 3
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var int = 3
            }

            extension BlackjackCard {
                init(int : Int = 3) {
                    self.int = int
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferDouble() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var double = 3.3
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var double = 3.3
            }

            extension BlackjackCard {
                init(double : Double = 3.3) {
                    self.double = double
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferBool() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var bool = false
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var bool = false
            }

            extension BlackjackCard {
                init(bool : Bool = false) {
                    self.bool = bool
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferFunctionCallAsInit1() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var date = Date()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var date = Date()
            }

            extension BlackjackCard {
                init(date : Date = Date()) {
                    self.date = date
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferFunctionCallAsInit2() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var array = [Int]()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var array = [Int]()
            }

            extension BlackjackCard {
                init(array : [Int] = [Int] ()) {
                    self.array = array
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferFunctionCallAsInit3() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var array = Array<Int>()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var array = Array<Int>()
            }

            extension BlackjackCard {
                init(array : Array<Int> = Array<Int>()) {
                    self.array = array
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferFunctionCallAsInit4() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var dict = [Int: String]()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var dict = [Int: String]()
            }

            extension BlackjackCard {
                init(dict : [Int: String] = [Int: String] ()) {
                    self.dict = dict
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferFunctionCallAsInit5() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var dict = Dictionary<Int, String>()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var dict = Dictionary<Int, String>()
            }

            extension BlackjackCard {
                init(dict : Dictionary<Int, String> = Dictionary<Int, String>()) {
                    self.dict = dict
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferInitCall() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var date = Date.init()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var date = Date.init()
            }

            extension BlackjackCard {
                init(date : Date = Date.init()) {
                    self.date = date
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    // Skipped, this is not currently possible to infer, we don't have access to the real type
    // before type-checking, and the macro runs on syntax only.
    func __testMemberwiseInitInferFunctionCall() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var date = Calendar.current.date(from: .init())
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var date = Calendar.current.date(from: .init())
            }

            extension BlackjackCard {
                init(date : Date? = Calendar.current.date(from: .init())) {
                    self.date = date
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferEnum() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var someEnum = MyEnum.something
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var someEnum = MyEnum.something
            }

            extension BlackjackCard {
                init(someEnum : MyEnum = MyEnum.something) {
                    self.someEnum = someEnum
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferOptionalBoolQuestionMark() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var optionalBool = Bool?.none
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var optionalBool = Bool?.none
            }

            extension BlackjackCard {
                init(optionalBool : Bool? = Bool?.none) {
                    self.optionalBool = optionalBool
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferOptionalBoolGenerics() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var optionalBool = Optional<Bool>.none
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var optionalBool = Optional<Bool>.none
            }

            extension BlackjackCard {
                init(optionalBool : Optional<Bool> = Optional<Bool>.none) {
                    self.optionalBool = optionalBool
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    // Skipped, this is not currently possible to infer, we don't have access to the real type
    // before type-checking, and the macro runs on syntax only.
    func __testMemberwiseInitInferOptionalBoolInferringWrapperToo() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var optionalBool = Optional(true)
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var optionalBool = Optional(true)
            }

            extension BlackjackCard {
                init(optionalBool : Bool? = Optional(true)) {
                    self.optionalBool = optionalBool
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferVoid1() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var void = ()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var void = ()
            }

            extension BlackjackCard {
                init(void : () = ()) {
                    self.void = void
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferVoid2() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var void: ()
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var void: ()
            }

            extension BlackjackCard {
                init(void: ()) {
                    self.void = void
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferVoid3() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var void: Void
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var void: Void
            }

            extension BlackjackCard {
                init(void: Void) {
                    self.void = void
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferElementsInATuple() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var tuple = ("", int: 5)
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var tuple = ("", int: 5)
            }

            extension BlackjackCard {
                init(tuple : (String, int: Int) = ("", int: 5)) {
                    self.tuple = tuple
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

enum MyEnum {
    case something
}
