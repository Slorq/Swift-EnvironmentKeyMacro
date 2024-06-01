//
//  EnvironmentKeyMacro.swift
//
//
//  Created by Alejandro Maya on 31/05/24.
//

@attached(peer, names: arbitrary)
@attached(accessor, names: named(get), named(set))
public macro EnvironmentKey() = #externalMacro(module: "EnvironmentKeyMacros", type: "EnvironmentKeyMacro")

@attached(memberAttribute)
public macro EnvironmentKeys() = #externalMacro(module: "EnvironmentKeyMacros", type: "EnvironmentKeysMacro")
