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
CodeSignature           = require('./Signature')
{ type }                = require('../Utilities/ObjectFunctions')
{ Lexicon, Symbols }    = require('../Defaults')



module.exports = class CodeBlock

    # _CurrentBlock:      null
    # _CurrentLine:       null
    # _Lexicon:           null
    # _Lines:             [ ]
    # _WorkingLine:       0
    #
    # IsClosed:           false


    _Close:     null
    _Content:   null
    _Open:      null
    _Prefix:    null
    _Suffix:    null
    _Tag:       null


    _IsCapturing:   false





    # # ACCESSIBILITY - How visible the block's internal contents are to the surrounding world.
    # Accessibility:      Access.Global
    # # BEGIN - The source code line on which this block begins.
    # Begin:              0
    # # CHILDREN - A list of code elements that are found within this block.
    # Children:           [ ]
    #
    # # Close:              Symbols.Enclosure.Close.Block
    #
    # # Content:            ""
    # # END - The source code line on which this block ends.
    # End:                0
    #
    # Evaluation:         "Eager"
    #
    # # Inheritance:        null
    # # NAME - The name of a block of code.
    # Name:               ""
    #
    # # Open:               Symbols.Enclosure.Open.Block
    # # PARENT - The parent block that contains this block.
    # Parent:             0
    #
    # Tag:                ""
    # # VISIBILITY - How visible the block itself is to the surrounding world.
    # Visibility:         Access.Global



    constructor: (block) ->

        @_Close   = null
        @_Content = null
        @_Open    = null
        @_Prefix  = null
        @_Suffix  = null
        @_Tag     = null

        { @_Close, @_Content, @_Open, @_Prefix, @_Suffix, @_Tag } = block

        if @_Prefix? then @_Prefix = new CodeSignature(@_Prefix)
        if @_Suffix? then @_Suffix = new CodeSignature(@_Suffix)

        if @_Content?
            switch type(@_Content)
                when 'object' then @_ProcessContent(@_Content)
                when 'string'
                    @_Content = new CodeSignature(@_Content)
                    @_IsCapturing = true



    _ProcessContent: (content) ->
        for k, v of content
            switch type(v)
                when 'object' then content[k] = new CodeBlock(content[k])
                when 'string' then content[k] = new CodeSignature(content[k])


    MatchPrefix: (line) ->
        return null unless @_Prefix?
        return @_Prefix.Match(line)

    MatchSuffix: (line) ->
        return null unless @_Suffix?
        return @_Suffix.Match(line)

    # MatchContent: (line) ->
    #     return null unless @_Content?
    #     switch
    #         # when @_Content instanceof CodeBlock
    #
    #         when @_Content instanceof CodeSignature
    #             return @_Content.Match(line)




    

    HasContent: -> return @_Content?



    Add: (token) ->
        return false if @IsClosed

        # if @_CurrentBlock?
        #
        #     @_CurrentBlock.Add(token)
        #     if @_CurrentBlock.





    # Add: (token) ->
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
