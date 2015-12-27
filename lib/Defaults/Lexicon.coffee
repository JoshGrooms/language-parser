# CHANGELOG
# Written by Josh Grooms on 20151221

require('../Utilities/StringExtensions')
Blocks                      = require('./Blocks')
Symbols                     = require('./Symbols')
Words                       = require('./Words')
{ type, contains, find }    = require('../Utilities/ObjectFunctions')

{
    Access,
    Arities,
    Associativities,
    Scopes,
    TypeSystems,
    Visibilities
} = require('./Enumerations')





module.exports =

    CanEntitiesSpanFiles:               false

    IsEvaluationLazy:                   false
    IsFunctional:                       true
    IsObjectOriented:                   true
    IsPythonic:                         false
    IsMultiLineSupported:               true
    IsStaticallyTyped:                  true
    IsVariadicInputSupported:           true
    IsVariadicOutputSupported:          false

    IsOperatorOverloadingSupported:     true


    MaxCharsPerSymbolic:                3



    Get: (address) ->
        fields = address.split('.')
        obj = Symbols
        obj = obj[field] for field in fields
        return obj


    IsEnclosure:            (char) -> return contains(Symbols.Enclosure, char)
    IsKeyword:              (word) -> return contains(Words.Keyword, word)
    IsNumber:               (char) -> return contains(Words.Word.Number, char)
    IsOpenEnclosure:        (char) -> return contains(Symbols.Enclosure.Open, char)
    IsOpenWordCharacter:    (char) -> return contains(Words.Word.Open, char)
    IsOperator:             (char) -> return contains(Symbols.Operator, char)
    IsSymbolic:             (char) -> return contains(Symbols, char)
    IsWhiteSpace:           (char) -> return contains(Words.WhiteSpace, char)
    IsWordCharacter:        (char) -> return contains(Words.Word, char)





    Resolve: (entity) -> return find(Symbols, entity)

    ResolveCharacter: (char) -> return find(Symbols, char)


    ResolveOperator: (char) ->
        type = find(Symbols.Operator, char)
        type ?= "Unknown"
        return type

    ResolveSymbolic: (char) ->
        type = find(Symbols.Enclosure, char)
        type ?= find(Symbols.Operator, char)
        if type?
            type = "Enclosure." + type

        return type

    ResolveWord: (word) ->
        type = find(Words, word)
        type ?= "Variable"
        return type



    Symbol:
        # NAME -
        Name:           "Symbol"
        Signature:      null
        Tag:            null


    Signature:
        Close:          null
        Contents:       null
        Open:           null
        Prefix:         null
        Suffix:         null


    ResolveEnclosure: (char) ->
        type = find(Blocks, char)
        return null if !type?

        if type.Contains(".Close")
            type = type.replace(".Close", "")

        fields = type.split('.')
        block = Blocks

        block = block[field] for field in fields

        return block


    # ResolveBlock: (symbol) ->
    #
    #     for block, v of Blocks
    #         if type(v) is 'object'











    ## PREDEFINED LANGUAGE ELEMENTS ##

    # Rule:
    #     Contains:
    #     CannotContain:
    #     CannotFollow:
    #     CannotPrecede:
    #     Follows:
    #     Name:
    #     Precedes:
