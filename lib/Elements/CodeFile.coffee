# CHANGELOG
# Written by Josh Grooms on 20151218

Blocks                  = require('../Defaults/Blocks')
CodeBlock               = require('./CodeBlock')
{ CompositeDisposable } = require('atom')
{ CodeStream, Token }   = require('./CodeStream')
{ Lexicon, Symbols }    = require('../Defaults')






module.exports = class CodeFile

    _Editor:            null
    _FileStream:        null
    _LineCount:         0
    _Lines:             [ ]
    _LineStream:        null
    _Name:              null
    _Tokens:            [ ]
    _SweepActive:       false
    _WorkingLine:       0

    _Registrations:     null



    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Editor) ->
        @_FileStream    = new CodeStream(@_Editor.GetText())
        @_LineCount     = 0
        @_Lines         = [ ]
        @_LineStream    = new CodeStream('')
        @_Name          = @_Editor.ActiveEditor.getPath()
        @_Registrations = new CompositeDisposable()

        @_ProcessFile()

        @_Registrations.add( @_Editor.ActiveEditor.onDidStopChanging(@ReprocessFile) )
        # @_Registrations.add( @_Editor.ActiveEditor.onDidChangeGrammar(@ReprocessFile) )

    destroy: ->
        @_Registrations.dispose()



    ## PUBLIC UTILITIES ##

    _ProcessFile: =>
        ctLine = [ ]
        while (!@_FileStream.EOS())
            ctToken = @_FileStream.ReadToken()

            if ctToken.Type is "NewLine"
                ctLine.push(ctToken)
                @_Lines.push(ctLine)
                @_LineCount++
                ctLine = [ ]
            else
                ctLine.push(ctToken)


    ReprocessFile: =>
        @_FileStream.Reset(@_Editor.GetText())
        @_LineCount = 0
        @_Lines = [ ]
        @_Name = @_Editor.ActiveEditor.getPath()

        ctLine = [ ]
        while (!@_FileStream.EOS())
            ctToken = @_FileStream.ReadToken()

            if ctToken.Type is "NewLine"
                ctLine.push(ctToken)
                @_Lines.push(ctLine)
                @_LineCount++
                ctLine = [ ]
            else
                ctLine.push(ctToken)

        @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.retokenizeLines()
        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.reloadGrammar()
        # @_Editor.ActiveEditor.displayBuffer.updateAllScreenLines()


    ReprocessLine: (text, lineNum) ->
        @_LineStream.Reset(text)

        newLineFound = false
        line = [ ]
        while ( !@_LineStream.EOS() )
            token = @_LineStream.ReadToken()
            line.push(token)

        return line

    RetokenizeLine: (text, firstLine) ->

        if firstLine
            # Then a sweep is for sure happening
            @_SweepActive = true
            @_WorkingLine = 0

            # return @_Lines[@_WorkingLine++]
            return @ReprocessLine(text, @_WorkingLine++)


        if @_SweepActive
            if @_WorkingLine >= @_LineCount
                @_SweepActive = false
            else
                return @_Lines[@_WorkingLine++]

        console.log(text)
        @_WorkingLine = @_Editor.GetCursorPosition().row
        return @ReprocessLine(text, @_WorkingLine)
