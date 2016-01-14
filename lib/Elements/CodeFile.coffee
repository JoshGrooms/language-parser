# CHANGELOG
# Written by Josh Grooms on 20151218

CodeBlock               = require('./CodeBlock')
CodeLine                = require('./CodeLine')
CodeSignature           = require('./Signature')
{ clone }               = require('../Utilities/ObjectFunctions')
{ CompositeDisposable } = require('atom')
{ CodeStream, Token }   = require('./CodeStream')
{ Lexicon, Symbols }    = require('../Defaults')




min = (x, y) ->
    return x if x <= y
    return y




module.exports = class CodeFile

    # _ATOMTOKENBUFFER - A shortcut reference to Atom's 'TokenizedBuffer' object for the active text editor.
    _AtomTokenBuffer:   null
    _Block:             null
    _Editor:            null
    _FileStream:        null
    _Lexicon:           null
    # _LINES - The internal code line buffer for the file.
    _Lines:             [ ]
    # _LINESTREAM - A token stream meant for reprocessing single lines of source code text.
    _LineStream:        null
    _SweepActive:       false
    # _WORKINGLINE - The source code line number that is currently being processed.
    _WorkingLine:       0
    # _SUBSCRIPTIONS - A collection of disposable event registrations.
    _Subscriptions:     null
    _Tokens:            [ ]
    _Types:             [ ]


    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Editor, @_Lexicon) ->
        @_Lines             = [ ]
        @_Tokens            = [ ]
        @_Types             = [ ]
        @_Subscriptions     = new CompositeDisposable()

        @_AtomTokenBuffer   = @_Editor.displayBuffer.tokenizedBuffer
        @_FileStream        = new CodeStream(@_Editor.getText(), @_Lexicon)
        @_LineStream        = new CodeStream('', @_Lexicon)

        @_ProcessFile()

        @_Subscriptions.add( @_Editor.onDidStopChanging(@ReprocessFile) )
        @_Subscriptions.add( @_Editor.getBuffer().onWillChange(@_HandleTextChange) )

    destroy: ->
        @_Subscriptions.dispose()



    ## PRIVATE UTILITIES ##

    # _DELETELINES - Removes one or more lines from the file's code line buffer.
    _DeleteLines: (start, n = 1) ->
        @_Lines.splice(start, n)
        return undefined

    # _HANDLETEXTCHANGE - Monitors the Atom text buffer for changes and modifies the file's code line buffer accordingly.
    #
    #   This method is a callback function that is invoked before text is actually changed within Atom's text buffers.
    #
    #   INPUT:
    #       evt:    OBJECT
    #               An Atom text change event with the following fields:
    #
    #                   newRange:       - The range of the new text being inserted.
    #                       end:        - The end point of the new text being inserted.
    #                           column  - The column number of the end point.
    #                           row     - The row number of the end point.
    #                       start:      -
    #                           column  -
    #                           row     -
    #                   newText         -
    #                   oldRange:       -
    #                       end:        -
    #                           column  -
    #                           row     -
    #                       start:      -
    #                           column  -
    #                           row     -
    #                   oldText         -
    _HandleTextChange: (evt) =>
        @_WorkingLine = evt.newRange.start.row
        newLineRange = evt.newRange.end.row - evt.newRange.start.row
        oldLineRange = evt.oldRange.end.row - evt.oldRange.start.row

        return undefined if newLineRange == oldLineRange

        if newLineRange > oldLineRange
            @_InsertLines(evt.oldRange.end.row + 1, newLineRange - oldLineRange)
        else
            @_DeleteLines(evt.oldRange.end.row, oldLineRange - newLineRange)

    # _INDENTLEVEL - Retrieves the indentation level for a specific line of source code text.
    _IndentLevel: (lineNum) ->
        return 0 if lineNum < 0
        return @_Lines[lineNum].IndentLevel unless @_Lines[lineNum].IsEmpty()
        return @_IndentLevel(lineNum - 1)

    # _INSERTLINE - Inserts a single line into the file's code line buffer.
    _InsertLine: (lineNum, line = null) ->
        line ?= new CodeLine()
        @_Lines.splice(lineNum, 0, line)
        return undefined

    # _INSERTLINES - Inserts one or more lines into the file's code line buffer.
    _InsertLines: (start, n) ->
        @_InsertLine(start++) while n--
        return undefined

    # _OPENBLOCKS - Generates a copy of the open block stack at the beginning of a code line.
    _OpenBlocks: (lineNum) ->
        return null if lineNum == 0
        lineNum = min(@_Lines.length - 1, lineNum)
        return clone(@_Lines[lineNum - 1].BlockStack)


    _SplitLine: (line, idx) ->
        first = clone(line)
        first.Tokens = line.Tokens.slice(0, idx)
        second = clone(line)
        second.Tokens = line.Tokens.slice(idx + 1)

        return [first, second]



    _ProcessLine: (line, blocks) ->
        blocks ?= @_Lexicon.Types

        idxBlockOpen = line.FindSelector("Enclosure.Open.Block")
        if idxBlockOpen != -1
            [ first, second ] = @_SplitLine(line)

            if !first.IsEmpty()


        for token in line.Tokens
            switch
                when token.IsSelector("Enclosure.Open.Block")

                when token.IsSelector("Enclosure.Close.Block")




    _ProcessBlock: (lineNum, idxOpen) ->

        line = @_Lines[lineNum]

        ltMatch = null
        ltStrength = 0
        ltBlock = null

        # Test this
        [ first, second ] = @_SplitLine(line, b)

        firstEmpty = first.IsEmpty()
        secondEmpty = second.IsEmpty()
        # break if firstEmpty && secondEmpty

        lineQueue.push(second) unless secondEmpty
        # if (firstEmpty && secondEmpty) then inlineBlock = false
        # else inlineBlock = true

        unless firstEmpty
            for k, v of @_Lexicon.Types

                if token.IsSelector(v._Open)
                    testLine = if inlineBlock then line else @_Lines[a - 1]
                    [match, strength] = v.MatchPrefix(testLine)

                    if match? && (strength > ltStrength)
                        ltBlock = v
                        ltMatch = match
                        ltStrength = strength

            if ltBlock? && ltMatch?
                for idx, name of ltMatch
                    testLine[idx].Type = name

            blockStack.push(ltBlock) if ltBlock?
            contentStack.push(ltBlock._Content) if ltBlock?._Content?





    _ProcessBlocks: ->
        blockStack = [ ]
        contentStack = [ ]
        content = @_Lexicon.Types

        idxLine = 0
        lineQueue = [ ]
        while idxLine < @_Lines.length
            line = if lineQueue.length then lineQueue.pop() else @_Lines[idxLine++]

            continue if line.IsEmpty()

            idxBlockOpen = line.FindSelector("Enclosure.Open.Block")
            if idx != -1


                # Test this
                [ first, second ] = @_SplitLine(line, idxBlockOpen)

                firstEmpty = first.IsEmpty()
                secondEmpty = second.IsEmpty()
                # break if firstEmpty && secondEmpty


                lineQueue.push(second) unless secondEmpty
                # if (firstEmpty && secondEmpty) then inlineBlock = false
                # else inlineBlock = true

                if firstEmpty
                    prefixLine = @_Lines[idxLine]


                ltMatch = null
                ltStrength = 0
                ltBlock = null
                unless firstEmpty
                    for k, v of @_Lexicon.Types

                        if token.IsSelector(v._Open)
                            # testLine = if inlineBlock then line else @_Lines[a - 1]
                            [match, strength] = v.MatchPrefix(first)

                            if match? && (strength > ltStrength)
                                ltBlock = v
                                ltMatch = match
                                ltStrength = strength

                                if ltBlock? && ltMatch?
                                    for idx, name of ltMatch
                                        first[idx].Type = name

                                        blockStack.push(ltBlock) if ltBlock?
                                        contentStack.push(ltBlock._Content) if ltBlock?._Content?

                                        unless secondEmpty






            for token, b in line.Tokens
                switch
                    when token.IsSelector("Enclosure.Open.Block")







        for line, a in @_Lines
            continue if line.IsEmpty()

            lineQueue = [ ]

            inlineBlock = false


                    when token.IsSelector("Enclosure.Close.Block")
                        continue unless blockStack.length

                        ctBlock = blockStack[blockStack.length - 1]
                        if token.IsSelector(ctBlock._Close)
                            blockStack.pop()
                            contentStack.pop() if ctBlock._Content?

                            # Suffix processing

                    else
                        inlineBlock = true unless token.IsEmpty()

                        if contentStack.length
                            content = contentStack[contentStack.length - 1]
                        else
                            content = @_Lexicon.Types
















    _ProcessFile: ->
        idxLine = 0
        ctLine = @_ResetLine(idxLine++)

        while ( ctToken = @_FileStream.ReadToken() )
            @_Tokens.push(ctToken)
            ctLine.Add(ctToken)
            if ctLine.IsClosed
                ctLine.BlockStack = @_FileStream.OpenBlocks()
                ctLine = @_ResetLine(idxLine++)

    _ReprocessLine: (text, lineNum) ->
        @_LineStream.Reset(text, @_OpenBlocks(lineNum))
        line = @_ResetLine(lineNum)
        line.Add(@_LineStream.ReadToken()) while ( !@_LineStream.EOS() )
        line.BlockStack = @_LineStream.OpenBlocks()
        return line

    _ResetLine: (lineNum) ->
        line = @_Lines[lineNum] = new CodeLine()

        if @_Lexicon.IsPythonic
            ctIndent = line.IndentLevel = @_Editor.indentationForBufferRow(lineNum)
            ltIndent = @_IndentLevel(lineNum - 1)

            if ctIndent > ltIndent
                for a in [ 0 .. ctIndent - ltIndent - 1 ]
                    line.Add(new Token("@Indent", "Symbols.Enclosure.Open.Block"))
            if ctIndent < ltIndent
                for a in [ 0 .. ltIndent - ctIndent - 1 ]
                    line.Add(new Token("@Outdent", "Symbols.Enclosure.Close.Block"))

        return line




    ## PUBLIC UTILITIES ##

    # LINECOUNT - Gets the number of individual lines that are present in this code file.
    #
    #   SYNTAX:
    #       n = @LineCount()
    #
    #   OUTPUT:
    #       n:      INTEGER
    #               The total number of source code lines that are present in this file. This output reflects a count of the
    #               number of newline characters (i.e. '\n') that are present in the source text.
    LineCount: -> return @_Lines.length

    # REPROCESSFILE - Deletes all stored data and completely reprocesses all text inside the file.
    ReprocessFile: =>
        @_FileStream.Reset(@_Editor.getText())
        @_Lines     = [ ]
        @_Tokens    = [ ]
        @_Types     = [ ]

        @_ProcessFile()

        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.retokenizeLines()
        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.reloadGrammar()
        # @_Editor.ActiveEditor.displayBuffer.updateAllScreenLines()

    RetokenizeLine: (text, isFirstLine) ->
        if isFirstLine
            # Then a sweep is for sure happening
            @_SweepActive = true
            @_WorkingLine = 0

        if @_SweepActive
            if @_WorkingLine >= @LineCount()
                @_SweepActive = false
                return @_Lines[@_Lines.length - 1]
            else
                return @_Lines[@_WorkingLine++]



        return @_ReprocessLine(text, @_WorkingLine++)
