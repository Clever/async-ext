module.exports =

  lift: (f) ->
    (args..., cb) -> setImmediate ->
      results = f args...
      try [err, res...] = results
      catch e then throw new Error 'async.lift expected function to return an array'
      cb err, res...

  tap: (f) ->
    (args..., cb) -> setImmediate ->
      f args...
      cb err, args...

  once: (f) ->
    saved = null
    called = false
    cbs = []
    (args..., cb) -> 
      switch
        when called and saved?
          cb saved...
        when called and not saved?
          cbs.push cb
        when not called
          called = true
          cbs.push cb
          f args..., (results...) ->
            saved = results
            cb results... for cb in cbs
