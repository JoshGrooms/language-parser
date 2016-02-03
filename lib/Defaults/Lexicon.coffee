# CHANGELOG
# Written by Josh Grooms on 20151221

require('../Utilities/StringExtensions')

{ type, clone, contains, find }    = require('../Utilities/ObjectFunctions')

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
    Types:                              require('./Types')
    Words:                              require('./Words')


    # DEFAULTTAG - The default HTML tag that will be applied to any unrecognized token.
    DefaultTag:                         "Variable"
    # FILEEXTENSION - The type of file for which this lexicon should be referenced.
    FileExtension:                      [ ".*" ]


    AreDeclarationsDefinitions:         true

    CanEntitiesSpanFiles:               false

    TagEscapedCharacters:               false

    IsEvaluationLazy:                   false
    IsFunctional:                       true
    IsLineTerminatorRequired:           true
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
    # ISOPENENCLOSURE - Determines whether a character is the opening part of an enclosure pair.
    IsOpenEnclosure: (char)         -> return contains(@Symbols.Enclosure.Open, char)
    # ISOPENWORDCHARACTER - Determines whether a character could be the start of a word token.
    IsOpenWordCharacter: (char)     -> return contains(@Words.Word.Open, char)
    # ISOPERATOR - Determines whether a character is an operator symbol.
    IsOperator: (char)              -> return contains(@Symbols.Operator, char)

    IsSymbolic: (char)              -> return contains(@Symbols, char)
    # ISWHITESPACE - Determines whether a character represents an inline white space.
    IsWhiteSpace: (char)            -> return contains(@Words.WhiteSpace, char)
    # ISWORDCHARACTER - Determines whether a character could be a part of a word token.
    IsWordCharacter: (char)         -> return contains(@Words.Word, char)

    # IsNumeric:              (char) ->
    #     return true if @IsNumber(char)
    #     return true if

    IsEnclosureMatched: (open, close) ->
        return false unless openTag = find(@Symbols.Enclosure.Open, open)
        return false unless closeTag = find(@Symbols.Enclosure.Close, close)
        return true if openTag is closeTag
        return false

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

    ResolveWhiteSpace: (char) ->
        return "Words.WhiteSpace." + find(@Words.WhiteSpace, char)

    ResolveWord: (word) ->
        word = find(@Words, word)
        word ?= @DefaultTag
        return "Words." + word

    ResolveBlock: (enclosure, initial = null) ->
        initial ?= @Blocks
        block = null

        for k, v of initial when v?
            if type(v) is 'object'
                return clone(block) if block = @ResolveBlock(enclosure, v)

            if v.Open is enclosure.Type
                block = v
                break

        return null unless block?

        newBlock = clone(block)

        newBlock.Open = @Get(newBlock.Open)
        newBlock.Close = @Get(newBlock.Close)

        if type(newBlock.Open) is 'array'
            idxSym = newBlock.Open.indexOf(enclosure.Value())
            if idxSym isnt -1
                newBlock.Open = newBlock.Open[idxSym]
                newBlock.Close = newBlock.Close[idxSym]

        return newBlock
