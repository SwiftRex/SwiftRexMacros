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
            struct BlackjackCard {
            }
            """,
            expandedSource: """
            struct BlackjackCard {

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
            struct BlackjackCard {
            }
            """,
            expandedSource: """
            struct BlackjackCard {

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
            class BlackjackCard {
            }
            """,
            expandedSource: """
            class BlackjackCard {
            }
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

    func testMemberwiseInitInferElementsInANestedTuple() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct BlackjackCard {
                var tuple = ("", int: 5, innerNamed: (3.0, yes: true), (string: "", 2))
            }
            """,
            expandedSource:
            """
            struct BlackjackCard {
                var tuple = ("", int: 5, innerNamed: (3.0, yes: true), (string: "", 2))

                init(tuple : (String, int: Int, innerNamed: (Double, yes: Bool), (string: String, Int)) = ("", int: 5, innerNamed: (3.0, yes: true), (string: "", 2))) {
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

    func testMemberwiseInitGenerics() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card<T> {
                var generics: T
            }
            """,
            expandedSource:
            """
            struct Card<T> {
                var generics: T

                init(generics: T) {
                    self.generics = generics
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferDifferentTypes() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var string = "", int = 0
            }
            """,
            expandedSource:
            """
            struct Card {
                var string = "", int = 0

                init(string : String = "", int : Int = 0) {
                    self.string = string
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
}

/* TODO: Try to implement these type inferences. Meanwhile, please put the explicit type.
extension MemberwiseInitTests {
    func testMemberwiseInitInferMath() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var multiplicationDouble = 2.0 * 0
            }
            """,
            expandedSource:
            """
            struct Card {
                var multiplicationDouble = 2.0 * 0

                init(multiplicationDouble: Double = 2.0 * 0) {
                    self.multiplicationDouble = multiplicationDouble
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferLogic() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var bool = 4 >= 4
            }
            """,
            expandedSource:
            """
            struct Card {
                var bool = 4 >= 4

                init(bool: Bool = 4 >= 4) {
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

    func testMemberwiseInitInferRange() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var range = 0...10
            }
            """,
            expandedSource:
            """
            struct Card {
                var range = 0...10

                init(range: Range<Int> = 0...10) {
                    self.range = range
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferArrayLiteral() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var ints = [1, 2, 3]
            }
            """,
            expandedSource:
            """
            struct Card {
                var ints = [1, 2, 3]

                init(ints: [Int] = [1, 2, 3]) {
                    self.ints = ints
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferNestedArrayLiteral() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var ints = [[1, 2, 3]]
            }
            """,
            expandedSource:
            """
            struct Card {
                var ints = [[1, 2, 3]]

                init(ints: [[Int]] = [[1, 2, 3]]) {
                    self.ints = ints
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferArrayLiteralFloatingPoints() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var doubles = [1, 2.0, 3]
            }
            """,
            expandedSource:
            """
            struct Card {
                var doubles = [1, 2.0, 3]

                init(doubles: [Double] = [1, 2.0, 3]) {
                    self.doubles = doubles
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferDictionaryLiteral() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var kvs = ["a": 1, "b": 2, "c": 3]
            }
            """,
            expandedSource:
            """
            struct Card {
                var kvs = ["a": 1, "b": 2, "c": 3]

                init(kvs: [String: Int] = ["a": 1, "b": 2, "c": 3]) {
                    self.kvs = kvs
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferNestedDictionaryLiteral() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var kvs = ["a": ["a1": 1, "a2": 2], "b": ["b1": 1, "b2": 2], "c": ["c1": 1, "c2": 2]]
            }
            """,
            expandedSource:
            """
            struct Card {
                var kvs = ["a": ["a1": 1, "a2": 2], "b": ["b1": 1, "b2": 2], "c": ["c1": 1, "c2": 2]]

                init(kvs: [String: [String: Int]] = ["a": ["a1": 1, "a2": 2], "b": ["b1": 1, "b2": 2], "c": ["c1": 1, "c2": 2]]) {
                    self.kvs = kvs
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferDictionaryLiteralFloatingPoints() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var kvs = ["a": 1, "b": 2.0, "c": 3]
            }
            """,
            expandedSource:
            """
            struct Card {
                var kvs = ["a": 1, "b": 2.0, "c": 3]

                init(kvs: [String: Double] = ["a": 1, "b": 2.0, "c": 3]) {
                    self.kvs = kvs
                }
            }
            """,
            macros: testMacros
        )

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMemberwiseInitInferCast() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var double = 3 as Double
            }
            """,
            expandedSource:
            """
            struct Card {
                var double = 3 as Double

                init(double: Double = 3 as Double) {
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

    func testMemberwiseInitInferOptionalCast() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var double = 3 as? Double
            }
            """,
            expandedSource:
            """
            struct Card {
                var double = 3 as? Double

                init(double: Double? = 3 as? Double) {
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

    func testMemberwiseInitInferForceCast() throws {
#if canImport(SwiftRexMacroImplementation)
        assertMacroExpansion(
            """
            @MemberwiseInit
            struct Card {
                var double = 3 as! Double
            }
            """,
            expandedSource:
            """
            struct Card {
                var double = 3 as! Double

                init(double: Double = 3 as! Double) {
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
}
*/
