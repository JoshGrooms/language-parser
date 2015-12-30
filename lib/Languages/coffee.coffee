# CHANGELOG
# Written by Josh Grooms on 20151228



module.exports =

    IsPythonic:         true
    IsStaticallyTyped:  false






    # Blocks:
    #     Group:
    #         Open:       "Symbols.Enclosure.Open.Group"
    #         Content:    "Variable.Argument.Input"
    #         Close:      "Symbols.Enclosure.Close.Group"

    Symbols:
        Enclosure:
            Close:
                Block:          [ "}", "@Outdent" ]
                # Comment:        "###"
                Comment:
                    Block:      "###"
                    # Inline:     "\n"
            Open:
                Block:          [ "{", "@Indent" ]
                # Comment:        "###"
                Comment:
                    Block:      "###"
                    # Inline:     "#"

        Operator:
            Symbol:
                Comment:        "#"
                Preprocessor:   ""
                This:           "@"

    Words:
        Keyword:
            Control:
                By:             "by"
                ForEach:        ""
                Finally:        "finally"
                In:             "in"
                Loop:           "loop"
                When:           "when"

            Preprocessor:
                Import:         "require"


    Declarations:
        Class:      /class\s+@Name/
        Function:   /@Name\s*\=\s*(?:\(@Arguments\))?\s*[\-\=]\>/
        Method:     /@Name\s*\:\s*(?:\(@Arguments\))?\s*[\-\=]\>/



    # Structures:
    #
    #     Class:
    #         Declaration:
    #             /class\s+(\w+)/
    #
    #         Definition:
    #
    #         Member:
    #         Method:


    SpecialDefinitions:
        Arguments:      null
        Indent:         null
        Name:           null
        Outdent:        null
        Type:           null
        Word:           null





    Function:

        Declaration:
            Signature:
                [
                    "@Word : ( @Arguments ) ->"
                    "@Word : ( @Arguments ) =>"
                    "@Word : ->"
                    "@Word : =>"
                ]

        Definition: null

        Invokation:
            Signature:
                [
                    "@Word ( @Arguments )",
                    "@Word @Arguments \n"
                ]


    Symbol:
        Name:       ""
        Signature:  ""
