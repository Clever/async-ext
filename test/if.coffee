_ = require 'underscore'
async = _.extend require('async'), require('../async-ext')
assert = require 'assert'
sinon = require 'sinon'

describe 'if', ->
  _.each [true, false], (condition) ->
    it "calls the correct function if the condition is #{condition}", (done) ->
      spy = sinon.spy (val, cb) -> cb val
      cb = sinon.spy()
      async.if condition,
        (cb) -> spy(true, cb),
        (cb) -> spy(false, cb),
        cb
      assert.deepEqual spy.getCall(0).args, [condition, cb]
      assert spy.calledOnce
      assert.deepEqual cb.getCall(0).args, [condition]
      assert cb.calledOnce
      done()
