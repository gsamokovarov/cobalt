(function() {
  var EventEmitter, http;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  http = require('http');

  EventEmitter = require('events').EventEmitter;

  exports.Pygmentizer = (function() {

    __extends(Pygmentizer, EventEmitter);

    function Pygmentizer(options) {
      if (options == null) options = {};
      EventEmitter.call(this);
      this.host = options.host || 'pygmentize.me';
      this.port = options.port || 80;
      this.lexer = options.lexer;
      this.styles = options.styles;
      this.formatter = options.formatter;
      this.options = options.options || {};
      this.path = options.path || '/api/formatter/';
      this.type = options.type || 'unencoded';
      this.parser = options.parser || require('querystring').stringify;
    }

    Pygmentizer.prototype.pygmentize = function(options, callback) {
      var data, powder, query, request;
      var _this = this;
      if (!((options.formatter != null) || (this.formatter != null))) {
        throw new TypeError('You must specify a formatter');
      }
      query = this.parser({
        code: options.code || (typeof options === 'string' ? options : null),
        lexer: options.lexer || this.lexer,
        formatter: options.formatter || this.formatter,
        options: JSON.stringify(options.options || this.options),
        styles: JSON.stringify(options.styles || this.styles)
      });
      data = {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': query.length
        },
        host: this.host,
        port: this.port,
        path: "" + (options.path || this.path) + (options.formatter || this.formatter)
      };
      powder = [];
      request = http.request(data, function(response) {
        response.on('data', function(chunk) {
          var dust;
          dust = String(chunk);
          _this.emit('data', dust);
          return powder.push(dust);
        });
        return response.on('end', function() {
          var error, highlight;
          highlight = powder.join('');
          error = response.statusCode !== 200 ? true : false;
          _this.emit('end', highlight, error);
          return typeof callback === "function" ? callback(highlight, error) : void 0;
        });
      });
      request.end(query);
      return this;
    };

    return Pygmentizer;

  })();

  exports.Pygmentizer.prototype.colorize = exports.Pygmentizer.prototype.pygmentize;

  exports.createClient = function(options) {
    if (options == null) options = {};
    return new exports.Pygmentizer(options);
  };

}).call(this);
