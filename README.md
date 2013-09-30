# async-ext

This module consists of a set of functions to extend the capabilities of the Node.js [async](https://github.com/caolan/async) library.

## Installation

    npm install async
    npm install async-ext

## Usage

The easiest way to use async-ext is to extend the async object with the new functions. Here's how you might do it with Underscore:

```coffeescript
_ = require 'underscore'
async = _.extend require('async'), require('async-ext')
```

## Functions

### async.lift(fun)

"Lifts" a regular old synchronous function into the wondrous world of async.

Why would you ever want to make *more* functions async then you have to? Well, imagine you were using `async.waterfall` to get fetch some data asynchronously, transform it synchronously, and send it off somewhere else asynchronously. Your code might look like this:

```coffeescript
async.waterfall [
    fetchData
    (data, cb) ->
        [err, data] = transform data
        if err?
            setImmediate -> cb err
        else
            sendData data, cb
], errHandler
```

With `async.lift`, you can write that like this:

```coffeescript
async.waterfall [
    fetchData
    async.lift (data) -> transform data
    sendData
], errHandler
```

`async.lift` takes a synchronous function that returns an array where the first argument is an error and the rest of the arguments are results. It returns an asynchronous version of that function that applies its callback to the array returned by the original function.

Some notes:
- The input function may accept any number of arguments - the resulting function will as well.
- The error result may be null.
- The resulting function will call its callback using `setImmediate`, to prevent [releasing the Zalgo](http://blog.izs.me/post/59142742143/designing-apis-for-asynchrony).

### async.do(fun)

Lifts a synchronous function but ignores its return value, instead passing along whatever arguments it receives. This can be useful for inserting functions into pipelines when you only care about their side effects.

For example, we can insert some logging statements into our previous waterfall without having to modify any of the preexisting code:

```coffeescript
async.waterfall [
    fetchData
    async.lift (data) -> transform data
    async.do (data) -> console.log 'got some data', data
    sendData # is called with the same data as the logging function
    async.do -> console.log 'done sending!'
], errHandler
```

### async.once(fun)

TODO
