# CHANGELOG
# Written by Josh Grooms on 20151222



exports.Access = Access =
    # Freely accessible from anywhere
    Global:     0
    # Accessible only within an entity
    Internal:   1
    # Accessible only within the same scope
    Local:      2
    # Accessible only within an entity and its descendents
    Inheritted: 3
    # Accessible only to specific entities
    Restricted: 4

exports.Arities = Arities =
    Unary:      1
    Binary:     2
    Ternary:    3
    Quaternary: 4
    Variable:   5
    Variadic:   6

exports.Associativities = Associativities =
    # BOTH - Operations could be grouped arbitrarily from either the left or right.
    Both:       0
    # LEFT - Operations should be grouped from left to right.
    Left:       1
    # NONE - Operations cannot be chained.
    None:       2
    # RIGHT - Operations should be grouped from right to left.
    Right:      3

exports.Scopes = Scopes =
    Class:      0
    Function:   1
    Global:     2
    Method:     3
    Namespace:  4

exports.TypeSystems = TypeSystems =
    Dynamic:    0
    Static:     1
    Weak:       2

exports.Visibilities = Visibilities =
    Both:       0
    External:   1
    Internal:   2
