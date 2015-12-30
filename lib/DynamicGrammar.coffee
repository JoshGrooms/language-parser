# CHANGELOG
# Written by Josh Grooms on 20151224

{ CodeStream, Token }   = require('./Elements/CodeStream')
{ Grammar }             = require('first-mate')



module.exports = class DynamicGrammar extends Grammar

    _CodeFile:  null
    _LineCount: 0
    _Progran:   null

    _EditorChangeCallback: null



    ## CONSTRUCTOR & DESTRUCTOR ##
    constructor: (@_Program, registry) ->
        @_CodeFile = @_Program.RequestFile()
        @_LineCount = 0

        @_EditorChangeCallback = atom.workspace.onDidChangeActivePaneItem(@_UpdateCodeFile)

        options =
            fileTypes:  "coffee"
            name:       "Dynamic Language Parser"
            scopeName:  "source"

        super(registry, options)

    destroy: ->
        @_EditorChangeCallback.dispose()



    ## PRIVATE UTILITIES ##
    _EndID: (scope) -> return @registry.endIdForScope(scope)
    _StartID: (scope) -> return @registry.startIdForScope(scope)
    # _UPDATECODEFILE - Updates the working code file object for this grammar whenever the active pane item changes.
    #
    #   This method is executed whenever a user navigates to another tab within the Atom editor.
    _UpdateCodeFile: => @_CodeFile = @_Program.RequestFile()



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
        tokens = @_CodeFile.RetokenizeLine(line, firstLine)?.Tokens

        if tokens?
            for token in tokens when token?
                tag = token.Type.replace(' ', '.').toLowerCase()
                tags.push(@_StartID(tag))
                tags.push(token.Length())
                tags.push(@_EndID(tag))

        ruleStack = { }
        return { line, tags, ruleStack }
