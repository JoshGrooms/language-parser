# CHANGELOG
# Written by Josh Grooms on 20160107


require('../Utilities/StringExtensions')
{ type } = require('../Utilities/ObjectFunctions')



module.exports = class CodeSignature

    _Close:      null
    _Content:    null
    _Open:       null
    _Prefix:     null
    _Suffix:     null
    _Tag:        ""


    _PrefixElements: [ ]
    _SuffixElements: [ ]

    _PrefixAnchors:  [ ]
    _SuffixAnchors:  [ ]



    ## CONSTRUCTOR ##
    constructor: (@_Tag, block) ->

        @_Close   = null
        @_Content = null
        @_Open    = null
        @_Prefix  = null
        @_Suffix  = null
        @_Tag     = ""

        @_PrefixAnchors = [ ]

        switch type(block)
            when 'object' then { @_Close, @_Content, @_Open, @_Prefix, @_Suffix } = block
            when 'string' then @Prefix = block

        if @_Content?
            @_Content = new CodeSignature(@_Content)

        if @_Prefix?
            [@_PrefixElements, @_PrefixAnchors] = @_ProcessPattern(@_Prefix)
        if @_Suffix?
            [@_SuffixElements, @_SuffixAnchors] = @_ProcessPattern(@_Suffix)



    ## PATTERN PROCESSING ##
    _ProcessPattern: (pattern) ->
        anchors = [ ]
        elements = [ ]

        idx = 0
        pattern = pattern.Deblank()
        while idx < pattern.length
            [ idx, element ] = @_ProcessElement(pattern, idx)
            if element?
                elements.push(element)
                if element.Required?
                    element.ElementIndex = elements.length - 1
                    anchors.push(element)

        return [elements, anchors]

    _ProcessElement: (pattern, start) =>
        switch pattern[start]
            when "<" then process = @_ProcessNamedElement
            when "(" then process = @_ProcessOptionalElement
            when "[" then process = @_ProcessRequiredElement
            else
                return [ start + 1, null ]

        return process(pattern, start + 1)

    _ProcessNamedElement: (pattern, start) =>
        end = start
        end++ while ( pattern[end] isnt ">" && end < pattern.length )
        element = { Named: pattern.slice(start, end) }
        return [ end + 1, element ]

    _ProcessOptionalElement: (pattern, start) =>
        end = start
        element = { Optional: [ ] }
        while ( pattern[end] isnt ")" && end < pattern.length )
            [ end, content ] = @_ProcessElement(pattern, end)
            element.Optional.push(content) if content?
        return [ end + 1, element ]

    _ProcessRequiredElement: (pattern, start) =>
        end = start
        end++ while ( pattern[end] isnt "]" && end < pattern.length )
        element = { Required: pattern.slice(start, end) }
        return [ end + 1, element ]



    ## CODE LINE UTILITIES ##
    # _FINDANCHORS - Finds the line indices of tokens that match required pattern elements.
    _FindAnchors: (line, anchors) ->
        idxAnchor = 0
        for a in [ 0 .. line.Count() - 1 ]
            if line.Tokens[a].IsSelector(anchors[idxAnchor].Required)
                anchors[idxAnchor++].LineIndex = a
                break if allAnchorsFound = idxAnchor == anchors.length

        return true if allAnchorsFound
        return false

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

    _Resolve: (line, elements, anchors) ->

        changes = [ ]
        ctAnchor = anchors[idxAnchor = 0]

        for a in [ 0 .. elements.length - 1 ]
            el = elements[a]
            switch
                when el.Named?
                    anchorOffset = a - ctAnchor.ElementIndex
                    [idxToken, ctToken] = @_GetMeaningfulToken(line, ctAnchor.LineIndex, anchorOffset)
                    return null unless ctToken?
                    changes.push({ Tag: [idxToken, @_Tag + "." + el.Named] })

                # when el.Optional?

                when el.Required?
                    if idxAnchor < @_PrefixAnchors.length
                        ctAnchor = @_PrefixAnchors[idxAnchor++]
                    else
                        ctAnchor = @_PrefixAnchors[idxAnchor - 1]

        return changes



    ## PUBLIC UTILITIES ##
    # HASPREFIX - Determines whether this code signature possesses a prefix pattern.
    HasPrefix: ->
        return false unless @_Prefix? && @_PrefixAnchors?.length
        return true
    # HASSUFFIX - Determines whether this code signature possesses a suffix pattern.
    HasSuffix: ->
        return false unless @_Suffix? && @_SuffixAnchors?.length
        return true



    ResolvePrefix: (line) ->
        return null unless @HasPrefix()
        return null if line.IsEmpty()
        return null unless @_FindAnchors(line, @_PrefixAnchors)

        return @_Resolve(line, @_PrefixElements, @_PrefixAnchors)


    ResolveSuffix: (line) ->
        return null unless @HasSuffix()
        return null if line.IsEmpty()
        return null unless @_FindAnchors(line, @_SuffixAnchors)

        return @_Resolve(line, @_SuffixElements, @_SuffixAnchors)
