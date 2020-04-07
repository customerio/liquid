# Copyright (c) 2005 Tobias Luetke
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module LegacyLiquid
  FilterSeparator             = /\|/
  ArgumentSeparator           = ','
  FilterArgumentSeparator     = ':'
  VariableAttributeSeparator  = '.'
  TagStart                    = /\{\%/
  TagEnd                      = /\%\}/
  VariableSignature           = /\(?[\w\-\.\[\]]\)?/
  VariableSegment             = /[\w\-]/
  VariableStart               = /\{\{/
  VariableEnd                 = /\}\}/
  VariableIncompleteEnd       = /\}\}?/
  QuotedString                = /"[^"]*"|'[^']*'/
  QuotedFragment              = /#{QuotedString}|(?:[^\s,\|'"]|#{QuotedString})+/
  StrictQuotedFragment        = /"[^"]+"|'[^']+'|[^\s|:,]+/
  FirstFilterArgument         = /#{FilterArgumentSeparator}(?:#{StrictQuotedFragment})/
  OtherFilterArgument         = /#{ArgumentSeparator}(?:#{StrictQuotedFragment})/
  SpacelessFilter             = /^(?:'[^']+'|"[^"]+"|[^'"])*#{FilterSeparator}(?:#{StrictQuotedFragment})(?:#{FirstFilterArgument}(?:#{OtherFilterArgument})*)?/
  Expression                  = /(?:#{QuotedFragment}(?:#{SpacelessFilter})*)/
  TagAttributes               = /(\w+)\s*\:\s*(#{QuotedFragment})/
  AnyStartingTag              = /\{\{|\{\%/
  PartialTemplateParser       = /#{TagStart}.*?#{TagEnd}|#{VariableStart}.*?#{VariableIncompleteEnd}/
  TemplateParser              = /(#{PartialTemplateParser}|#{AnyStartingTag})/
  VariableParser              = /\[[^\]]+\]|#{VariableSegment}+\??/
end

require 'legacyliquid/drop'
require 'legacyliquid/extensions'
require 'legacyliquid/errors'
require 'legacyliquid/strainer'
require 'legacyliquid/context'
require 'legacyliquid/tag'
require 'legacyliquid/block'
require 'legacyliquid/document'
require 'legacyliquid/variable'
require 'legacyliquid/file_system'
require 'legacyliquid/template'
require 'legacyliquid/htmltags'
require 'legacyliquid/standardfilters'
require 'legacyliquid/condition'
require 'legacyliquid/module_ex'

# Load all the tags of the standard library
#
Dir[File.dirname(__FILE__) + '/legacyliquid/tags/*.rb'].each { |f| require f }
