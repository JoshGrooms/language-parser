# CHANGELOG
# Written by Josh Grooms on 20151218

{ clone, overload, type }   = require('./Utilities/ObjectFunctions')
CodeFile                    = require('./Elements/CodeFile')
{ CodeStream, Token }       = require('./Elements/CodeStream')
DebugView                   = require('./DebugView');
Editor                      = require('./Editor');
DynamicGrammar              = require('./DynamicGrammar')

{ CompositeDisposable }     = require('atom');
fs                          = require('fs')



module.exports = LanguageParser =

    _CodeFiles:         { }
    _Lexicons:          { }

    DefaultLexicon:     null
    Editor:             null
    Grammar:            null
    PackagePath:        null
    Subscriptions:      null
    UI:                 null



    ## ATOM PACKAGE METHODS ##
    activate: (state) ->
        @_CodeFiles = { };
        @_Lexicons = { };

        @DefaultLexicon     = require('./Defaults/Lexicon')
        @Editor             = new Editor();
        @PackagePath        = atom.packages.resolvePackagePath('language-parser')
        @Subscriptions      = new CompositeDisposable;
        @UI                 = new DebugView();

        @Subscriptions.add( atom.commands.add('atom-workspace', 'debug-panel:toggle': => @Toggle()) );

        @_LoadLexicons()

        @Grammar = new DynamicGrammar(this, atom.grammars)
        atom.grammars.addGrammar(@Grammar)

    deactivate: ->
        @Subscriptions.dispose();
        @UI.destroy();
        @Grammar.destroy()

        for k, file of @_CodeFiles
            file.destroy()



    ## PRIVATE UTILITIES ##

    # _LOADLEXICONS - Initializes all available dictionaries containing language-specific customizations.
    _LoadLexicons: ->
        lexFiles = fs.readdirSync(@PackagePath + '/lib/Languages')
        for file in lexFiles
            ctLex = clone(@DefaultLexicon)
            overload( ctLex, require("./Languages/" + file) )
            @_Lexicons[file.split('.')[0]] = ctLex

        return undefined

    _GenerateCodeFile: (id) ->
        file = new CodeFile(@Editor)
        @_CodeFiles[id] = file




    ## PUBLIC METHODS ##
    Hide:       -> @UI.Hide();
    Toggle:     -> if @UI.IsVisible() then @Hide() else @Show();

    Show: ->
        # @UI.Clear()
        # cs = new CodeStream(@Editor.GetText())
        #
        # while (!cs.EOS())
        #     token = cs.ReadToken()
        #     @UI.WriteToken(token)
        #
        # @UI.Show();

    RequestFile: ->
        id = @Editor.ActiveEditor.id
        return file if file = @_CodeFiles[id]

        file = new CodeFile(this)
        @_CodeFiles[id] = file
        return file

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
    RequestLexicon: (extension) ->
        return @DefaultLexicon unless extension?
        extension = extension.replace(/^\./, '')
        return lexicon if lexicon = @_Lexicons[extension]
        return @DefaultLexicon
