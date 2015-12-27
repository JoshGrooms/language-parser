# CHANGELOG
# Written by Josh Grooms on 20151218

CodeFile                = require('./Elements/CodeFile')
{ CodeStream, Token }   = require('./Elements/CodeStream')
{ CompositeDisposable } = require('atom');
DebugView               = require('./DebugView');
Editor                  = require('./Editor');
{ Lexicon, Symbols }    = require('./Defaults');
DynamicGrammar          = require('./DynamicGrammar')
DynamicRegistry         = require('./DynamicRegistry')


module.exports = LanguageParser =

    DefaultLexicon:     null
    Editor:             null
    Grammar:            null
    Subscriptions:      null
    UI:                 null


    _CodeFiles:         { }



    ## ATOM PACKAGE METHODS ##
    activate: (state) ->
        @_CodeFiles = [ ];
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
        file = @_CodeFiles[id]

        if file? then return file

        file = new CodeFile(@Editor)
        @_CodeFiles[id] = file
        # console.log(@Editor.GetAllText())

        return file
