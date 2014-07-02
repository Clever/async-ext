_ = require 'underscore'
async = require 'async'

_.mixin mapValues: (obj, f) -> _.object _.keys(obj), _.map obj, f

module.exports =

  lift: (f) ->
    (args..., cb) -> setImmediate ->
      try results = f args...
      catch e then return cb e
      if _.isUndefined results then cb() else cb null, results

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

  if: (condition, then_fn, else_fn, cb) ->
    (if condition then then_fn else else_fn) cb

  mapValues: (obj, f, cb) ->
    tasks = _.mapValues obj, (val, key) -> (cb_p) -> f val, key, cb_p
    async.parallel tasks, (err, res) -> cb err, (res unless err?)
