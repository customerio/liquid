$:.unshift File.dirname(__FILE__) + '/../../lib'
require File.dirname(__FILE__) + '/../../lib/liquid'

require File.dirname(__FILE__) + '/comment_form'
require File.dirname(__FILE__) + '/paginate'
require File.dirname(__FILE__) + '/json_filter'
require File.dirname(__FILE__) + '/money_filter'
require File.dirname(__FILE__) + '/shop_filter'
require File.dirname(__FILE__) + '/tag_filter'
require File.dirname(__FILE__) + '/weight_filter'

LegacyLiquid::Template.register_tag 'paginate', Paginate
LegacyLiquid::Template.register_tag 'form', CommentForm

LegacyLiquid::Template.register_filter JsonFilter
LegacyLiquid::Template.register_filter MoneyFilter
LegacyLiquid::Template.register_filter WeightFilter
LegacyLiquid::Template.register_filter ShopFilter
LegacyLiquid::Template.register_filter TagFilter
