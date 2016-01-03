# CHANGELOG
# Written by Josh Grooms on 20151222

require('../Utilities/ArrayExtensions')



module.exports = class CodeLine


    BlockStack:     [ ]
    IsClosed:       false
    Tokens:         [ ]
    Type:           ""



    constructor: (token = null) ->

        @BlockStack     = [ ]
        @IsClosed       = false
        @Tokens         = [ ]
        @Type           = ""

        @Add(token) if token?



    Add: (token) ->
        return false if @IsClosed
        @Tokens.Merge(token)
        @IsClosed = true if token.Type is "NewLine"
        return true



    
    ToString: ->
        line = ""
        line += token.Value() for token in @Tokens
        return line
