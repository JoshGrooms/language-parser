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

{ Lexicon, Symbols } = require('../Defaults')



module.exports = class CodeBlock

    # ACCESSIBILITY - How visible the block's internal contents are to the surrounding world.
    Accessibility:      Access.Global
    # BEGIN - The source code line on which this block begins.
    Begin:              0
    # CHILDREN - A list of code elements that are found within this block.
    Children:           [ ]
    # END - The source code line on which this block ends.
    End:                0

    Evaluation:         "Eager"

    # Inheritance:        null
    # NAME - The name of a block of code.
    Name:               ""
    # PARENT - The parent block that contains this block.
    Parent:             0
    # SIGNATURE - The symbols that declare and define a block.
    Signature:
        Close:          Symbols.Enclosure.Close.Block

    Tag:                ""
    # VISIBILITY - How visible the block itself is to the surrounding world.
    Visibility:         0



    constructor: (block = null) ->

        if block?
            for k, v of block when this[k]?

                this[k] = v
        else
            @Accessibility  = Accessibilities.Internal
            @Children       = [ ]
            @Close          = Symbols.Enclosure.Close.Block
            @Name           = "block"
            @Open           = Symbols.Enclosure.Open.Block
            @Parent         = null
            @Visibility     = Accessibilities.Local
