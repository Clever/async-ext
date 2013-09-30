module.exports =

  lift: (f) ->
    (args..., cb) -> setImmediate ->
      [err, res...] = f args...
      cb err, res...

  do: (f) ->
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
