# CHANGELOG
# Written by Josh Grooms on 20150820



# EDITOR - A wrapper class that contains and manages all open text editors within Atom.
module.exports = class Editor
    ActiveEditor:   null
    OpenEditors:    null
    Workspace:      null


    ### CONSTRUCTOR & DESTRUCTOR METHODS ###
    constructor: ->
        @_Refresh()
        @_EditorChangeCallback = @Workspace.onDidChangeActivePaneItem(@_Refresh)

    destroy: ->
        @_EditorChangeCallback.dispose()



    ### PRIVATE METHODS ###
    _Refresh: =>
        @Workspace = atom.workspace
        @ActiveEditor = @Workspace.getActiveTextEditor()
        @OpenEditors = @Workspace.getTextEditors()

    # GETALLTEXT - Gets a string containing the concatenated text from all currently open text editors.
    #
    #   SYNTAX:
    #       s = @GetAllText()
    #
    #   OUTPUT:
    #       s:      STRING
    GetAllText: ->
        txt = @GetText()
        for editor in @OpenEditors
            if editor isnt @ActiveEditor
                txt = txt.concat(editor.getText())
        return txt

    # GETTEXT - Gets the text found within the currently active text editor.
    #
    #   SYNTAX:
    #       s = @GetText()
    GetText: ->
        return @ActiveEditor.getText()



    ### EDITOR SELECTIONS ###

    # GETCHARLEFT - Gets the character immediately to the left of the cursor position within the active text editor.
    #
    #   This method is similar to the 'SelectLeft' method found within this class, except that it does not leave any text
    #   highlighted within the editor once it returns. It's purpose is only to retrieve the character on the left side of
    #   the blinking cursor. If desired, use 'SelectLeft' instead to both retrieve this character value and keep it
    #   selected within the editor.
    #
    #   SYNTAX:
    #       c = @ActiveEditor()
    #
    #   OUTPUT:
    #       c:      CHAR
    #               The single character value found directly to the left of the current cursor position.
    GetCharLeft: ->
        c = @SelectLeft()
        @SelectRight()
        return c

    # GETCHARRIGHT - Gets the character immediately to the right of the cursor position within the active text editor.
    #
    #   This method is similar to the 'SelectRight' method found within this class, except that it does not leave any text
    #   highlighted within the editor once it returns. It's purpose is only to retrieve the character on the right side of
    #   the blinking cursor. If desired, use 'SelectRight' instead to both retrieve this character value and keep it
    #   selected within the editor.
    #
    #   SYNTAX:
    #       c = @GetCharRight()
    #
    #   OUTPUT:
    #       c:      CHARACTER
    #               The single character value found directly to the right of the current cursor position.
    GetCharRight: ->
        c = @SelectRight()
        @SelectLeft()
        return c

    # GETCURSORLINE - Gets the line number on which the cursor resides within the active text editor.
    GetCursorLine: -> return @GetCursorPosition().row

    # GETCURSORPOSITION - Gets the current position of the cursor within the active text editor.
    GetCursorPosition: -> return @ActiveEditor.getCursorBufferPosition()

    # GETSELECTION - Gets the characters that are currently highlighted within the active text editor.
    #
    #   SYNTAX:
    #       s =  @GetSelection()
    #
    #   OUTPUT:
    #       s:      STRING
    #               The string of text currently selected or highlighted by the cursor.
    GetSelection: ->
        return @ActiveEditor.getSelectedText()

    # SELECTLEFT - Selects characters to the left of the cursor position in the active text editor.
    #
    #   SYNTAX:
    #       s = @SelectLeft()
    #       s = @SelectLeft(n)
    #
    #   OUTPUT:
    #       s:      STRING
    #               A string of one or more characters that are contained in the highlighted region of the text editor. The
    #
    #               number of characters in this string will always equal the input argument 'n'.
    #   OPTIONAL INPUT:
    #       n:      INTEGER
    #               The number of characters to the left of the cursor that will be selected. By default, only the first
    #               character will be highlighted.
    #               DEFAULT: 1
    SelectLeft: (n = 1) ->
        @ActiveEditor.selectLeft(n)
        return @GetSelection()

    # SELECTRIGHT - Selects characters to the right of the cursor position in the active text editor.
    #
    #   SYNTAX:
    #       s = @SelectRight()
    #       s = @SelectRight(n)
    #
    #   OUTPUT:
    #       s:      STRING
    #               A string of one or more characters that are contained within the highlighted region of the text editor.
    #               The number of characters in this string will always equal the input argument 'n'.
    #
    #   OPTIONAL INPUT:
    #       n:      INTEGER
    #               A positive integer dictating the number of characters to the right of the cursor that will be selected.
    #               By default, only the first character will be highlighted.
    #               DEFAULT: 1
    SelectRight: (n = 1) ->
        @ActiveEditor.selectRight(n)
        return @GetSelection()

    # SELECTNEARBYWORD - Selects the complete word surrounding or immediately adjacent to the active editor cursor position.
    #
    #   SYNTAX:
    #       w = @SelectNearbyWord()
    #
    #   OUTPUT:
    #       w:      STRING
    #               Any complete word that is immediately adjacent to the current cursor position or surrounds it. Words are
    #               found using regular expression '\w' characters, which include alphanumeric and underscore characters, and
    #               extend left and right relative to the cursor until a non-word character is found (such as a '.' or '\s').
    SelectNearbyWord: ->
        left = @GetCharLeft()
        right = @GetCharRight()
        wordChars = /\w/

        if (wordChars.test(left)) then @ActiveEditor.moveToBeginningOfWord()
        @ActiveEditor.selectToEndOfWord()

        word = @GetSelection()
        if (word.length == 0) || (!wordChars.test(word)) then word = ''
        return word

    # SEARCH - Searches through all open text editors for a particular pattern of text.
    #
    #   SYNTAX:
    #       txt = @Search(pattern)
    #
    #   OUTPUT:
    #       txt:        STRING or NULL
    #                   The first string identified that matches the inputted regular expression pattern.
    #
    #   INPUT:
    #       pattern:    REGEXP
    #                   A regular expression object that by which text will be searched.
    Search: (pattern) ->
        txt = @GetAllText()
        result = txt.match(pattern)
        return result
