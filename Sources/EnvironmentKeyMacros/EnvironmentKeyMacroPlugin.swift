//
//  EnvironmentKeyMacroPlugin.swift
//
//
//  Created by Alejandro Maya on 31/05/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct EnvironmentKeyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnvironmentKeysMacro.self,
        EnvironmentKeyMacro.self,
    ]
}

