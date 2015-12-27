

{ GrammarRegistry } = require('first-mate')



module.exports = class DynamicRegistry extends GrammarRegistry

    constructor: -> super()


    createToken: (value, scopes) -> console.log("createToken was called")

    selectGrammar: (filePath, fileContents) ->
        console.log("selectGrammar was called")
    getGrammarScore: (grammar, filePath, contents) ->
        console.log("getGrammarScore was called")
    getGrammarPathScore: (grammar, filePath) ->
        console.log("getGrammarPathScore was called")
    grammarMatchesContents: (grammar, contents) ->
        console.log("grammarMatchesContents was called")
    grammarOverrideForPath: (filePath) ->
        console.log("grammarOverridesForPath was called")
    setGrammarOverrideForPath: (filePath, scopeName) ->
        console.log("setGrammarOverridesForPath was called")
    clearGrammarOverrideForPath: (filePath) ->
        console.log("clearGrammarOverridesForPath was called")
    clearGrammarOverrides: ->
        console.log("clearGrammarOverrides was called")


# _ = require 'underscore-plus'
# {Emitter} = require 'event-kit'
# FirstMate = require 'first-mate'
# Token = require './token'
# fs = require 'fs-plus'
#
# PathSplitRegex = new RegExp("[/.]")
#
#
# module.exports =
# class GrammarRegistry extends FirstMate.GrammarRegistry
#   constructor: ({@config}={}) ->
#     super(maxTokensPerLine: 100)
#
  # createToken: (value, scopes) -> new Token({value, scopes})
  #
  # selectGrammar: (filePath, fileContents) ->
  #   bestMatch = null
  #   highestScore = -Infinity
  #   for grammar in @grammars
  #     score = @getGrammarScore(grammar, filePath, fileContents)
  #     if score > highestScore or not bestMatch?
  #       bestMatch = grammar
  #       highestScore = score
  #   bestMatch

  # Extended: Returns a {Number} representing how well the grammar matches the
  # `filePath` and `contents`.
  # getGrammarScore: (grammar, filePath, contents) ->
  #   return Infinity if @grammarOverrideForPath(filePath) is grammar.scopeName
  #
  #   contents = fs.readFileSync(filePath, 'utf8') if not contents? and fs.isFileSync(filePath)
  #
  #   score = @getGrammarPathScore(grammar, filePath)
  #   if score > 0 and not grammar.bundledPackage
  #     score += 0.25
  #   if @grammarMatchesContents(grammar, contents)
  #     score += 0.125
  #   score
  #
  # getGrammarPathScore: (grammar, filePath) ->
  #   return -1 unless filePath
  #   filePath = filePath.replace(/\\/g, '/') if process.platform is 'win32'
  #
  #   pathComponents = filePath.toLowerCase().split(PathSplitRegex)
  #   pathScore = -1
  #
  #   fileTypes = grammar.fileTypes
  #   if customFileTypes = @config.get('core.customFileTypes')?[grammar.scopeName]
  #     fileTypes = fileTypes.concat(customFileTypes)
  #
  #   for fileType, i in fileTypes
  #     fileTypeComponents = fileType.toLowerCase().split(PathSplitRegex)
  #     pathSuffix = pathComponents[-fileTypeComponents.length..-1]
  #     if _.isEqual(pathSuffix, fileTypeComponents)
  #       pathScore = Math.max(pathScore, fileType.length)
  #       if i >= grammar.fileTypes.length
  #         pathScore += 0.5
  #
  #   pathScore

  # grammarMatchesContents: (grammar, contents) ->
  #   return false unless contents? and grammar.firstLineRegex?
  #
  #   escaped = false
  #   numberOfNewlinesInRegex = 0
  #   for character in grammar.firstLineRegex.source
  #     switch character
  #       when '\\'
  #         escaped = not escaped
  #       when 'n'
  #         numberOfNewlinesInRegex++ if escaped
  #         escaped = false
  #       else
  #         escaped = false
  #   lines = contents.split('\n')
  #   grammar.firstLineRegex.testSync(lines[0..numberOfNewlinesInRegex].join('\n'))
  #
  # grammarOverrideForPath: (filePath) ->
  #   @grammarOverridesByPath[filePath]
  #
  # setGrammarOverrideForPath: (filePath, scopeName) ->
  #   if filePath
  #     @grammarOverridesByPath[filePath] = scopeName
  #
  #
  # clearGrammarOverrideForPath: (filePath) ->
  #   delete @grammarOverridesByPath[filePath]
  #   undefined
  #
  # clearGrammarOverrides: ->
  #   @grammarOverridesByPath = {}
  #   undefined
