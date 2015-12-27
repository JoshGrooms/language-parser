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
        @_CodeFile = null
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

        @_CodeFile ?= @_Program.RequestFile()

        tokens = @_CodeFile.RetokenizeLine(line, firstLine)
        tags = [ ]
        if tokens?
            for a in [0 .. tokens.length - 1]
                token = tokens[a]
                if token?
                    type = token.Type.replace(' ', '.').toLowerCase()
                    tags.push(@_StartID(type))
                    tags.push(token.Length())
                    tags.push(@_EndID(type))

        ruleStack = { }
        return { line, tags, ruleStack }
