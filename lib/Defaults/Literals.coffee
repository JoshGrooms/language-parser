# CHANGELOG
# Written by Josh Grooms on 20151229



module.exports =


    Character:
        Close:              'Symbols.Enclosure.Close.Character'
        Content:            'Literal.Character.Content'
        Name:               'CharacterLiteral'
        Open:               'Symbols.Enclosure.Open.Character'

    Comment:
        Block:
            Close:          'Symbols.Enclosure.Close.Comment.Block'
            Content:        'Comment.Block.Content'
            Name:           'BlockComment'
            Open:           'Symbols.Enclosure.Open.Comment.Block'

        Inline:
            Close:          'Symbols.Enclosure.Close.Comment.Inline'
            Content:        'Comment.Inline.Content'
            Name:           'InlineComment'
            Open:           'Symbols.Enclosure.Open.Comment.Inline'

    String:
        Close:              'Symbols.Enclosure.Close.String'
        Content:            'Literal.String.Content'
        Name:               'StringLiteral'
        Open:               'Symbols.Enclosure.Open.String'
