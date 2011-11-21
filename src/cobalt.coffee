http = require 'http'
querystring = require 'querystring'
{EventEmitter} = require 'events'

# The pygmentizer object is responsible for the environment needed to
# colorize a chunk of code.
class exports.Pygmentizer extends EventEmitter
  constructor: (options) ->
    EventEmitter.call(this)

    @host = options.host or 'pygmentize.me'
    @port = options.port or 80
    @lexer = options.lexer
    @formatter = options.formatter
    @options = options.options or {}
    @path = options.path or '/as/'
    @type = options.type or 'unencoded'
    @parser = options.parser or Pygmentizer.query.parser[@type]

  # Colorizes the code and returns the highlight and the error status as the
  # first two parameters of the callback, which is called when done.
  pygmentize: (options, callback) ->
    query = @parser
      code: options.code or (typeof options is 'string' ? options : nil)
      lexer: options.lexer or @lexer
      foratter: options.formatter or @formatter
      options: options.options or @options

    data =
      method: 'POST'
      headers:
        'Content-Type': Pygmentizer.query.type[@type]
        'Content-Length': query.length
      host: @host
      port: @port
      path: "#{options.path or @path}#{options.formatter or @formatter}"

    powder = [] # You pygmentize with the powder :)
    request = http.request data, (response) =>
      response.on 'data', (chunk) =>
        dust = String(chunk)

        @emit 'data', dust
        powder.push dust

      response.on 'end', =>
        highlight = powder.join ''
        error = response.statusCode isnt 200 ? true : false

        @emit 'end', highlight, error
        callback?(highlight, error)

    request.end query

    this

exports.Pygmentizer::colorize = exports.Pygmentizer::pygmentize

exports.Pygmentizer.query =
  type:
    json: 'application/json'
    unencoded: 'application/x-www-form-urlencoded'
  parser:
    json: (data) -> JSON.stringify(data)
    unencoded: (data) -> querystring.stringify(data)

# Provide more node-ish interface.
exports.createClient = (options) ->
  new Pygmentizer options

