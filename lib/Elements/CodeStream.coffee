# CHANGELOG
# Written by Josh Grooms on 20151221

require('../Utilities/ArrayExtensions')
require('../Utilities/StringExtensions')
{ clone, type } = require('../Utilities/ObjectFunctions')



# TOKEN - A data structure containing a single indivisible element of a programming language.
exports.Token = class Token
    _Buffer:        [ ]
    Type:           ""

    constructor: (char = null, type = "") ->
        @_Buffer    = if char? then [ char ] else [ ]
        @Type      = type

    # ADD - Appends one or more characters to the end of the current token value.
    Add: (char) ->
        @_Buffer.Merge(char)
        return undefined


    # ISSELECTOR - Determines whether this token's type matches the inputted selector.
    IsSelector: (selector) ->
        return false unless type(selector) is 'string'
        selectors = selector.split('.')
        for s in selectors
            return false unless @Type.Contains(s)
        return true


    # ISCOMMENT - Determines whether this token represents a comment within the original source code.
    IsComment:      -> return @IsSelector("Comment")
    # ISEMPTY - Determines whether this token contains any meaningful source code.
    IsEmpty:        -> return @IsSpecial() || @IsSelector("WhiteSpace") || @IsSelector("Comment")
    # ISSPECIAL - Determines whether this token represents a special symbol introduced by the language parser.
    IsSpecial:      -> return (@_Buffer[0] in ["@Indent", "@Outdent"])
    # ISWHITESPACE - Determines whether this token represents empty space within the original source code.
    IsWhiteSpace:   -> return @IsSelector("WhiteSpace")


    # LENGTH - Gets the number of individual characters present in this token.
    Length:         -> return @_Buffer.length
    # REMOVE - Deletes one or more characters from the end of the token.
    Remove: (n = 1) ->
        @_Buffer[@Length() - n .. @Length() - 1] = [ ]
        return undefined

    Value:          -> return @_Buffer.join('')



# CODESTREAM - A universal tokenizer that decomposes a buffered stream of source code text.
exports.CodeStream = class CodeStream
    # _BLOCKSTACK - A stack whose elements represent unclosed blocks.
    _BlockStack:    [ ]
    # _CURRENTTOKEN - The source code token that is currently being constructed and identified.
    _CurrentToken:  null
    # _LEXICON - The language specification that is currently being used to tokenize text.
    _Lexicon:       null
    # _INDEX - The index of the next unprocessed character in the source text string.
    _Index:         0
    # _TEXT - The source code text string that is currently being tokenized.
    _Text:          ""



    ## CONSTRUCTOR ##
    # CODESTREAM - Constructs a new tokenizer object to interpret a string of source code text.
    constructor: (@_Text, @_Lexicon) ->
        @_BlockStack    = [ ]
        @_CurrentToken  = null
        @_Index         = 0
        @_Text          = @_Text.replace(/\r/gm, '')



    ## PRIVATE UTILITIES ##
    # _CURRENTBLOCK - Gets the current block for which code is being processed from the block stack.
    _CurrentBlock: ->
        return null unless @_BlockStack.length
        return @_BlockStack[@_BlockStack.length - 1]
    # _ISCLOSEFORCURRENTBLOCK - Determines if a symbol marks the close of a previously opened block.
    _IsCloseForCurrentBlock: (symbol) ->
        return false unless @_CurrentBlock()?._Close?
        return true if symbol is @_CurrentBlock()._Close
        return false
    # _ISNEXTSYMBOL - Determines whether the next symbol in the text stream would match the inputted symbol.
    _IsNextSymbol: (symbol) =>
        for a in [ 0 .. symbol.length - 1 ]
            return false if @_PeekCharacter(a) isnt symbol[a]
        return true
    # _PEEKCHARACTER - Gets the next character in the stream without consuming it.
    #
    #   SYNTAX:
    #       c = @_PeekCharacter(n)
    #
    #   OUTPUT:
    #       c:      CHARACTER
    #               The next or nth next character in the stored text stream.
    #
    #   INPUT:
    #       n:      INTEGER
    #               The offset at which to retrieve a character from the text stream. This offset is specified relative to
    #               the current stream position, so a value of '0' retrieves the very next unread character, while a value of
    #               '1' retrieves the character after that.
    #               DEFAULT: 0
    _PeekCharacter: (n = 0) -> return @_Text[@_Index + n] unless @EOS();
    # _READCHARACTER - Gets the next character in the stream, consuming it in the process.
    _ReadCharacter:         -> return @_Text[@_Index++] unless @EOS();
    # _SKIP - Skip over a specified number of characters in the text stream.
    #
    #   SYNTAX:
    #       @_Skip(n)
    #
    #   INPUT:
    #       n:      integer
    #               The number of characters to be skipped. Inputting a value of '0' for this argument skips over zero
    #               characters and thus has no effect.
    #               DEFAULT: 1
    _Skip: (n = 1) ->
        @_Index += n unless @EOS();
        return undefined



    ## PRIVATE TOKENIZING METHODS ##
    # _PROCESSCOMMENT - Creates an inline comment token.
    _ProcessComment: ->
        @_CurrentToken.Type = "Comment"
        @_ProcessUntil('\n')

    # _PROCESSCONTENT - Continues processing the content of a block.
    _ProcessContent: ->
        @_CurrentToken.Type = @_CurrentBlock()._Content
        @_ProcessUntil(@_CurrentBlock()._Close)

    # _PROCESSENCLOSURE - Pushes and pops the current block scope that's being processed.
    _ProcessEnclosure: ->
        if @_IsCloseForCurrentBlock(@_CurrentToken.Value())
            block = @_BlockStack.pop()
            @_CurrentToken.Type = @_CurrentToken.Type.replace("Open", "Close")
        else
            @_CurrentToken.Type = @_CurrentToken.Type.replace("Close", "Open")
            block = @_Lexicon.ResolveBlock(@_CurrentToken)
            @_BlockStack.push(block) if block?

        return undefined

    # _PROCESSNUMBER - Creates a numeric literal token out of adjacent number characters.
    _ProcessNumber: ->
        @_CurrentToken.Type = "Literal.Number"
        @_ProcessUntil( (x) => !@_Lexicon.IsNumber(x) )

    # _PROCESSYMBOLIC - Creates a symbolic token out of adjacent and compatible characters.
    #
    #   Symbolics are defined here as any language-specific construct consisting of non-word characters. This encompasses
    #   enclosure characters (e.g. '{ }' or '[ ]' or '" "') as well as operator characters (e.g. '+' or '-' or '+=').
    _ProcessSymbolic: ->
        # Append characters so we can match the maximum-length symbols first
        @_CurrentToken.Add(@_PeekCharacter(a)) for a in [ 0 .. @_Lexicon.MaxCharsPerSymbolic - 1 ]

        # Repeatedly trim the end character off of the token until a symbol is resolved
        ctTokenValue = @_CurrentToken.Value()
        while ( @_CurrentToken.Length() > 1 )
            @_CurrentToken.Type = @_Lexicon.ResolveSymbolic(ctTokenValue)
            break if @_CurrentToken.Type?

            @_CurrentToken.Remove()
            ctTokenValue = @_CurrentToken.Value()

        # If a symbol has not yet been resolved, make one last attempt with the single-character token
        @_CurrentToken.Type ?= @_Lexicon.ResolveSymbolic(ctTokenValue)
        @_Skip(ctTokenValue.length)

        switch
            when !@_CurrentToken.Type?                      then @_CurrentToken.Type = "Unknown"
            when @_Lexicon.IsEnclosure(ctTokenValue)        then @_ProcessEnclosure()
            when @_CurrentToken.IsComment()                 then @_ProcessComment()

        return undefined

    # _PROCESSUNTIL - Repeatedly adds characters to the current token until a specific stop condition is met.
    #
    #   OUTPUT:
    #       b:      BOOLEAN
    #               A Boolean indicating whether the stop condition was met while processing the text stream. If that
    #               condition was encountered, then this method will return 'true'. If, however, processing was interrupted
    #               before the stop condition is found (i.e. because of new line characters or because the end of the stream
    #               was reached), then this method returns 'false'.
    #
    #   INPUT:
    #       stop:   STRING or FUNCTION
    #               A specific stop condition to watch for while processing the text stream. This argument can be either a
    #               string containing the character(s) that will stop processing or a predicate function that accepts a
    #               string input and returns 'true' when processing should terminate or 'false' otherwise.
    _ProcessUntil: (stop = "\n") ->
        switch type(stop)
            when 'string'
                while ( !@_IsNextSymbol("\n") && !@_IsNextSymbol(stop) && !@EOS() )
                    @_CurrentToken.Add(@_ReadCharacter())

            when 'function'
                while ( !@_IsNextSymbol("\n") && !stop(@_PeekCharacter()) && !@EOS() )
                    @_CurrentToken.Add(@_ReadCharacter())

        isNewLineNext = @_IsNextSymbol("\n")
        return false if @EOS() || (isNewLineNext && stop isnt "\n")
        return true

    # _PROCESSWHITESPACE - Creates a single token out of adjacent whitespace characters.
    #
    #   This method processes blank, empty space within text.
    _ProcessWhiteSpace: ->
        @_CurrentToken.Type = @_Lexicon.ResolveWhiteSpace(@_PeekCharacter())
        if @_CurrentToken.IsSelector("NewLine")
            @_CurrentToken.Add(@_ReadCharacter())
        else
            @_ProcessUntil( (x) => !@_Lexicon.IsWhiteSpace(x) )

    # _PROCESSWORD - Creates a single token that consists of some kind of word.
    #
    #   This method processes word elements such as variable names, keywords, or symbolic literals (e.g. 'null', 'true',
    #   'false', etc.).
    _ProcessWord: ->
        @_ProcessUntil( (x) => !@_Lexicon.IsWordCharacter(x) )
        @_CurrentToken.Type = @_Lexicon.ResolveWord(@_CurrentToken.Value())

    # _RESUMEPROCESSING - Determines whether processing of a block's contents should be resumed.
    #
    #   This test is useful when tokenizing code whose logic spans multiple lines in the source file.
    _ResumeProcessing: ->
        return false unless @_CurrentBlock()?._Content?
        return false if @_IsNextSymbol(@_CurrentBlock()._Close)
        return true



    ## PUBLIC METHODS ##

    # EOS - Determines whether or not the end of the text stream has been reached.
    #
    #   SYNTAX:
    #       b = @EOS()
    #
    #   OUTPUT:
    #       b:      BOOLEAN
    #               A Boolean 'true' if the end of the stream (EOS) has been reached, or 'false' otherwise.
    EOS: -> return ( @_Text.length == 0 || @_Index >= @_Text.length )

    # OPENBLOCKS - Generates a copy of the currently open block list for this text stream.
    #
    #   SYNTAX:
    #       blocks = @OpenBlocks()
    #
    #   OUTPUT:
    #       blocks:     ARRAY
    #                   A deep copy of the currently active block stack. This stack is used internally to monitor the opening
    #                   and closing of blocks while processing text.
    OpenBlocks: -> return clone(@_BlockStack)

    # READTOKEN - Gets the next available token in the code stream, consuming its characters in the process.
    #
    #   SYNTAX:
    #       token = @ReadToken()
    #
    #   OUTPUTS:
    #       token:      TOKEN
    #
    ReadToken: ->

        return null if @EOS()

        char = @_PeekCharacter()
        @_CurrentToken = new Token()

        switch

            when @_ResumeProcessing()                 then @_ProcessContent()
            when @_Lexicon.IsWhiteSpace(char)         then @_ProcessWhiteSpace()
            when @_Lexicon.IsOpenWordCharacter(char)  then @_ProcessWord()
            when @_Lexicon.IsNumber(char)             then @_ProcessNumber()

            else @_ProcessSymbolic()

        return @_CurrentToken



    Reset: (@_Text, @_BlockStack) ->
        @_BlockStack    = [ ] unless @_BlockStack?
        @_CurrentToken  = null
        @_Index         = 0
        @_Text          = @_Text.replace(/\r/gm, '')
