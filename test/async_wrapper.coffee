assert = require 'assert'
sinon = require 'sinon'

# These are common tests for functions that wrap a synchronous function and
# call it asynchronously, like lift and tap.
module.exports = (wrapper) ->
  it 'calls the original function asynchronously', (done) ->
    fn = sinon.stub().returns []
    wrapped = wrapper(fn)
    cb = ->
      assert fn.called
      done()
    wrapped cb
    assert (not fn.called)

  it 'calls the original function with args', (done) ->
    args = [1, 2, '3']
    fn = sinon.stub().returns []
    wrapped = wrapper(fn)
    wrapped args..., ->
      assert fn.calledWithExactly args...
      done()
