fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  stream = _getReadStream "#{__dirname}/../data/geo.txt"
  counter = 0

  rl = readline.createInterface { input: stream }

  rl.on 'line', (input) -> counter += _parseLine countryCode, input

  stream.on 'end', () -> cb null, counter

# Get ReadStream for the file
_getReadStream = (file) -> fs.createReadStream file

# Get the counter increment for the given line
_parseLine = (code,line) ->
  [min,max,range,country] = line.split '\t'
  return if country == code then +max - +min else 0
