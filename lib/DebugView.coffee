# CHANGELOG
# Written by Josh Grooms on 20151218

require('./Utilities/StringExtensions')


EditorTemplate =    (content) -> return "<atom-text-editor class=\"debug-panel-editor\">#{content}</atom-text-editor>"
LineTemplate =      (content) -> return "<div class=\"line parser\">#{content}</div>"
WordTemplate =      (content) -> return "<span>#{content}</span>"

TokenTemplate = (token) ->
    type = token.Type;
    value = token.Value();
    return "<span class=\"source #{type}\">#{value}</span>"
TokenGroupTemplate = (tokens) ->
    return "<div class=\"source parser\">#{tokens}</div>"


module.exports = class DebugView


    _AtomPanel:          null;
    _DebugPanel:         null;
    _RootPanel:          null
    _Lines:              "";
    _Tokens:             "";

    constructor: ->
        @_DebugPanel = document.createElement('div');
        @_DebugPanel.classList.add('debug-panel', 'inset-panel', 'padded');
        @_AtomPanel = atom.workspace.addBottomPanel(item: @_DebugPanel, visible: false);

        # @_RootPanel = @_DebugPanel.createShadowRoot();

    destroy: ->
        @_AtomPanel.destroy();
        @_DebugPanel.remove();

    SetText: (text) ->
        @_DebugPanel.textContent = text;


    # CLEAR - Removes all elements from the debug panel.
    Clear:      -> @_Lines = @_Tokens = "";
    Hide:       -> @_AtomPanel.hide();
    IsVisible:  -> return @_AtomPanel.isVisible();
    Toggle:     -> if @IsVisible() then @Hide() else @Show()

    Show:       ->
        # @_DebugPanel.innerHTML = EditorTemplate(LineTemplate(@_Tokens))
        # @_DebugPanel.innerHTML = TokenGroupTemplate(@_Tokens)
        @ToHTML()
        @_AtomPanel.show()


    ToHTML: ->
        # @_DebugPanel.innerHTML = EditorTemplate(TokenGroupTemplate(@_Tokens))
        @_DebugPanel.innerHTML = TokenGroupTemplate(@_Tokens)
        # @_RootPanel.innerHTML = TokenGroupTemplate(@_Tokens)


    Write: (text) ->
        # if (text.Contains('\n'))
        @_DebugPanel.textContent = @_DebugPanel.textContent.concat(text);

    WriteLine: (text) ->
        @_Lines += LineTemplate(text + '\n');

    WriteToken: (token) ->
        template = TokenTemplate(token)
        @_Tokens += TokenTemplate(token)
