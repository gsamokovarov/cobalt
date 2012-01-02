http = require 'http'
{EventEmitter} = require 'events'

# The pygmentizer object is responsible for the environment needed to
# colorize a chunk of code.
class exports.Pygmentizer extends EventEmitter
  constructor: (options = {}) ->
    EventEmitter.call(this)

    @host = options.host or 'pygmentize.me'
    @port = options.port or 80
    @lexer = options.lexer
    @styles = options.styles
    @formatter = options.formatter
    @options = options.options or {}
    @path = options.path or '/api/formatter/'
    @parser = options.parser or require('querystring').stringify

  # Colorizes the code and returns the highlight and the error status as the
  # first two parameters of the callback, which is called when done.
  pygmentize: (options, callback) ->
    unless options.formatter? or @formatter?
      throw new TypeError 'You must specify a formatter'

    query = @parser
      code: options.code or if typeof options is 'string' then options else null
      lexer: options.lexer or @lexer
      formatter: options.formatter or @formatter
      options: JSON.stringify(options.options or @options)
      styles: JSON.stringify(options.styles or @styles)

    data =
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Length': query.length
      host: options.host or @host
      port: options.port or @port
      path: "#{options.path or @path}#{options.formatter or @formatter}"

    powder = [] # You pygmentize with the powder :)
    request = http.request data, (response) =>
      response.on 'data', (chunk) =>
        dust = String chunk

        @emit 'data', dust
        powder.push dust

      response.on 'end', =>
        highlight = powder.join ''
        error = if response.statusCode isnt 200 then true else false

        @emit 'end', highlight, error
        callback?(highlight, error)

    request.end query

    this

exports.Pygmentizer::colorize = exports.Pygmentizer::pygmentize

# It may be easier for the people to look for a `Cobalt` class in a project
# named `cobalt`. Plus, it's a pygment too :)
exports.Cobalt = exports.Pygmentizer

# Provides more node-ish interface.
exports.createClient = (options = {}) ->
  new exports.Pygmentizer options
