# CHANGELOG
# Written by Josh Grooms on 20160107


require('../Utilities/StringExtensions')
{ type } = require('../Utilities/ObjectFunctions')




class PatternMatch
    IsComplete:     false
    IsMatched:      false
    Tokens:         { }

    constructor: (@IsComplete = false, @IsMatched = false, @Tokens = { }) ->



module.exports = class CodeSignature

    _Elements:      [ ]
    _WorkingIndex:  0
    _WorkingMatch:  { }


    # _ISCOMPLETE - Determines whether the working match includes all available pattern elements.
    _IsComplete: -> return @_WorkingIndex == @_Elements.length



    constructor: (signature) ->
        @_Elements      = [ ]

        @Reset()

        if type(signature) is 'array'
            @_ProcessSignatureArray(signature)
        else
            @_ProcessSignatureString(signature)



    ## PATTERN PROCESSING ##
    # _PROCESSSIGNATUREARRAY - Organizes and stores information about a series of pattern elements.
    _ProcessSignatureArray: (@_Elements) ->
        for element, a in @_Elements
            if element.Optional?
                element.Optional = new CodeSignature(element.Optional)
    # _PROCESSSIGNATURESTRING - Breaks down and interprets a string as a series of pattern elements.
    _ProcessSignatureString: (signature) ->
        signature = signature.Deblank()

        idxSig = 0
        elements = [ ]
        while idxSig < signature.length
            [ idxSig, element ] = @_ProcessElement(signature, idxSig)
            elements.push(element) if element?

        @_ProcessSignatureArray(elements)
    # _PROCESSELEMENT - Captures the next element in the signature string.
    #
    #   SYNTAX:
    #       [ end, element ] = @_ProcessElement(start)
    #
    #   OUTPUTS:
    #       end:        INTEGER
    #                   The index into the signature string at which element processing finished. This index should be re-
    #                   inputted into this method on subseqent calls (i.e. when analyzing later parts of the signature).
    #
    #       element:    OBJECT
    #                   An object containing one of three possible fields that indicate the element's type:
    #
    #                       Named       - Indicates that a token at this position in the signature should be renamed.
    #                       Optional    - Not yet implemented
    #                       Required    - Indicates that a specific token type is required at this position in a signature.
    #
    #   INPUT:
    #       start:      INTEGER
    #                   The index into the signature string at which processing should start.
    _ProcessElement: (signature, start) =>
        switch signature[start]
            when "<" then process = @_ProcessNamedElement
            when "(" then process = @_ProcessOptionalElement
            when "[" then process = @_ProcessRequiredElement
            else
                return [ start + 1, null ]

        return process(signature, start + 1)

    _ProcessNamedElement: (signature, start) =>
        end = start
        end++ while ( signature[end] isnt ">" && end < signature.length )
        element = { Named: signature.slice(start, end) }
        return [ end + 1, element ]

    _ProcessOptionalElement: (signature, start) =>
        end = start
        # element = { Optional: new CodeSignature(signature, end) }
        element = { Optional: [ ] }
        while ( signature[end] isnt ")" && end < signature.length )
            [ end, content ] = @_ProcessElement(signature, end)
            element.Optional.push(content) if content?
        return [ end + 1, element ]

    _ProcessRequiredElement: (signature, start) =>
        end = start
        end++ while ( signature[end] isnt "]" && end < signature.length )
        element = { Required: signature.slice(start, end) }
        return [ end + 1, element ]



    ## PATTERN MATCHING ##
    # _CURRENTELEMENT - Gets the current working pattern element used to match a code line.
    _CurrentElement: ->
        return null if @_IsComplete()
        return @_Elements[@_WorkingIndex]

    _MatchElement: (line, idxToken) ->
        return false unless element = @_CurrentElement()
        return false unless token = line.Tokens[idxToken]

        switch
            when element.Named?
                # return true if token.IsEmpty()
                return false unless token.IsSelector('Variable') || token.IsSelector('Words.Type')

                @_WorkingMatch[idxToken] = element.Named
                @_WorkingIndex++
                return true

            when element.Optional?
                match = element.Optional.Match(line, idxToken)

                if match.IsMatched
                    for k, v of match.Tokens
                        @_WorkingMatch[k] = v
                    @_WorkingIndex++ if match.IsComplete
                else
                    @_WorkingIndex++

                return true

            when element.Required?
                if token.IsSelector(element.Required)
                    @_WorkingMatch[idxToken] = token.Type
                    @_WorkingIndex++
                    return true
                else
                    return true if token.IsEmpty()
                    return false

    _MatchLine: (line, start) ->
        isMatched = false
        for a in [ start .. line.Count() - 1 ]
            return true if @_IsComplete()
            continue if line.Tokens[a].IsEmpty()

            isMatched = @_MatchElement(line, a)
            return false unless isMatched

        return isMatched




    Match: (line, start = 0) ->
        start = 0
        isMatched = false
        while start < line.Count()
            isMatched = @_MatchLine(line, start++)
            break if isMatched
            @Reset()

        return new PatternMatch(@_IsComplete(), isMatched, @_WorkingMatch)

    Reset: ->
        @_WorkingIndex  = 0
        @_WorkingMatch  = { }

        for element in @_Elements when element.Optional?
            element.Optional.Reset()
