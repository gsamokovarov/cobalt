{expect, dontExpect} = require 'moodswing'
{Pygmentizer, Cobalt, createClient} = require '../../lib/cobalt'

describe 'Pygmentizer', ->
  pyg = null

  beforeEach ->
    pyg = new Pygmentizer
      host: process.env['HOST'] or 'pygmentize.me'
      port: process.env['PORT'] or 80

  describe '::constructor', ->
    it 'should accept options used as defaults', ->
      expect(pyg.host).to be: process.env['HOST'] or 'pygmentize.me'
      expect(pyg.port).to be: process.env['PORT'] or 80

    it 'should defaults @host to "pygmentize.me"', ->
      expect(new Pygmentizer().host).to be: 'pygmentize.me'

    it 'should defaults @port to 80', ->
      expect(new Pygmentizer().port).to be: 80

  describe '::pygmentize', ->
    it 'should override options defaulted in the constructor', (done) ->
      pyg = new Pygmentizer
        host: pyg.host
        port: pyg.port
        formatter: 'latex'

      pyg.pygmentize code: 'puts "Hello World!"', lexer: 'ruby', formatter: 'html', (highlight, error) ->
        expect(highlight).to be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
        dontExpect(error).to be: true
        done()

    it 'should highlight with options of code, lexer and formatter', (done) ->
      pyg.pygmentize code: 'puts "Hello World!"', lexer: 'ruby', formatter: 'html', (highlight, error) ->
        expect(highlight).to be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
        dontExpect(error).to be: true
        done()

    it 'should highlight with a code string instead of options', (done) ->
      pyg.lexer = 'ruby'
      pyg.formatter = 'html'

      pyg.pygmentize 'puts "Hello World!"', (highlight, error) ->
        expect(highlight).to be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
        dontExpect(error).to be: true
        done()

    it 'should throw TypeError when no formatter is given', ->
      expect(-> pyg.pygmentize {}).to raise: TypeError

    it 'should indicate an error in the callback when no code is given', (done) ->
      pyg.pygmentize formatter: 'html', (highlight, error) ->
        expect(error).to be: true
        done()

  describe '::colorize', ->
    it 'should be an alias of ::pygmentize', ->
      expect(-> pyg.colorize).to be: pyg.pygmentize

  it 'should be an EventEmitter responding to the "data" event', (done) ->
    pyg.formatter = 'text'

    pyg.pygmentize('puts "Hello World!"').on 'data', done

  it 'should be an EventEmitter responding to the "end" event', (done) ->
    pyg.formatter = 'text'

    pyg.pygmentize('puts "Hello World!"').on 'end', done

describe 'Cobalt', ->
  it 'should be an alias of Pygmentizer', ->
    expect(-> Cobalt).to be: Pygmentizer

describe 'createClient', ->
  it 'should create a Pygmentizer object with the given options', ->
    client = createClient
      lexer: 'latex'
    pyg = new Pygmentizer
      lexer: 'latex'

    for key of pyg
      if typeof pyg[key] not in ['function', 'object']
        expect(-> pyg[key]).to be: equal: to: client[key]
      else
        expect(-> pyg[key]).to be: deeply: equal: to: client[key]
