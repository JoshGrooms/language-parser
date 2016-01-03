# CHANGELOG
# Written by Josh Grooms on 20151218

{ clone }               = require('../Utilities/ObjectFunctions')
Blocks                  = require('../Defaults/Blocks')
CodeBlock               = require('./CodeBlock')
CodeLine                = require('./CodeLine')
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
    # _EXTENSION - A string containing the extension part of this file's name.
    _Extension:         null
    _FileStream:        null
    _Lexicon:           null
    # _LINES - The internal code line buffer for the file.
    _Lines:             [ ]
    # _LINESTREAM - A token stream meant for reprocessing single lines of source code text.
    _LineStream:        null
    _Name:              null
    _SweepActive:       false
    # _WORKINGLINE - The source code line number that is currently being processed.
    _WorkingLine:       0
    # _SUBSCRIPTIONS - A collection of disposable event registrations.
    _Subscriptions:     null



    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Program) ->
        @_Editor            = @_Program.Editor
        @_Name              = @_Editor.ActiveEditor.getPath()

        @_AtomTokenBuffer   = @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer
        @_Extension         = @_Name[ @_Name.lastIndexOf('.') + 1 .. @_Name.length - 1 ]
        @_Lexicon           = @_Program.RequestLexicon(@_Extension)
        @_Lines             = [ ]
        @_Subscriptions     = new CompositeDisposable()

        @_Block             = new CodeBlock(@_Lexicon.Blocks.File)
        @_FileStream        = new CodeStream(@_Editor.GetText(), @_Lexicon)
        @_LineStream        = new CodeStream('', @_Lexicon)

        @_ProcessFile()

        # @_Subscriptions.add( @_Editor.ActiveEditor.onDidStopChanging(@ReprocessFile) )
        @_Subscriptions.add( @_Editor.ActiveEditor.getBuffer().onWillChange(@_HandleTextChange) )

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

    # _INSERTLINE - Inserts a single line into the file's code line buffer.
    _InsertLine: (lineNum, line = null) ->
        line ?= new CodeLine()
        @_Lines.splice(lineNum, 0, line)
        return undefined
    # _INSERTLINES - Inserts one or more lines into the file's code line buffer.
    _InsertLines: (start, n) ->
        @_InsertLine(start++) while n--
        return undefined
    # _OPENBLOCKS - Generates a copy of the block stack left open at the end of the previous code line.
    _OpenBlocks: (lineNum) ->
        return null if lineNum == 0
        lineNum = min(@_Lines.length - 1, lineNum)
        return clone(@_Lines[lineNum - 1].BlockStack)

    _ProcessFile: =>
        ctLine = new CodeLine()
        while ( !@_FileStream.EOS() )
            ctLine.Add(@_FileStream.ReadToken())
            if ctLine.IsClosed
                ctLine.BlockStack = @_FileStream.OpenBlocks()
                @_Lines.push(ctLine)
                ctLine = new CodeLine()



    _ReprocessLine: (text, lineNum) ->
        @_LineStream.Reset(text, @_OpenBlocks(lineNum))

        line = new CodeLine()
        line.Add(@_LineStream.ReadToken()) while ( !@_LineStream.EOS() )
        line.BlockStack = @_LineStream.OpenBlocks()
        @_Lines[lineNum] = line

        return line


    _ReprocessLines: (start, end) ->
        end ?= @_AtomTokenBuffer.getLastRow()

        text = @_Editor.GetLines(start, end)
        @_LineStream.Reset(text, @_OpenBlocks(start))

        idxLine = start
        ctLine = new CodeLine()
        while ( !@_LineStream.EOS() )
            ctLine.Add(@_LineStream.ReadToken())
            if ctLine.IsClosed
                ctLine.BlockStack = @_FileStream.OpenBlocks()
                @_Lines[idxLine++] = ctLine
                ctLine = new CodeLine()

        return undefined




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
        @_FileStream.Reset(@_Editor.GetText())
        @_Lines = [ ]
        @_Name = @_Editor.ActiveEditor.getPath()

        @_ProcessFile()

        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.retokenizeLines()
        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.reloadGrammar()
        # @_Editor.ActiveEditor.displayBuffer.updateAllScreenLines()




    RetokenizeLine: (text, firstLine) ->
        if firstLine
            # Then a sweep is for sure happening
            @_SweepActive = true
            @_WorkingLine = 0

        if @_SweepActive
            if @_WorkingLine >= @LineCount()
                @_SweepActive = false
            else
                return @_Lines[@_WorkingLine++]

        return @_ReprocessLine(text, @_WorkingLine++)
