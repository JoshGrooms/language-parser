


exports.Deblank = String::Deblank = (text) ->
    return @replace(/\s*|\r|\n/gm, '')

exports.Contains = String::Contains = (text) ->
    return @indexOf(text) != -1
