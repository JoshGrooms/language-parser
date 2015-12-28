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

    _UpdateCodeFile: =>
        @_CodeFile = @_Program.RequestFile()



    ## ATOM API METHODS ##
    # TOKENIZELINE -
    tokenizeLine: (line, ruleStack, firstLine = false, compatibilityMode = true) ->

        # 'compatibilityMode' appears to be hard-coded as 'false', based on its call from
        # line 383 of 'tokenized-buffer.coffee', which appears to be the only caller.

        # @_CodeFile ?= @_Program.RequestFile()

        tags = [ ]
        tokens = @_CodeFile.RetokenizeLine(line, firstLine)?.Tokens

        if tokens?
            for token in tokens when token?
                type = token.Type.replace(' ', '.').toLowerCase()
                tags.push(@_StartID(type))
                tags.push(token.Length())
                tags.push(@_EndID(type))

        ruleStack = { }
        return { line, tags, ruleStack }

    var:
        "
            Testing this out on some text
            some additional text
            Some more text
            testing this out some more
            testing this out
        "
