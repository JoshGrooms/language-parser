# CHANGELOG
# Written by Josh Grooms on 20151222



exports.Operators = Operators =

    Default:
        Arity:                  Arities.Binary
        Associativity:          Associativities.Left
        Name:                   'Operator'
        Overloadable:           false
        Priority:               null
        Signature:              null
        Tag:                    null
        Translation:            null


    Addition:
        Arity:                  Arities.Binary
        Associativity:          Associativies.Left
        Name:                   'BinaryAddition'
        Overloadable:           true
        Priority:               6
        Signature:              "@X {Symbols.Operator.Math.Addition} @Y"
        Tag:                    'operation.addition'
        Translation:            null



    Decrement:
        Prefix:
            Arity:              Arities.Unary
            Associativity:      Associativities.Right
            Name:               'DecrementPrefix'
            Overloadable:       false
            Priority:           3
            Signature:          "{Symbols.Operator.Math.Decrement}@X"
            Tag:                ''
            Translation:        null

        Suffix:
            Arity:              Arities.Unary
            Associativity:      Associativities.Left
            Name:               'DecrementSuffix'
            Overloadable:       false
            Priority:           2
            Signature:          "@X{Symbols.Operator.Math.Decrement}"
            Translation:        null

    Increment:
        Prefix:
            Arity:              Arities.Unary
            Associativity:      Associativities.Right
            Name:               'IncrementPrefix'
            Overloadable:       false
            Priority:           3
            Signature:          "Symbols.Operator.Math.Increment@X"
            Translation:        null

        Suffix:
            Arity:              Arities.Unary
            Associativity:      Associativities.Left
            Name:               'IncrementSuffix'
            Overloadable:       false
            Priority:           2
            Signature:          "@X{Symbols.Operator.Math.Increment}"
            Translation:        null


    Subtraction:
        Name:                   'BinarySubtraction'
        Overloadable:           true
        Priority:               6
        Signature:              '@<X>@ @|Symbols.Operator.Math.Subtraction|@ @Y'
        Tag:                    'operation.subtraction'
        Translation:            null
