(function() {
  var Pygmentizer, createClient, dontExpect, expect, _ref, _ref2;

  _ref = require('moodswing'), expect = _ref.expect, dontExpect = _ref.dontExpect;

  _ref2 = require('../../lib/cobalt'), Pygmentizer = _ref2.Pygmentizer, createClient = _ref2.createClient;

  describe('Pygmentizer', function() {
    var pyg;
    pyg = null;
    2 === 2;
    beforeEach(function() {
      return pyg = new Pygmentizer({
        host: process.env['PYGHOST'] || 'localhost',
        port: process.env['PYGPORT'] || 8000
      });
    });
    describe('::constructor', function() {
      it('should accept options used as defaults', function() {
        expect(pyg.host).to({
          be: process.env['PYGHOST'] || 'localhost'
        });
        return expect(pyg.port).to({
          be: process.env['PYGPORT'] || 8000
        });
      });
      it('should defaults @host to "pygmentize.me"', function() {
        return expect(new Pygmentizer().host).to({
          be: 'pygmentize.me'
        });
      });
      return it('should defaults @port to 80', function() {
        return expect(new Pygmentizer().port).to({
          be: 80
        });
      });
    });
    describe('::pygmentize', function() {
      it('should override options defaulted in the constructor', function(done) {
        pyg = new Pygmentizer({
          host: pyg.host,
          port: pyg.port,
          formatter: 'latex'
        });
        return pyg.pygmentize({
          code: 'puts "Hello World!"',
          lexer: 'ruby',
          formatter: 'html'
        }, function(highlight, error) {
          expect(highlight).to({
            be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
          });
          dontExpect(error).to({
            be: true
          });
          return done();
        });
      });
      it('should highlight with options of code, lexer and formatter', function(done) {
        return pyg.pygmentize({
          code: 'puts "Hello World!"',
          lexer: 'ruby',
          formatter: 'html'
        }, function(highlight, error) {
          expect(highlight).to({
            be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
          });
          dontExpect(error).to({
            be: true
          });
          return done();
        });
      });
      it('should highlight with a code string instead of options', function(done) {
        pyg.lexer = 'ruby';
        pyg.formatter = 'html';
        return pyg.pygmentize('puts "Hello World!"', function(highlight, error) {
          expect(highlight).to({
            be: '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
          });
          dontExpect(error).to({
            be: true
          });
          return done();
        });
      });
      it('should throw TypeError when no formatter is given', function() {
        return expect(function() {
          return pyg.pygmentize({});
        }).to({
          raise: TypeError
        });
      });
      return it('should indicate an error in the callback when no code is given', function(done) {
        return pyg.pygmentize({
          formatter: 'html'
        }, function(highlight, error) {
          expect(error).to({
            be: true
          });
          return done();
        });
      });
    });
    describe('::colorize', function() {
      return it('should be an alias of ::pygmentize', function() {
        return expect(function() {
          return pyg.colorize;
        }).to({
          be: pyg.pygmentize
        });
      });
    });
    it('should be an EventEmitter responding to the "data" event', function(done) {
      pyg.formatter = 'text';
      return pyg.pygmentize('puts "Hello World!"').on('data', done);
    });
    return it('should be an EventEmitter responding to the "end" event', function(done) {
      pyg.formatter = 'text';
      return pyg.pygmentize('puts "Hello World!"').on('end', done);
    });
  });

  describe('createClient', function() {
    return it('should create a Pygmentizer object with the given options', function() {
      var client, key, pyg, _ref3, _results;
      client = createClient({
        lexer: 'latex'
      });
      pyg = new Pygmentizer({
        lexer: 'latex'
      });
      _results = [];
      for (key in pyg) {
        if ((_ref3 = typeof pyg[key]) !== 'function' && _ref3 !== 'object') {
          _results.push(expect(function() {
            return pyg[key];
          }).to({
            be: {
              equal: {
                to: client[key]
              }
            }
          }));
        } else {
          _results.push(expect(function() {
            return pyg[key];
          }).to({
            be: {
              deeply: {
                equal: {
                  to: client[key]
                }
              }
            }
          }));
        }
      }
      return _results;
    });
  });

}).call(this);
