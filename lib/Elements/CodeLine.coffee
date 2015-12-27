# CHANGELOG
# Written by Josh Grooms on 20151222



exports = class CodeLine

    _Tokens:         [ ]
    LineNumber:     0
    Type:           ""



    constructor: ->
        @_Tokens = [ ]


    Add: (token) ->
