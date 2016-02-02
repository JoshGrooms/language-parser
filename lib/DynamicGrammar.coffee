# CHANGELOG
# Written by Josh Grooms on 20151224

CodeBlock                   = require('./Elements/CodeBlock')
CodeFile                    = require('./Elements/CodeFile')
{ CodeStream, Token }       = require('./Elements/CodeStream')
{ clone, overload, type}    = require('./Utilities/ObjectFunctions')

{ Grammar }                 = require('first-mate')
{ CompositeDisposable}      = require('atom')
fs                          = require('fs')


module.exports = class DynamicGrammar extends Grammar

    _CodeFiles:         { }
    _DefaultLexicon:    null
    _Lexicons:          { }
    _WorkingFile:       null
    _WorkingEditor:     null
    _Program:           null
    _Subscriptions:     null



    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Program) ->
        @_CodeFiles     = { }
        @_Subscriptions = new CompositeDisposable
        @_Lexicons      = { }

        @_LoadLexicons()
        @_UpdateCodeFile()

        @_Subscriptions.add(atom.workspace.onDidChangeActivePaneItem(@_UpdateCodeFile))

        options =
            fileTypes:  "coffee"
            name:       "Dynamic Language Parser"
            scopeName:  "source"

        super(atom.grammars, options)

    destroy: ->
        @_Subscriptions.dispose()
        for file in @_CodeFiles
            file.destroy()



    ## PRIVATE UTILITIES ##
    _EndID: (scope) -> return @registry.endIdForScope(scope)
    _StartID: (scope) -> return @registry.startIdForScope(scope)

    # _LOADLEXICONS - Initializes all available dictionaries containing language-specific customizations.
    _LoadLexicons: ->
        @_DefaultLexicon = require('./Defaults/Lexicon')
        lexFiles = fs.readdirSync(@_Program.PackagePath + '/lib/Languages')
        for file in lexFiles
            ctLex = clone(@_DefaultLexicon)
            overload( ctLex, require("./Languages/" + file) )
            @_PreprocessLexicon(ctLex)
            @_Lexicons[file.split('.')[0]] = ctLex

        @_PreprocessLexicon(@_DefaultLexicon)

    # _PREPROCESSLEXICON - Performs any necessary preprocessing of a Lexicon before it is used.
    _PreprocessLexicon: (lexicon) ->
        for k, v of lexicon.Types
            if type(v) is 'object'
                v._Tag = "Types." + k unless v._Tag?
                lexicon.Types[k] = new CodeBlock(v)

        return lexicon

    # _UPDATECODEFILE - Updates the working code file object for this grammar whenever the active pane item changes.
    #
    #   This method is executed whenever a user navigates to another tab within the Atom editor.
    _UpdateCodeFile: =>
        @_WorkingEditor = atom.workspace.getActiveTextEditor()
        @_WorkingFile = @_CodeFiles[@_WorkingEditor.id]

        unless @_WorkingFile?
            filePath = @_WorkingEditor.getPath()
            ext = filePath[ filePath.lastIndexOf('.') + 1 .. filePath.length - 1 ]

            lex = @_Lexicons[ext]
            lex ?= @_DefaultLexicon

            @_CodeFiles[@_WorkingEditor.id] = new CodeFile(@_WorkingEditor, lex)
            @_WorkingFile = @_CodeFiles[@_WorkingEditor.id]



    ## ATOM API METHODS ##

    # TOKENIZELINE - Creates an array of language tokens from a single line of raw source code text.
    #
    #   SYNTAX:
    #       { line, tags, ruleStack } = @tokenizeLine(line, ruleStack)
    #       { line, tags, ruleStack } = @tokenizeLine(line, ruleStack, firstLine)
    #       { line, tags, ruleStack } = @tokenizeLine(line, ruleStack, firstLine, compatibilityMode)
    #
    #   OUTPUTS:
    #       line:               STRING
    #                           The same string of text that is found in the 'line' input argument.
    #
    #       tags:               ARRAY
    #
    #       ruleStack:          ARRAY
    #
    #   INPUTS:
    #       line:               STRING
    #                           A string of raw text from a source code file that is to be tokenized. This string always
    #                           contains the complete contents of one single line within the file.
    #
    #       ruleStack:          ARRAY
    #                           An array of tokenizing rules that gets passed through this function on every call. This array
    #                           is stored within the object that typically calls this method (a 'TokenizedBuffer').
    #
    #                           Currently, this argument isn't used and has no effects.
    #
    #   OPTIONAL INPUTS:
    #       firstLine:          BOOLEAN
    #                           A Booleaning indicating whether the 'line' argument represents the very first line of text in
    #                           the source code file being tokenized.
    #                           DEFAULT: 'false'
    #
    #       compatibilityMode:  BOOLEAN
    #                           The meaning of this argument isn't clear to me, but its value appears to be hard-coded as
    #                           'false' (see line 383 of 'tokenized-buffer.coffee' in the Atom source code), suggesting that
    #                           its purpose is vestigial. It is left here to maintain compatibility with the official Atom
    #                           API but otherwise is not used and has no effects.
    tokenizeLine: (line, ruleStack, firstLine = false, compatibilityMode = true) ->

        tags = [ ]
        # codeLine = @_CodeFile.RetokenizeLine(line, firstLine)
        codeLine = @_WorkingFile.RetokenizeLine(line, firstLine)

        for token in codeLine.Tokens
            continue if token.IsSpecial()
            tag = token.Type.replace(' ', '.').toLowerCase()
            tags.push(@_StartID(tag))
            tags.push(token.Length())
            tags.push(@_EndID(tag))

        ruleStack = { }
        return { line, tags, ruleStack }
