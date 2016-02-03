# CHANGELOG
# Written by Josh Grooms on 20151221



module.exports =
    # ENCLOSURE - A listing of common programming language enclosure characters
    Enclosure:
        Close:
            Block:                          "}"
            Character:                      "\'"
            Comment:                        "*/"
            Group:                          ")"
            Index:                          "]"
            String:                         "\""
        Open:
            Block:                          "{"
            Character:                      "\'"
            Comment:                        "/*"
            Group:                          "("
            Index:                          "["
            String:                         "\""

    # OPERATOR - A listing of common character operator symbols.
    Operator:
        Bitwise:
            And:                            "&"
            AndAssignment:                  "&="
            Or:                             "|"
            OrAssignment:                   "|="
            ShiftLeft:                      "<<"
            ShiftLeftAssignment:            "<<="
            ShiftRight:                     ">>"
            ShiftRightAssignment:           ">>="

        Index:
            Member:                         "."
            Resolution:                     "::"

        Logical:
            And:                            "&&"
            Equality:                       "=="
            GreaterThan:                    ">"
            GreaterThanEquality:            ">="
            LessThan:                       "<"
            LessThanEquality:               "<="
            Not:                            "!"
            NotEquality:                    "!="
            Or:                             "||"

        Math:
            Addition:                       "+"
            AdditionAssignment:             "+="
            Assignment:                     [ "=", ":" ]
            Division:                       "/"
            DivisionAssignment:             "/="
            Decrement:                      "--"
            Increment:                      "++"
            Modulo:                         "%"
            ModuloAssignment:               "%="
            Multiplication:                 "*"
            MultiplicationAssignment:       "*="
            Subtraction:                    "-"
            SubtractionAssignment:          "-="

        Symbol:
            Comment:                        "//"
            Continuation:                   "\\"
            Escape:                         "\\"
            LineTerminator:                 ";"
            Preprocessor:                   "#"
            Separator:                      ","
            Variadic:                       "..."
