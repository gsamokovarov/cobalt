http = require 'http'
{stringify} = require 'querystring'

# Helper HTTP POST method.
http.post = (options, callback) ->
  options.method = 'POST'
  query ?= stringify options.query
  options.headers ?=
    'Content-Type': 'application/x-www-form-urlencoded'
    'Content-Length': query.length

  request = http.request options, callback
  request.end(query if query)

# Builds the URL path to the formatter.
pathFor = (formatter) ->
  "/as/#{formatter}"

exports.config =
  host: 'pygmentize.it'
  port: '80'

exports.colorize = (code, lexer, formatter, options = {}) ->
  data =
    host: exports.config.host
    port: exports.config.port
    path: pathFor(formatter)
    query:
      {code, lexer, formatter, options}
  
  http.post data, (response) ->
    naughty = response.statusCode isnt 200

    collected = []
    response.on 'data', (chunk) ->
      collected.push chunk.toString()

    response.on 'end', ->
      throw new Error collected if naughty
      collected.join ''

# Alias it to something funnier.
exports.pygmentize = exports.colorize

