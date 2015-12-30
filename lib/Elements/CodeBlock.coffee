# CHANGELOG
# Written by Josh Grooms on 20151222

{
    Access,
    Arities,
    Associativities,
    Scopes,
    TypeSystems,
    Visibilities
} = require('../Defaults/Enumerations')


require('../Utilities/StringExtensions')

CodeLine                = require('./CodeLine')
{ Lexicon, Symbols } = require('../Defaults')



module.exports = class CodeBlock

    _CurrentBlock:      null
    _CurrentLine:       null
    _IsClosed:          false
    _WorkingLine:       0



    # ACCESSIBILITY - How visible the block's internal contents are to the surrounding world.
    Accessibility:      Access.Global
    # BEGIN - The source code line on which this block begins.
    Begin:              0
    # CHILDREN - A list of code elements that are found within this block.
    Children:           [ ]

    Close:              Symbols.Enclosure.Close.Block

    Content:            ""
    # END - The source code line on which this block ends.
    End:                0

    Evaluation:         "Eager"

    # Inheritance:        null
    # NAME - The name of a block of code.
    Name:               ""

    Open:               Symbols.Enclosure.Open.Block
    # PARENT - The parent block that contains this block.
    Parent:             0
    # SIGNATURE - The symbols that declare and define a block.
    Signature:
        Prefix:         null
        Suffix:         null

    Tag:                ""
    # VISIBILITY - How visible the block itself is to the surrounding world.
    Visibility:         Access.Global



    constructor: (block = null) ->
        @_CurrentBlock = null
        @_CurrentLine = new CodeLine()

        @Accessibility  = Access.Global
        @Begin          = 0
        @Children       = [ ]
        @Close          = Symbols.Enclosure.Close.Block
        @Name           = "block"
        @Open           = Symbols.Enclosure.Open.Block
        @Parent         = null
        @Signature      = { }
        @Visibility     = Access.Global

        if block?
            for k, v of block when this[k]?
                this[k] = v



    Add: (token) ->
        # return false if @_IsClosed
        #
        # if @_CurrentBlock?
        #     @_CurrentBlock.Add(token)
        #
        #
        #     return undefined
        #
        #
        # @_CurrentLine.Add(token)
        #
        # switch
        #     when token.Type is "NewLine"
        #         @Children.push(@_CurrentLine)
        #         @_CurrentLine = new CodeLine()
        #
        #     when token.Type.Contains("Enclosure.Open")
        #
        #
        # if token.Type is "NewLine"
