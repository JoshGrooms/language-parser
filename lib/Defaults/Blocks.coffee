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
        _Accessibility:          Access.Global
        # CLOSE - The symbol that defines the end of the block.
        _Close:                  'Symbols.Enclosure.Close.Block'
        # CONTENTS - The tag to be applied to the block's contents.
        _Content:                null
        _Name:                   'Block'
        # OPEN - The symbol that defines the beginning of the block.
        _Open:                   'Symbols.Enclosure.Open.Block'
        _Parent:                 null

        _Prefix:                 null

        _Suffix:                 null

        _Tag:                    'source.block'
        # VISIBILITY - How visible the block itself is to the surrounding world.
        _Visibility:             Access.Global


    File:
        _Accessibility:          Access.Global
        _Name:                   'FileBlock'
        _Tag:                    'file.definition'
        _Visibility:             Access.Global


    Character:
        _Close:                  'Symbols.Enclosure.Close.Character'
        _Content:                'Literal.Character.Content'
        _Name:                   'Character'
        _Open:                   'Symbols.Enclosure.Open.Character'



    Comment:
        _Accessibility:          Access.Restricted
        _Close:                  'Symbols.Enclosure.Close.Comment.Block'
        _Content:                'Comment.Block.Content'
        _Name:                   'BlockComment'
        _Open:                   'Symbols.Enclosure.Open.Comment.Block'
        _Visibility:             Access.Restricted

        # Inline:
        #     _Accessibility:      Access.Restricted
        #     Close:              'Symbols.Enclosure.Close.Comment.Inline'
        #     Content:            'Comment.Inline.Content'
        #     Name:               'InlineComment'
        #     Open:               'Symbols.Enclosure.Open.Comment.Inline'
        #     Visibility:         Access.Restricted

    Group:
        _Accessibility:          Access.Global
        _Close:                  'Symbols.Enclosure.Close.Group'
        _Name:                   'Group'
        _Open:                   'Symbols.Enclosure.Open.Group'
        _Visibility:             Access.Global

    String:
        _Close:                  'Symbols.Enclosure.Close.String'
        _Content:                'Literal.String.Content'
        _Name:                   'String'
        _Open:                   'Symbols.Enclosure.Open.String'
