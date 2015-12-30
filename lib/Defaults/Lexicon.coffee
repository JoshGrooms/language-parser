# CHANGELOG
# Written by Josh Grooms on 20151221

require('../Utilities/StringExtensions')

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

    Blocks:                             require('./Blocks')
    Literals:                           require('./Literals')
    Symbols:                            require('./Symbols')
    Words:                              require('./Words')


    DefaultTag:                         "Variable"
    FileExtension:                      [ ".*" ]


    AreDeclarationsDefinitions:         true

    CanEntitiesSpanFiles:               false

    IsEvaluationLazy:                   false
    IsFunctional:                       true
    IsMultiLineSupported:               true
    IsObjectOriented:                   true
    IsOperatorOverloadingSupported:     true
    IsPythonic:                         false
    IsStaticallyTyped:                  true
    IsVariadicInputSupported:           true
    IsVariadicOutputSupported:          false

    MaxCharsPerSymbolic:                3


    Get: (address) ->
        fields = address.split('.')
        obj = this
        obj = obj[field] for field in fields
        return obj

    # ISENCLOSURE - Determines whether a character is an open enclosure symbol.
    IsEnclosure: (char)             -> return contains(@Symbols.Enclosure, char)
    # ISEQUIVALENT - Determines whether a symbol and the symbol pointed to by a tag are equivalent.
    IsEquivalent: (symbol, tag)     -> return @Get(tag) is symbol
    # ISKEYWORD - Determines whether a word is a language keyword.
    IsKeyword: (word)               -> return contains(@Words.Keyword, word)
    # ISNUMBER - Determines whether a character is a number.
    IsNumber: (char)                -> return contains(@Words.Word.Number, char)
    IsOpenEnclosure: (char)         -> return contains(@Symbols.Enclosure.Open, char)
    IsOpenWordCharacter: (char)     -> return contains(@Words.Word.Open, char)
    IsOperator: (char)              -> return contains(@Symbols.Operator, char)
    IsSymbolic: (char)              -> return contains(@Symbols, char)
    IsWhiteSpace: (char)            -> return contains(@Words.WhiteSpace, char)
    IsWordCharacter: (char)         -> return contains(@Words.Word, char)

    # IsNumeric:              (char) ->
    #     return true if @IsNumber(char)
    #     return true if

    IsEnclosureMatched:     (open, close) ->
        openTag = find(@Symbols.Enclosure.Open, open)
        return false if !openTag?
        closeTag = find(@Symbols.Enclosure.Close, close)
        return false if !closeTag?
        return true if openTag is closeTag
        return false




    # Resolve: (entity) -> return find(@Symbols, entity)

    # ResolveCharacter: (char) -> return find(@Symbols, char)

    ResolveEnclosure: (char) ->
        enc = find(@Symbols.Enclosure, char)
        return null if !enc?
        return "Symbols.Enclosure." + enc

    ResolveOperator: (char) ->
        op = find(@Symbols.Operator, char)
        return null if !op?
        return "Symbols.Operator." + op

    ResolveSymbolic: (char) ->
        sym = @ResolveEnclosure(char)
        sym ?= @ResolveOperator(char)
        return sym

    ResolveWord: (word) ->
        word = find(@Words, word)
        word ?= "Variable"
        return "Words." + word

    ResolveBlock: (enclosure, initial = null) ->
        initial ?= @Blocks
        block = null

        for k, v of initial when v?
            if type(v) is 'object'
                return block if block = @ResolveBlock(enclosure, v)

            if v.Open is enclosure
                block = v
                break

        return null if !block?

        return block







    # Signature:
    #     Close:          null
    #     Contents:       null
    #     Open:           null
    #     Prefix:         null
    #     Suffix:         null




    ## PREDEFINED LANGUAGE ELEMENTS ##

    # Rule:
    #     Contains:
    #     CannotContain:
    #     CannotFollow:
    #     CannotPrecede:
    #     Follows:
    #     Name:
    #     Precedes:
