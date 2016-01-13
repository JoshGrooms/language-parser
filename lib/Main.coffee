# CHANGELOG
# Written by Josh Grooms on 20151218

{ clone, overload, type }   = require('./Utilities/ObjectFunctions')
CodeFile                    = require('./Elements/CodeFile')
{ CodeStream, Token }       = require('./Elements/CodeStream')
DynamicGrammar              = require('./DynamicGrammar')

{ CompositeDisposable }     = require('atom');
fs                          = require('fs')



module.exports = LanguageParser =

    Grammar:            null
    PackagePath:        null
    Subscriptions:      null
    UI:                 null



    ## ATOM PACKAGE METHODS ##
    activate: (state) ->

        @DefaultLexicon     = require('./Defaults/Lexicon')
        @PackagePath        = atom.packages.resolvePackagePath('language-parser')
        @Subscriptions      = new CompositeDisposable

        @Grammar = new DynamicGrammar(this, atom.grammars)
        atom.grammars.addGrammar(@Grammar)

    deactivate: ->
        @Subscriptions.dispose()
        @Grammar.destroy()



    ## PUBLIC METHODS ##

    # REQUESTLEXICON - Gets a customized language dictionary that is appropriate for a specified file extension.
    #
    #   This method returns a reference to the lexicon that is meant to be in conjunction with specific file types. If no
    #   such dictionary has been created to handle the inputted extension, then this method will return the default lexicon
    #   data object.
    #
    #   SYNTAX:
    #       lexicon = @RequestLexicon(extension)
    #
    #   OUTPUT:
    #       lexicon:    OBJECT
    #                   An object that describes the symbols and lexical structure of a programming language. The specific
    #                   lexicon instance that is returned depends on the inputted file type. However, if no specific lexicon
    #                   matching the 'extension' argument can be found, then this method will return a default lexicon that
    #                   is suitable for many C-style languages.
    #
    #   INPUT:
    #       extension:  STRING
    #                   A string containing the extension of the file for which a lexicon is being requested. This argument
    #                   is simply the extension part of the file's name string (i.e. 'example' in '/path/to/file.example').
    # RequestLexicon: (extension) ->
    #     return @DefaultLexicon unless extension?
    #     extension = extension.replace(/^\./, '')
    #     return lexicon if lexicon = @_Lexicons[extension]
    #     return @DefaultLexicon
