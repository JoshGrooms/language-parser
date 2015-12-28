# CHANGELOG
# Written by Josh Grooms on 20151222

require('../Utilities/ArrayExtensions')



module.exports = class CodeLine


    _IsClosed:      false

    Tokens:         [ ]
    LineNumber:     0
    Type:           ""



    constructor: (@LineNumber, token = null)->
        @_IsClosed  = false
        @Tokens     = [ ]
        @Type       = ""

        @Add(token) if token?



    Add: (token) ->
        return false if @_IsClosed
        @Tokens.Merge(token)
        @_IsClosed = true if token.Type is "NewLine"
        return true
