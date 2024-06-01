//
//  main.swift
//
//
//  Created by Alejandro Maya on 31/05/24.
//

import EnvironmentKeyMacro
import SwiftUI

@EnvironmentKeys
extension EnvironmentValues {
    var test = "defaultValue"
    var optional: Bool?
}
