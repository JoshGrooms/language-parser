# CHANGELOG
# Written by Josh Grooms on 20151218

Blocks                  = require('../Defaults/Blocks')
CodeBlock               = require('./CodeBlock')
CodeLine                = require('./CodeLine')
{ CompositeDisposable } = require('atom')
{ CodeStream, Token }   = require('./CodeStream')
{ Lexicon, Symbols }    = require('../Defaults')






module.exports = class CodeFile

    _Block:             null
    _Editor:            null
    _FileStream:        null
    _LineCount:         0
    _Lines:             [ ]
    _LineStream:        null
    _Name:              null
    _SweepActive:       false
    _WorkingLine:       0

    _Subscriptions:     null



    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Editor) ->
        @_Block         = new CodeBlock(Blocks.File)
        @_FileStream    = new CodeStream(@_Editor.GetText())
        @_LineCount     = 0
        @_Lines         = [ ]
        @_LineStream    = new CodeStream('')
        @_Name          = @_Editor.ActiveEditor.getPath()
        @_Subscriptions = new CompositeDisposable()

        @_ProcessFile()

        @_Subscriptions.add( @_Editor.ActiveEditor.onDidStopChanging(@ReprocessFile) )
        @_Subscriptions.add( @_Editor.ActiveEditor.getBuffer().onWillChange(@_HandleTextChange) )
        # @_Subscriptions.add( @_Editor.ActiveEditor.onDidChangeGrammar(@ReprocessFile) )

    destroy: ->
        @_Subscriptions.dispose()



    ## PRIVATE UTILITIES ##
    _ProcessFile: =>
        ctLine = new CodeLine(@_LineCount)
        while ( !@_FileStream.EOS() )
            @_Block.Add(@_FileStream.ReadToken())
            # ctToken = @_FileStream.ReadToken()
            #
            # if ctToken.Type is "NewLine"
            #     ctLine.Add(ctToken)
            #     @_Lines.push(ctLine)
            #     @_LineCount++
            #     ctLine = new CodeLine(@_LineCount)
            # else
            #     ctLine.Add(ctToken)

    _HandleTextChange: (evt) ->
        # console.log(evt)



    ## PUBLIC UTILITIES ##

    ReprocessFile: =>
        @_FileStream.Reset(@_Editor.GetText())
        @_LineCount = 0
        @_Lines = [ ]
        @_Name = @_Editor.ActiveEditor.getPath()

        @_ProcessFile()

        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.retokenizeLines()
        # @_Editor.ActiveEditor.displayBuffer.tokenizedBuffer.reloadGrammar()
        # @_Editor.ActiveEditor.displayBuffer.updateAllScreenLines()


    ReprocessLine: (text, lineNum) ->
        @_LineStream.Reset(text)

        newLineFound = false
        line = new CodeLine(@_WorkingLine)
        while ( !@_LineStream.EOS() )
            token = @_LineStream.ReadToken()
            line.Add(token)

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

        @_WorkingLine = @_Editor.GetCursorPosition().row
        return @ReprocessLine(text, @_WorkingLine)
