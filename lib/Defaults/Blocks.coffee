# CHANGELOG
# Written by Josh Grooms on 20151222

{
    Access,
    Arities,
    Associativities,
    Scopes,
    TypeSystems,
    Visibilities
} = require('./Enumerations')

Symbols = require('./Symbols')


# BLOCKS - Language entities that are bound by enclosures.
#
#    Blocks are identified by their signatures.
module.exports =

    Default:
        # ACCESSIBILITY - How visible the block's internal contents are to the surrounding world.
        Accessibility:          Access.Global
        # CLOSE - The symbol that defines the end of the block.
        Close:                  'Symbols.Enclosure.Close.Block'
        # CONTENTS - The tag to be applied to the block's contents.
        Content:                null
        Name:                   'Block'
        # OPEN - The symbol that defines the beginning of the block.
        Open:                   'Symbols.Enclosure.Open.Block'
        Parent:                 null

        Prefix:                 null

        Suffix:                 null

        Tag:                    'source.block'
        # VISIBILITY - How visible the block itself is to the surrounding world.
        Visibility:             Access.Global


    File:
        Accessibility:          Access.Global
        Name:                   'FileBlock'
        Tag:                    'file.definition'
        Visibility:             Access.Global


    Character:
        Close:                  'Symbols.Enclosure.Close.Character'
        Content:                'Literal.Character.Content'
        Name:                   'Character'
        Open:                   'Symbols.Enclosure.Open.Character'


    Class:
        Accessibility:          Access.Global
        Close:                  'Symbols.Enclosure.Close.Block'
        Name:                   'ClassBlock'
        Open:                   'Symbols.Enclosure.Open.Block'
        Prefix:                 /class\s+@Type/
        Visibility:             Access.Global

    Comment:
        Block:
            Accessibility:      Access.Restricted
            Close:              'Symbols.Enclosure.Close.Comment.Block'
            Content:            'Comment.Block.Content'
            Name:               'BlockComment'
            Open:               'Symbols.Enclosure.Open.Comment.Block'
            Visibility:         Access.Restricted

        Inline:
            Accessibility:      Access.Restricted
            Close:              'Symbols.Enclosure.Close.Comment.Inline'
            Content:            'Comment.Inline.Content'
            Name:               'InlineComment'
            Open:               'Symbols.Enclosure.Open.Comment.Inline'
            Visibility:         Access.Restricted

    Group:
        Accessibility:          Access.Global
        Close:                  'Symbols.Enclosure.Close.Group'
        Name:                   'Group'
        Open:                   'Symbols.Enclosure.Open.Group'
        Visibility:             Access.Global

    String:
        Close:                  'Symbols.Enclosure.Close.String'
        Content:                'Literal.String.Content'
        Name:                   'String'
        Open:                   'Symbols.Enclosure.Open.String'


    # Function:
    #     Accessibility:      Access.Restricted
    #     Name:               "FunctionBlock"
    #     Prefix:             ""
    #     Visibility:         Access.Global
    #
    # Struct:
    #     Accessibility:      Access.Global
    #     Name:               'StructureBlock'
    #     Signature:          "#{Symbols.Keyword.Type.Struct} @1"
    #     Visibility:         Access.Global
    #
    #
    # Loop:
    #     For:
    #         Accessibility:  Access.Global
    #         Name:           "ForLoopBlock"
    #         Prefix:         "#{Symbols.Keyword.Control.For}"
    #         Visibility:     Access.Internal
    #
    #
    # String:
    #
    #     Name:               "String"
    #     Signature:
    #         Close:          Symbols.Enclosure.Close.String
    #         Content:        'literal.string.content'
    #         Open:           Symbols.Enclosure.Open.String
