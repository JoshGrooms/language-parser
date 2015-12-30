# CHANGELOG
# Written by Josh Grooms on 20151226



module.exports =
    # KEYWORD - A listing of common programming language keywords
    Keyword:
        # CONTROL - Keywords that influence the flow of a program.
        Control:
            Break:                          "break"
            Case:                           "case"
            Catch:                          "catch"
            Continue:                       "continue"
            Do:                             "do"
            Else:                           "else"
            For:                            "for"
            ForEach:                        "foreach"
            If:                             "if"
            Return:                         "return"
            Switch:                         "switch"
            Then:                           "then"
            Try:                            "try"
            While:                          "while"

        # OPERATOR - Keywords that behave like operators.
        Operator:
            And:                            "and"
            Delete:                         "delete"
            New:                            "new"
            Or:                             "or"
            Size:                           "sizeof"
            Type:                           "typeof"

        # PERMISSION - Keywords that modify the accessibility of an entity.
        Permission:
            Private:                        "private"
            Protected:                      "protected"
            Public:                         "public"

        Preprocessor:
            Define:                         "define"
            Else:                           "elif"
            If:                             "ifdef"
            Import:                         "include"

        # QUALIFIER - Keywords that can be attached to entities in order to modify their meaning.
        Qualifier:
            Constant:                       "const"
            Mutable:                        "mutable"
            Override:                       "override"
            Static:                         "static"
            Volatile:                       "volatile"

        # TYPE - Keywords that denote the existence of some kind of entity.
        Type:
            Base:                           [ "base", "super" ]
            Class:                          "class"
            Enumeration:                    "enum"
            Extends:                        [ "extend", "extends" ]
            Namespace:                      "namespace"
            Structure:                      "struct"
            This:                           [ "self", "this" ]

    # LITERAL - A listing of natively available literal values.
    Literal:
        Boolean:
            False:                          "false"
            True:                           "true"
        Null:                               "null"

    # TYPE - A listing of natively available entity types.
    Type:
        Primitive:
            Character:                      "char"
            Double:                         "double"
            Float:                          "float"
            Integer:                        "int"
            Long:                           "long"
            Short:                          "short"
            String:                         "string"
            Void:                           "void"

    WhiteSpace:                             [ " ", "\t" ]

    # Word - A listing of characters that make up ordinary code words or variable names.
    Word:
        Lowercase:  ["_","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        Number:     ["0","1","2","3","4","5","6","7","8","9"]
        Uppercase:  ["_","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

        Open:
            [
                "_","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
            ]
        Close:
            [
                "_","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                "0","1","2","3","4","5","6","7","8","9"
            ]
