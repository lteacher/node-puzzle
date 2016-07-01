assert = require 'assert'
fs = require 'fs'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count quoted characters within a longer string', (done) ->
    input = 'this text has a random "bunch of words in the middle" of it'
    expected = words: 8, lines: 1
    helper input, expected, done

  it 'should handle the first fixture', (done) ->
    fs.readFile 'test/fixtures/1,9,44.txt', 'utf8', (err, data) ->
      if err then throw err

      input = data
      expected = words: 9, lines: 1
      helper input, expected, done

  it 'should handle the second fixture', (done) ->
    fs.readFile 'test/fixtures/3,7,46.txt', 'utf8', (err, data) ->
      if err then throw err

      input = data
      expected = words: 7, lines: 3
      helper input, expected, done

  it 'should handle the third fixture', (done) ->
    fs.readFile 'test/fixtures/5,9,40.txt', 'utf8', (err, data) ->
      if err then throw err

      input = data
      expected = words: 9, lines: 5
      helper input, expected, done

  it 'should not count words with invalid characters', (done) ->
    input = 'this text h@s som% messed up ch*rz'
    expected = words: 4, lines: 1
    helper input, expected, done

  it 'should count words with invalid characters if they are in quotes', (done) ->
    input = 'this text also "h@s" "som%" messed up "ch*rz", but its "ok!"'
    expected = words: 11, lines: 1
    helper input, expected, done
