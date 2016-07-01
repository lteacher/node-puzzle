stream = require 'stream'

# Just for fun implement my own transformer instead of using through2
class StringTransformer extends stream.Transform
  # Don't much fancy this syntax here
  words: 0, lines: 0, bytes: 0, characters: 0

  constructor: -> super objectMode: true
  _parse: (data) ->
    str = data.toString()

    # To be perfectly fair, I saw this regex and its really perfect which disrupted
    # my whole solution as I was building a regex as well, would be best if
    # the submissions were not in the forks and instead submitted.
    wordRegx = /\s(?=.*".*")|(?:[a-z])(?=[A-Z])|\s+(?!.*")/

    @bytes += data.length

    # Probably not correct since fixture txt files seem to indicate the length
    # But they include newlines and don't consider crlf vs lf which
    # can happen on git pull to windows if set. Perhaps a more appropriate
    # value would be the actual number of chars for all word tokens
    @characters += str.length

    # Must have at least some content before line and filter off ''
    split = str.split(/(.+)(?:\n|\r\n)/gm).filter Boolean

    @lines += split.length;

    # For each line
    for line in split # count the number of words and ignore invalid
      @words += line.trim().split(wordRegx).filter(@_wordFilter).length

  _wordFilter: (word) ->
    r = !word.startsWith('"') and word.search(/[^a-zA-Z0-9]/) >= 0
    return !r # Return inverse: doesn't start with quote and contains invalid

  _transform: (data, enc, cb) ->
    @_parse data
    cb()

  _flush: (cb) ->
    @push {@words, @lines}
    cb()

module.exports = StringTransformer
