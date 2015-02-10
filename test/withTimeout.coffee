_ = require 'underscore'
assert = require 'assert'
sinon = require 'sinon'
async = _.extend require('async'), require('../async-ext')

describe 'async.withTimeout', ->

  it 'calls the original function', (done) ->
    fn = sinon.stub().yieldsAsync()
    fn_with_timeout = async.withTimeout 1, fn
    fn_with_timeout ->
      assert fn.called
      done()

  it 'calls the original function with args', (done) ->
    args = [1, 2, '3']
    fn = sinon.stub().yieldsAsync()
    fn_with_timeout = async.withTimeout 1, fn
    fn_with_timeout args..., ->
      assert fn.calledWith args...
      done()

  it 'calls the callback with results of the original function', (done) ->
    expected = [1, 2, '3']
    fn = (cb) -> setImmediate -> cb expected...
    fn_with_timeout = async.withTimeout 1, fn
    fn_with_timeout (results...) ->
      assert.deepEqual results, expected
      done()

  it 'calls the callback with an error if the function does not call its callback before the timeout', (done) ->
    fn = (cb) -> setTimeout (-> cb null, 'success'), 100
    fn_with_timeout = async.withTimeout 10, fn
    fn_with_timeout (err, results...) ->
      assert err?, 'Expected an error'
      assert.equal err.message, "A function wrapped by async.withTimeout timed out after 10ms"
      assert.deepEqual results, []
      done()
