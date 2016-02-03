# CHANGELOG
# Written by Josh Grooms on 20151218

CodeBlock               = require('./CodeBlock')
CodeLine                = require('./CodeLine')
# CodeSignature           = require('./Signature')
CodeSignature           = require('./CodeSignature')
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


    _ScopeStack:        [ ]


    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Editor, @_Lexicon) ->
        @_Lines             = [ ]
        @_ScopeStack        = [ @_Lexicon.Types ]
        @_Subscriptions     = new CompositeDisposable()
        @_Tokens            = [ ]
        @_Types             = [ ]

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




    _ResolveLine: (line, matches = null) ->

        ctScope = @_ScopeStack[@_ScopeStack.length - 1]
        matches ?= [ ]

        scopeNames = Object.keys(ctScope)
        for scopeName, a in scopeNames

            if matches[a]?.IsComplete || !(matches[a]?.IsMatched)
                ctScope[scopeName].Reset()

            switch
                when ctScope[scopeName] instanceof CodeBlock
                    matches[a] = ctScope[scopeName].MatchPrefix(line)

                when ctScope[scopeName] instanceof CodeSignature
                    match[a] = ctScope[scopeName].Match(line)

        return matches

    _ProcessFile: ->
        idxLine = 0
        idxToken = 0
        ctLine = @_ResetLine(idxLine++)

        # Read out every single token from the file
        while ( ctToken = @_FileStream.ReadToken() )

            @_Tokens.push(ctToken)
            ctLine.Add(ctToken)

            # Terminate the raw code line
            if ctToken.IsSelector('WhiteSpace.NewLine')
                ctLine.BlockStack = @_FileStream.OpenBlocks()

                # Start a new raw code line
                ctLine = @_ResetLine(idxLine++)

                # Update the token pool position (for future insertions as above and processing as below)
                idxToken = @_Tokens.length - 1

        ltMatches = null
        # a = 13
        # line = @_Lines[a]
        for line, a in @_Lines
            continue if line.IsEmpty()
            console.log("Current Line: " + a)
            line.Matches = @_ResolveLine(line)
            console.log(line.Matches)

        # Fresh line
        #   - If this line matches one or more patterns
        #       > If more than one pattern is matched
        #           >> If only one of these matches is marked as complete
        #               * Then this pattern should be used
        #
        #           >> If multiple matches are marked as complete
        #               * Use the pattern with the greatest number of matched tokens
        #
        #           >> If no patterns are marked as complete
        #               * Process the subsequent line to see if any matches improve
        #
        #       > If only one pattern is matched
        #           >> Then this pattern should be used
        #           >> If this match is marked as complete
        #               * Reset all matches
        #           >> Otherwise
        #               * Process the subsequent line to see if the match improves
        #
        #   - Otherwise
        #       > Reset all patterns
        #       > Continue processing the subsequent line




    _ReprocessLine: (text, lineNum) ->
        @_LineStream.Reset(text, @_OpenBlocks(lineNum))
        line = @_ResetLine(lineNum)
        line.Add(@_LineStream.ReadToken()) while ( !@_LineStream.EOS() )
        line.BlockStack = @_LineStream.OpenBlocks()
        return line
    # _RESETLINE - Deletes and reinitializes a single line of source code.
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
        @_Lines         = [ ]
        @_Tokens        = [ ]
        @_Types         = [ ]

        @_ProcessFile()

        # Scan blocks of code

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
