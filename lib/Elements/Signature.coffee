# CHANGELOG
# Written by Josh Grooms on 20160112

require('../Utilities/StringExtensions')

{ clone } = require('../Utilities/ObjectFunctions')



module.exports = class CodeSignature

    _Anchors:       [ ]
    _Elements:      [ ]
    _Signature:     ""



    constructor: (@_Signature) ->
        @_Anchors   = [ ]
        @_Elements  = [ ]
        @_Signature = @_Signature.Deblank()

        idx = 0
        while idx < @_Signature.length
            [ idx, element ] = @_ProcessElement(idx)
            if element?
                @_Elements.push(element)
                if element.Required?
                    element.ElementIndex = @_Elements.length - 1
                    @_Anchors.push(element)

        return [@_Elements, @_Anchors]



    ## PATTERN PROCESSING ##
    # _PROCESSELEMENT - Captures the next element in
    _ProcessElement: (start) =>
        switch @_Signature[start]
            when "<" then process = @_ProcessNamedElement
            when "(" then process = @_ProcessOptionalElement
            when "[" then process = @_ProcessRequiredElement
            else
                return [ start + 1, null ]

        return process(start + 1)

    _ProcessNamedElement: (start) =>
        end = start
        end++ while ( @_Signature[end] isnt ">" && end < @_Signature.length )
        element = { Named: @_Signature.slice(start, end) }
        return [ end + 1, element ]

    _ProcessOptionalElement: (start) =>
        end = start
        element = { Optional: [ ] }
        while ( @_Signature[end] isnt ")" && end < @_Signature.length )
            [ end, content ] = @_ProcessElement(end)
            element.Optional.push(content) if content?
        return [ end + 1, element ]

    _ProcessRequiredElement: (start) =>
        end = start
        end++ while ( @_Signature[end] isnt "]" && end < @_Signature.length )
        element = { Required: @_Signature.slice(start, end) }
        return [ end + 1, element ]



    ## LINE MATCHING ##
    # _GETMEANINGFULTOKEN - Finds a non-whitespace token relative to a starting position.
    _GetMeaningfulToken: (line, start, offset) ->
        if offset < 0
            idxToken = start
            while offset && idxToken >= 0
                offset++ unless line.Tokens[--idxToken].IsEmpty()

        if offset > 0
            idxToken = start
            while offset && idxToken < line.Count()
                offset-- unless line.Tokens[++idxToken].IsEmpty()

        return [ null, null ] if offset
        return [ idxToken, line.Tokens[idxToken] ]

    # _IDENTIFYANCHORS - Finds the line indices of tokens that match required pattern elements.
    _IdentifyAnchors: (line) ->
        anchors = clone(@_Anchors)
        idxAnchor = 0
        for a in [ 0 .. line.Count() - 1 ]
            if line.Tokens[a].IsSelector(anchors[idxAnchor].Required)
                anchors[idxAnchor++].LineIndex = a
                break if allAnchorsFound = idxAnchor == anchors.length

        return null unless allAnchorsFound
        return anchors

    _IdentifyTokens: (line, anchors) ->
        tokens = { }
        ctAnchor = anchors[idxAnchor = 0]

        strength = 0
        for element, a in @_Elements
            switch
                when element.Named?
                    anchorOffset = a - ctAnchor.ElementIndex
                    [idxToken, ctToken] = @_GetMeaningfulToken(line, ctAnchor.LineIndex, anchorOffset)
                    return null unless ctToken?
                    tokens[idxToken] = element.Named
                    strength++

                # when element.Optional?

                when element.Required?
                    if idxAnchor < @_PrefixAnchors.length
                        ctAnchor = @_PrefixAnchors[idxAnchor++]
                        strength++
                    else
                        ctAnchor = @_PrefixAnchors[idxAnchor - 1]


        return [tokens, strength]


    Match: (line) ->
        return null if line.IsEmpty()
        return null unless anchors = @_IdentifyAnchors(line)
        return @_IdentifyTokens(line, anchors)
