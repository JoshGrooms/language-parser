# CHANGELOG
# Written by Josh Grooms on 20151218

{ clone, overload }     = require('./Utilities/ObjectFunctions')

CodeFile                = require('./Elements/CodeFile')
{ CodeStream, Token }   = require('./Elements/CodeStream')
{ CompositeDisposable } = require('atom');
DebugView               = require('./DebugView');
Editor                  = require('./Editor');
# { Lexicon, Symbols }    = require('./Defaults');
DynamicGrammar          = require('./DynamicGrammar')
DynamicRegistry         = require('./DynamicRegistry')


module.exports = LanguageParser =

    _CodeFiles:         { }
    _Lexicons:          { }

    DefaultLexicon:     null
    Editor:             null
    Grammar:            null
    Subscriptions:      null
    UI:                 null





    ## ATOM PACKAGE METHODS ##
    activate: (state) ->
        @_CodeFiles = { };
        @_Lexicons = { };

        @DefaultLexicon = require('./Defaults/Lexicon')
        @Editor = new Editor();
        @Subscriptions = new CompositeDisposable;
        @UI = new DebugView();

        @Grammar = new DynamicGrammar(this, atom.grammars)
        atom.grammars.addGrammar(@Grammar)

        @Subscriptions.add( atom.commands.add('atom-workspace', 'debug-panel:toggle': => @Toggle()) );


    deactivate: ->
        @Subscriptions.dispose();
        @UI.destroy();
        @Grammar.destroy()

        for k, file of @_CodeFiles
            file.destroy()


    ## PRIVATE UTILITIES ##
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
        return @DefaultLexicon if !extension?
        return lexicon if lexicon = @_Lexicons[extension]

        lexicon = clone(@DefaultLexicon)
        overload( lexicon, require("./Languages/#{extension.toLowerCase()}.coffee") )
        @_Lexicons[extension] = lexicon

        return lexicon
        # console.log(@DefaultLexicon)
        # return @DefaultLexicon
