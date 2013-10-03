_ = require 'underscore'
module.exports =

  lift: (f) ->
    (args..., cb) -> setImmediate ->
      try results = f args...
      catch e then return cb e
      results = if _.isArray results then results else [results]
      cb null, results...

  tap: (f) ->
    (args..., cb) -> setImmediate ->
      try f args...
      catch e then return cb e
      cb null, args...

  once: (f) ->
    saved = null
    called_f = false
    cbs = []
    (args..., cb) -> 
      switch
        when called_f and saved?
          setImmediate -> cb saved...
        when called_f and not saved?
          cbs.push cb
        when not called_f
          called_f = true
          f args..., (results...) ->
            saved = results
            _.each [cb].concat(cbs), (cb) -> cb results...
