{exec} = require 'child_process'
puts = console.log

mocha = (args...) ->
  sh "PATH=$PATH:node_modules/mocha/bin mocha #{args.join ' '}"

task 'compile', 'Compiles the project to JS.', ->
  puts 'Compiling...'

  sh "coffee -o lib/ -c src/"
  sh "coffee -o test/lib/ -c test/src/"

task 'test', 'Tests the project', ->
  puts "Testing..."

  mocha '-c', '-u bdd', '-R spec', 'test/lib/cobalt.js'

task 'test', 'Tests the project', ->
  puts "Testing..."

  sh "node_modules/mocha/bin/mocha -c -u bdd -R spec test/lib/cobalt.js"

task 'self', 'pygmentize self', ->
  {createClient} = require './lib/cobalt'
  fs = require 'fs'

  fs.readFile __filename, (err, data) ->
    pyg = createClient
      host: 'localhost'
      port: '8000'
      lexer: 'coffee-script'
      formatter: 'terminal256'

    pyg.pygmentize code: String(data), (highlight, error) ->
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
