Cobalt is a [node.js](http://nodejs.org) client for [pygmentize.me](http://pygmentize.me) - your friendly syntax highlighting service. It is written in [CoffeeScript](http://coffeescript.org), but the interface feel natural to JavaScript too.

# Getting Started

To start colorizing you must first create a client object, either from the `createClient` function or from instantiating either the `Pygmentizer` or `Cobalt` (this is an alias) constructor functions.
Both of them accept option object with options:

- `host` _[Default: "pygmentize.me"]_ - The host to connect to.
- `port` _[Default: 80]_ - The port to connect to.
- `lexer` _[Default: undefined]_ - The default lexer to use, if not specified in the constructor, must be specified in the `colorize` or `pygmentize` options object. The lexer must be a string of the name of the lexer.
- `styles` _[Default: undefined]_ - The default styles to use, if not specified in the constructor, must be specified in the `colorize` or `pygmentize` options object. The styles must be given as eiter a string or a list of strings, depending of the formatter.
- `formatter` _[Default: undefined]_ - The default formatter to use, if not specified in the constructor, must be specified in the `colorize` or `pygmentize` options object. The formatter must be a string of the name of the formatter.
- `options` _[Default: {}]_ - The default options to pass down to the formatter. If given they must be an object of name, value pairs.

`Pygmentizer::colorize` accepts all of the above options plus:

- `code` - The code to colorize.

Additionally the options object can be skipped all together and can be a code string, like in the examples below.
The results are given in a callback accepting two parameters. The first one is the colorized code and the other one is a boolean value indicating an error. If there was an error the first argument will be a string with it's message. 

# Examples

## CoffeeScript

    pyg = require('cobalt').createClient lexer: 'ruby', formatter: 'terminal256' 
    pyg.colorize 'puts "Hello World!"', (colorized, error) ->
      console.log colorized unless error

## JavaScript
    
    var pyg = require('cobalt').createClient({lexer: 'ruby', formatter: 'terminal256'})
    pyg.colorize('puts "Hello World!"', function(colorized, error) {
      if (!error) console.log(colorized)
    })

# Install

    npm install cobalt

# LICENSE

Copyright (C) 2012 by Genadi Samokovarov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
