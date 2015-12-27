# CHANGELOG
# Written by Josh Grooms on 20151220



module.exports =
    Symbols: require('./Defaults/Symbols')
    Lexicon: require('./Defaults/Lexicon')


    # Addition: # Extends operator









    ## RULES ##
    # Functions:
    #     Signature: " {Qualifiers.Open} {Return} {Name} {Arguments} {Qualifiers.Close} "
    #
    #     Arguments:
    #         Close:                  ")"
    #         Open:                   "("
    #
    #
    #     Qualifiers:
    #         Close:
    #             Constant:           "const"
    #             Override:           "override"
    #         Open:
    #             Constant:           "const"
    #             Static:             "static"




    ## SYMBOL TEMPLATE ##
