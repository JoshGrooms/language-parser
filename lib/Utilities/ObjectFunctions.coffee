# CHANGELOG
# Written by Josh Grooms on 20151221



# CLONE - Creates a deep copy of any object.
exports.clone = clone = (x) ->
    return x if !x? || typeof(x) isnt 'object'

    return new Date(x.getTime()) if x instanceof Date

    if x instanceof RegExp
        flags = ''
        flags += 'g' if x.global?
        flags += 'i' if x.ignoreCase?
        flags += 'm' if x.multiline?
        flags += 'y' if x.sticky?
        return new RegExp(x.source, flags)

    y = new x.constructor()
    y[k] = clone x[k] for k of x
    return y

# CONTAINS - Determines whether a particular value exists within a data object.
#
#   SYNTAX:
#       b = contains(x, value)
#
#   OUTPUT:
#       b:      BOOLEAN
#               A Boolean 'true' or 'false' that indicates whether the object 'x' contains a 'value'. If the argument 'value'
#               is located in any of the fields of 'x' (nested or otherwise), then this function will return 'true'.
#
#   INPUTS:
#       x:      OBJECT
#               The object within which to search for the argument 'value'. This may be a simple object or one with multiple
#               nested levels.
#
#       value:  ANYTHING
#               The value to search for within the object 'x'.
exports.contains = contains = (x, value) ->
    switch type(x)
        when 'array' then return true if value in x
        when 'object'
            for k, v of x
                return true if contains(v, value)
        when 'string' then return true if value is x

    return false

# FIND - Finds a particular value within a data object and returns its field address.
#
#   SYNTAX:
#       f = find(x, value)
#
#   OUTPUT:
#       f:      STRING or NULL
#               The field address of the first located 'value' within the object 'x'. For simple single-level objects, this
#               string will contain the name of the field that contains 'value'. For multi-level nested objects, this string
#               will consist of a sequential list of field names separated by a period (i.e. '.') that index all the way
#               through the data structure to the field that contains 'value'.
#
#               However, if 'value' cannot be found within any fields of 'x', then this argument will take a value of 'null'.
#
#   INPUTS:
#       x:      OBJECT
#               The object within which to search for the argument 'value'. This may be a simple object or one with multiple
#               nested levels.
#
#       value:  ANYTHING
#               The value to use when searching the object 'x'. If any of the fields of 'x' contain this value, then the
#               fully qualified address of that field will be returned.
exports.find = find = (x, value) ->
    switch type(x)
        when 'array'
            return x.indexOf(value)
        when 'object'
            for k, v of x when contains(v, value)
                if (type(v) is 'array' || type(v) is 'string')
                    return k
                else
                    return k + '.' + find(v, value)

        when 'string'
            if contains(x, value) then return '' else return null

# ISEMPTY - Determines whether an entity contains any values.
exports.isempty = isempty = (x) ->
    return true unless x?
    switch type(x)
        when 'array' || 'string'    then return x.length == 0
        when 'object'               then return Object.keys(x).length == 0
        when 'regexp'               then return x.source.length == 0
        else
            return false

# ISFIELD - Determines whether an object contains a specific field name anywhere within its hierarchy.
exports.isfield = isfield = (x, field) ->
    return false if type(x) isnt 'object'
    for k, v of x
        return true if k is field
    return false

# OVERLOAD - Overloads one object with the the keys and values of another object.
exports.overload = overload = (x, y) ->
    return x if type(x) != type(y) != 'object'

    for k, v of y # when x[k] isnt undefined
        if type(x[k]) == type(v) == 'object'
            overload(x[k], v)
        else
            x[k] = v

    return x

# TYPE - Determines the type of an object.
#
#   Any entity in JavaScript (and, by extension, CoffeeScript) belongs to one of the general types
#   listed within this function. This includes user-defined classes, which belong to the type 'object'.
#
#   This function was created because of flaws that exist in the native 'typeof' function. Specifically,
#   'typeof' fails to differentiate between objects, arrays, and null or undefined input values. For more
#   information and to see the original logic from which this function was derived, see the CoffeeScript
#   Cookbook:
#
#       https://coffeescript-cookbook.github.io/chapters/classes_and_objects/type-function
#
#   SYNTAX:
#       t = type(x)
#
#   OUTPUT:
#       t:      string
#               A string containing the identified type of the inputted object. This output will always
#               take one of the following values:
#
#                   'array'     - The input is an array of values.
#                   'boolean'   - The input is a Boolean.
#                   'date'      - The input is a date object.
#                   'function'  - The input is a function or class method handle.
#                   'number'    - The input is a number.
#                   'object'    - The input is a data structure or class.
#                   'regexp'    - The input is a regular expression
#                   'string'    - The input is a string
#                   'undefined' - The input is either 'null' or 'undefined'
#
#   INPUT:
#       x:      object
#               Any kind of valid CoffeeScript entity, including: user-defined classes, undefined and null
#               values, arrays, strings, regular expressions,
exports.type = type = (x) ->
    return "Undefined" if (x is null || x is undefined)
    converter =
    {
        '[object Array]':       'array'
        '[object Boolean]':     'boolean'
        '[object Date]':        'date'
        '[object Function]':    'function'
        '[object Number]':      'number'
        '[object Object]':      'object'
        '[object RegExp]':      'regexp'
        '[object String]':      'string'
    }

    return converter[Object.prototype.toString.call(x)]
