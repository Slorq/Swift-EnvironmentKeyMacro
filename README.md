# Swift-EnvironmentKeyMacro
Swift macro to easily create environment keys


## How to use

### EnvironmentKey

Add the `@EnvironmentKey` macro to properties declared within an `EnvironmentValues` extension:

```swift
extension EnvironmentValues {
    @EnvironmentKey
    var testProperty: String = "defaultValue"
}
```

it will be expaneded to:

```swift
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
```

### EnvironmentKeys

Add the `@EnvironmentKeys` macro to an `EnvironmentValues` extension to automatically add the `@EnvironmentKey` to all the properties declared in the extension:

```swift
@EnvironmentKeys
extension EnvironmentValues {
    var string = "defaultValue"
    var optional: Bool?
}
```

it will be expanded to:

```swift
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
```