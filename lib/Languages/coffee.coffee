# CHANGELOG
# Written by Josh Grooms on 20151228



module.exports =

    FileExtension:              '.coffee'


    IsPythonic:         true
    IsStaticallyTyped:  false


    Symbols:
        Enclosure:
            Close:
                Block:          [ "}", "@Outdent" ]
                Comment:        "###"
                Character:      ""
                String:         [ '\'', "\"" ]
            Open:
                Block:          [ "{", "@Indent" ]
                Comment:        "###"
                Character:      ""
                String:         [ '\'', "\"" ]

        Operator:
            Logical:
                Existential:    "?"
            Symbol:
                Comment:        "#"
                Function:       [ "->", "=>" ]
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




    SpecialDefinitions:
        Arguments:      null
        Expression:     null
        Indent:         null
        Name:           null
        Outdent:        null
        Type:           null
        Word:           null
