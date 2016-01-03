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

        @DefaultLexicon = require('./Defaults/Lexicon')
        @Editor = new Editor();
        @PackagePath = atom.packages.resolvePackagePath('language-parser')
        @Subscriptions = new CompositeDisposable;
        @UI = new DebugView();

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


    RequestLexicon: (extension) ->
        return @DefaultLexicon unless extension?
        return lexicon if lexicon = @_Lexicons[extension]
        return @DefaultLexicon
