import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnvironmentKeyMacros)
import EnvironmentKeyMacros

let testMacros: [String: Macro.Type] = [
    "EnvironmentKey": EnvironmentKeyMacro.self,
    "EnvironmentKeys": EnvironmentKeysMacro.self,
]
#endif

final class EnvironmentKeyMacroTests: XCTestCase {
    func testEnvironmentKeyMacroWithString() throws {
        #if canImport(EnvironmentKeyMacros)
        assertMacroExpansion(
            """
            @EnvironmentKey
            var string = "defaultValue"
            """,
            expandedSource: """
            var string = "defaultValue" {
                get {
                    self [EnvironmentKeyString.self]
                }
                set {
                    self [EnvironmentKeyString.self] = newValue
                }
            }

            private struct EnvironmentKeyString: EnvironmentKey {
                static let defaultValue = "defaultValue"
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testEnvironmentKeyMacroWithOptional() throws {
        #if canImport(EnvironmentKeyMacros)
        assertMacroExpansion(
            #"""
            @EnvironmentKey
            var optional: Bool?
            """#,
            expandedSource: #"""
            var optional: Bool? {
                get {
                    self [EnvironmentKeyOptional.self]
                }
                set {
                    self [EnvironmentKeyOptional.self] = newValue
                }
            }

            private struct EnvironmentKeyOptional: EnvironmentKey {
                static let defaultValue: Bool? = nil
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testEnvironmentKeysMacro() throws {
        #if canImport(EnvironmentKeyMacros)
        assertMacroExpansion(
            #"""
            @EnvironmentKeys
            extension EnvironmentValues {
                var string = "defaultValue"
                var optional: Bool?
            }
            """#,
            expandedSource: #"""
            extension EnvironmentValues {
                var string = "defaultValue" {
                    get {
                        self [EnvironmentKeyString.self]
                    }
                    set {
                        self [EnvironmentKeyString.self] = newValue
                    }
                }

                private struct EnvironmentKeyString: EnvironmentKey {
                    static let defaultValue = "defaultValue"
                }
                var optional: Bool? {
                    get {
                        self [EnvironmentKeyOptional.self]
                    }
                    set {
                        self [EnvironmentKeyOptional.self] = newValue
                    }
                }

                private struct EnvironmentKeyOptional: EnvironmentKey {
                    static let defaultValue: Bool? = nil
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
