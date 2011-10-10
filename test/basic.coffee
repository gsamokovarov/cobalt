cobalt = require '../lib/cobalt'
assert = require 'assert'

cobalt.configure ->
  host: 'localhost', port: '8080'

assert.equal \
  cobalt.colorize('puts "Hello World!"', 'ruby', 'html'),
  '<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n'
