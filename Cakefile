{exec} = require 'child_process'
puts = console.log

task 'compile', 'Compiles the project to JS.', (options) ->
  puts 'Compiling...'

  options.to ?= 'lib/'
  run "coffee -o #{options.to} -c src/"

task 'test', 'Tests the project', ->
  puts "Testing..."

  invoke 'compile'
  run "coffee test/basic.coffee"

task 'ping', ->
  invoke 'compile'

  cobalt = require './lib/cobalt'
  cobalt.config =
    host: 'localhost', port: '8080'
  puts cobalt.colorize 'print "Hello World!"', 'ruby', 'html'

run = (cmd) ->
  attach = (fn) ->
    if run.last then run.last.on 'exit', fn else run.last = fn()

  attach ->
    exec cmd, (status, output, error) ->
      console.log [output, error].join '\n' if output or error

process.on 'SIGHUP', -> run.last?.kill()

