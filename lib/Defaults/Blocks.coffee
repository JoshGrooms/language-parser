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

    # Default:
    #     # ACCESSIBILITY - How visible the block's internal contents are to the surrounding world.
    #     Accessibility:      Access.Global
    #     Name:               'Block'
    #     Parent:             null
    #     # SIGNATURE - The symbols that declare and define a block.
    #     Signature:
    #         # CLOSE - The symbol that defines the end of the block.
    #         Close:          'Enclosure.Close.Block'
    #         # CONTENTS - The tag to be applied to the block's contents.
    #         Content:        null
    #         # OPEN - The symbol that defines the beginning of the block.
    #         Open:           'Enclosure.Open.Block'
    #         Prefix:         null
    #         Suffix:         null
    #     Tag:                'source.block'
    #     # VISIBILITY - How visible the block itself is to the surrounding world.
    #     Visibility:         Access.Global


    File:
        Accessibility:          Access.Global
        Name:                   'FileBlock'
        Signature:              null
        Tag:                    'file.definition'
        Visibility:             Access.Global


    Character:
        Close:                  Symbols.Enclosure.Close.Character
        Content:                'Literal.Character.Content'
        Name:                   'Character'
        Open:                   Symbols.Enclosure.Open.Character

    #
    # Class:
    #     Name:               'ClassBlock'
    #     Prefix:             "#{Symbols.Keyword.Type.Class} @1"
    #
    #     Visibility:         Access.Global


    Comment:
        Accessibility:      Access.Restricted
        Close:              Symbols.Enclosure.Close.Comment
        Content:            'Comment.Block.Content'
        Name:               'BlockComment'
        Open:               Symbols.Enclosure.Open.Comment
        Visibility:         Access.Restricted


    String:
        Close:              Symbols.Enclosure.Close.String
        Content:            'Literal.String.Content'
        Name:               'String'
        Open:               Symbols.Enclosure.Open.String


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
