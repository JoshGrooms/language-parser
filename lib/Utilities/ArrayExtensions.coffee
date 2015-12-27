# CHANGELOG
# Written by Josh Grooms on 20151222

{ type } = require('./ObjectFunctions')



# MERGE - Performs an in-place concatenation of an array and any other object.
#
#   This function concatenates an array and an object of any type and composition, appending the value(s) within the second
#   input to the end of the first. It does this without creating a third array to store the results, which is what the native
#   'concat' array method otherwise does.
#
#   SYNTAX:
#       x.Merge(y)
#       x.Merge(y...)
#
#   INPUTS:
#       x:      Array
#               An array object that will be modified in-place (hence no return value) to accommodate whatever value is found
#               in the second argument 'y'. The contents of 'y' are appended to the end of 'x'.
#
#       y:      Anything
#               One or more entities of any type whose value(s) will be appended to the end of 'x'. This argument may be a
#               single entity or a comma-separated list of entities. If any of the inputted entities are themselves arrays,
#               then their contents will be extracted and individually concatenated with 'x' (as opposed to appending the
#               entire array to the end of 'x' as a single element or nested array). Otherwise, the entity is appended as-is.
exports.Merge = Array::Merge = (y...) ->
    for element in y
        if type(element) is 'array'
            @push.apply(element)
        else @push(element)

    return this
    #
    # if type(y) is 'array' then return Array::push.apply(this, y)
    # else return
