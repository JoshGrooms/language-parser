# CHANGELOG
# Written by Josh Grooms on 20151222

require('../Utilities/ArrayExtensions')
{ type } = require('../Utilities/ObjectFunctions')



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



    Add: (token) ->
        return false if @IsClosed
        @Tokens.Merge(token)
        @IsClosed = true if token.IsSelector("NewLine")
        return true



    ContainsTokenTypes: (selectors) ->
        return false unless selectors? && !IsEmpty()
        selectors = [ selectors ] if type(selectors) is 'string'

        idx = 0
        for token in @Tokens
            idx++ if token.IsSelector(selectors[idx])
            break if allSelectorsFound = idx == selectors.length

        return true if allSelectorsFound
        return false


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
            isSpace =
                token.IsSelector("@Indent")         ||
                token.IsSelector("@Outdent")        ||
                token.IsSelector("WhiteSpace")      ||
                token.IsSelector("Comment")
            return false unless isSpace
            # return false unless token.Type in [ "@Indent", "@Outdent", "NewLine", "WhiteSpace" ]
        return true

    ToString: ->
        line = ""
        line += token.Value() for token in @Tokens
        return line
