# CHANGELOG
# Written by Josh Grooms on 20160104


assign      = 'Symbols.Operator.Math.Assigment'
groupClose  = 'Symbols.Enclosure.Close.Group'
groupOpen   = 'Symbols.Enclosure.Open.Group'
blockClose  = 'Symbols.Enclosure.Close.Block'
blockOpen   = 'Symbols.Enclosure.Open.Block'
separator   = 'Operator.Separator'


Rule:
    Contains:           0
    CannotContain:      1
    CannotFollow:       2
    CannotPrecede:      3
    Follows:            4
    Name:               5
    Precedes:           6
    Tag:                7



# PATTERN LANGUAGE
#
#   [ ] -   Brackets contain a selector and represent a particular token that is required to be present in some source code
#           text that is being matched with it.
#
#   ( ) -   Parentheses indicate a grouping of one or more other elements that may or may not be present in some text.
#
#   < > -   These enclosures indicate the presence of one or more tokens that are to be tagged.
module.exports =

    Class:
        _Close:              blockClose
        _Open:               blockOpen
        _Prefix:             "[Keyword.Type.Class] <Name> ( [Extends] <Parent> ([Separator] <Parent>) )"
        _Tag:                "Types.Class"
        _Content:
            Property:        "<Name> [Operator.Assignment]"
            Method:
                _Close:      blockClose
                _Open:       blockOpen
                _Prefix:
                    """
                        <Output> <Name> [Open.Group]
                        ( <Input.Argument> ([Assignment] <DefaultValue>) ([Separator]) )
                        [Close.Group]
                    """

    Enumeration:
        _Close:              blockClose
        _Open:               blockOpen
        _Prefix:             "[Keyword.Type.Enumeration] <Type>"
        _Tag:               "Types.Enumeration"
        _Content:
            Enumerator:     "<Name> [Operator.Assignment]"
    #
    # Structure:
    #     _Close:              blockClose
    #     _Open:               blockOpen
    #     _Prefix:             "[Keyword.Type.Structure] <Name>"
    #     _Tag:               "Types.Structure"
    #
    #     _Content:
    #         Field:          "<Name> [Operator.Assignment]"
    #         Method:         "<Output> <Name> [Open.Group] (<Input> ([Separator] <Input>)*)? [Close.Group]"
