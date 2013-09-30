assert = require 'assert'
sinon = require 'sinon'
_ = require 'underscore'
async = _.extend require('async'), require('../async-ext')

describe 'async.lift', ->

  it 'calls the original function asynchronously', (done) ->
    fn = sinon.stub().returns []
    lifted = async.lift(fn)
    cb = ->
      assert fn.called
      done()
    lifted cb
    assert (not fn.called)

  it 'calls the original function with args', (done) ->
    args = [1, 2, '3']
    fn = sinon.stub().returns []
    lifted = async.lift(fn)
    lifted args..., ->
      assert fn.calledWithExactly args...
      done()

  it 'applies the callback to the results of the original function', (done) ->
    expected = [new Error(), 1, 2, '3']
    fn = sinon.stub().returns expected
    lifted = async.lift(fn)
    lifted (results...) ->
      assert.deepEqual results, expected
      done()
