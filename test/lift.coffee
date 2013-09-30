assert = require 'assert'
sinon = require 'sinon'
_ = require 'underscore'
async = _.extend require('async'), require('../async-ext')

describe 'async.lift', ->

  require('./async_wrapper') async.lift

  it 'applies the callback to the results of the original function', (done) ->
    expected = [new Error(), 1, 2, '3']
    fn = sinon.stub().returns expected
    lifted = async.lift(fn)
    lifted (results...) ->
      assert.deepEqual results, expected
      done()
