# CHANGELOG
# Written by Josh Grooms on 20151228



module.exports =

    Symbols:
        Comment:            "#"
        Enclosure:
            Close:
                Block:      [ "}", "@Outdent" ]
                Comment:    "###"
            Open:
                Block:      [ "{", "@Indent" ]
                Comment:    "###"


    IsPythonic:         true
    IsStaticallyTyped:  false
