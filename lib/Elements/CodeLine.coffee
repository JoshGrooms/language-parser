# CHANGELOG
# Written by Josh Grooms on 20151222

require('../Utilities/ArrayExtensions')



module.exports = class CodeLine


    Tokens:        [ ]
    LineNumber:     0
    Type:           ""



    constructor: (@LineNumber)->
        @Tokens     = [ ]
        @Type       = ""



    Add: (token) ->
        @Tokens.Merge(token)
        return undefined
