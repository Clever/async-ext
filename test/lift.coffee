assert = require 'assert'
sinon = require 'sinon'
_ = require 'underscore'
async = _.extend require('async'), require('../async-ext')

describe 'async.lift', ->

  require('./async_wrapper') async.lift

  _.each [
    1
    [1, 2, '3']
    { a: 1 }
    null
  ], (expected) ->
    it 'calls the callback with the result value of the original function', (done) ->
      fn = sinon.stub().returns expected
      async.lift(fn) (err, results...) ->
        assert.ifError err
        assert.deepEqual results, [expected]
        done()

  it 'applies the callback with no results if the original function returns undefined', (done) ->
    fn = sinon.stub().returns undefined
    async.lift(fn) (err, results...) ->
      assert.ifError err
      assert.deepEqual results, []
      done()
