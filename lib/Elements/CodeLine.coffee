# CHANGELOG
# Written by Josh Grooms on 20151222

require('../Utilities/ArrayExtensions')
{ type } = require('../Utilities/ObjectFunctions')



# CODELINE - A class that stores and maintains a single line of tokenized source code text.
module.exports = class CodeLine

    BlockStack:     [ ]
    IndentLevel:    0
    IsClosed:       false
    Tokens:         [ ]
    Type:           ""



    constructor: (@IndentLevel = 0, token = null) ->

        @BlockStack     = [ ]
        @IsClosed       = false
        @Tokens         = [ ]
        @Type           = ""

        @Add(token) if token?



    ## PUBLIC UTILITIES ##
    # ADD - Appends a new token to the code line.
    Add: (token) ->
        @Tokens.Merge(token)
        @IsClosed = true if token.IsSelector("Operator.LineTerminator")
        return true

    # COUNT - Returns the number of tokens present in this code line.
    Count: -> return @Tokens.length


    ContainsSelectors: (selectors) ->
        return false unless selectors? && !IsEmpty()
        selectors = [ selectors ] if type(selectors) is 'string'

        idx = 0
        for token in @Tokens
            idx++ if token.IsSelector(selectors[idx])
            break if allSelectorsFound = idx == selectors.length

        return true if allSelectorsFound
        return false

    # FINDSELECTOR - Determines the index of the first token whose type matches the inputted selector.
    FindSelector: (selector) ->
        for token, idx in @Tokens
            return idx if token.IsSelector(Selector)
        return -1

    # FINDSELECTORS - Determines the indices of
    FindSelectors: (selectors) ->
        idx = 0
        results = [ ]
        for a in [ 0 .. @Tokens.length ]
            if @Tokens[a].IsSelector(selectors[idx])
                results.push(a)
                idx++
            break if idx == selectors.length

        return results
    # GETMEANINGFULTOKEN - Finds a non-whitespace token relative to a starting position.
    GetMeaningfulToken: (start, offset) ->
        offset = 1 unless offset
        if offset < 0
            idxToken = start
            while offset && idxToken > 0
                offset++ unless @Tokens[--idxToken].IsEmpty()

        if offset > 0
            idxToken = start
            while offset && idxToken < @Count() - 1
                offset-- unless @Tokens[++idxToken].IsEmpty()

        return [ null, null ] if offset
        return [ idxToken, @Tokens[idxToken] ]

    # ISEMPTY - Determines whether this code line contains any meaningful tokens.
    #
    #   SYNTAX:
    #       b = @IsEmpty()
    #
    #   OUTPUT:
    #       b:      BOOLEAN
    #               A Boolean 'true' if this line is completely empty or contains only whitespace characters. Otherwise, if
    #               this line contains any tagged tokens, 'false' will be returned.
    IsEmpty: ->
        return true unless @Tokens.length
        for token in @Tokens
            return false if token.IsEmpty()
        return true

    # TOSTRING - Converts this line of tokens into a string containing the original source code
    ToString: ->
        line = ""
        line += token.Value() for token in @Tokens
        return line
