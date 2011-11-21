{exec} = require 'child_process'
puts = console.log

task 'compile', 'Compiles the project to JS.', (options) ->
  puts 'Compiling...'

  options.to ?= 'lib/'
  sh "coffee -o #{options.to} -c src/"

task 'test', 'Tests the project', ->
  puts "Testing..."

  invoke 'compile'
  sh "coffee test/cobalt.coffee"

task 'self', 'pygmentize self', ->
  invoke 'compile'

  {Pygmentizer} = require './lib/cobalt'
  fs = require 'fs'

  fs.readFile __filename, (err, data) ->
    pyg = new Pygmentizer
      host: 'localhost'
      port: '8080'
      lexer: 'coffee-script'
      formatter: 'terminal256'
      type: 'json'
    pyg.pygmentize String(data), (highlight, error) ->
      puts highlight, error

sh = (cmd) ->
  attach = (fn) ->
    if sh.last
      sh.last.on 'exit', (code) ->
        fn() if code is 0
    else
      sh.last = fn()

  attach ->
    exec cmd, (status, output, error) ->
      puts [output, error].join '\n' if output or error

process.on 'SIGHUP', -> sh.last?.kill()

