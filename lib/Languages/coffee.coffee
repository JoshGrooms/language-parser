# CHANGELOG
# Written by Josh Grooms on 20151228



module.exports =

    IsPythonic:         true
    IsStaticallyTyped:  false


    Symbols:
        Enclosure:
            Close:
                Block:          [ "}", "@Outdent" ]
                # Comment:        "###"
                Character:      ""
                Comment:
                    Block:      "###"
                    # Inline:     "\n"
                String:         [ '\'', "\"" ]
            Open:
                Block:          [ "{", "@Indent" ]
                # Comment:        "###"
                Character:      ""
                Comment:
                    Block:      "###"
                    # Inline:     "#"
                String:         [ '\'', "\"" ]

        Operator:
            Logical:
                Existential:    "?"
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
                Unless:         "unless"
                When:           "when"

            Literal:
                Undefined:      "undefined"

            Operator:
                Instance:       "instanceof"

            Permission:         ""

            Preprocessor:
                Import:         "require"

            Qualifer:           ""

        Type:
            Primitive:
                Array:          "Array"
                Boolean:        "Boolean"
                Date:           "Date"
                Function:       "Function"
                Number:         "Number"
                Object:         "Object"
                Regex:          "RegExp"
                String:         "String"



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
        Expression:     null
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
