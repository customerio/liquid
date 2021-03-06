require 'test_helper'

class RawTagTest < Test::Unit::TestCase
  include Liquid

  def test_tag_in_raw
    assert_template_result '{% comment %} test {% endcomment %}',
                           '{% raw %}{% comment %} test {% endcomment %}{% endraw %}'
  end

  def test_output_in_raw
    assert_template_result '{{ test }}', '{% raw %}{{ test }}{% endraw %}'
  end

  def test_open_tag_in_raw
    assert_template_result ' Foobar {% invalid ', '{% raw %} Foobar {% invalid {% endraw %}'
    assert_template_result ' Foobar invalid %} ', '{% raw %} Foobar invalid %} {% endraw %}'
    assert_template_result ' Foobar {{ invalid ', '{% raw %} Foobar {{ invalid {% endraw %}'
    assert_template_result ' Foobar invalid }} ', '{% raw %} Foobar invalid }} {% endraw %}'
    assert_template_result ' Foobar {% invalid {% {% endraw ', '{% raw %} Foobar {% invalid {% {% endraw {% endraw %}'
    assert_template_result ' Foobar {% {% {% ', '{% raw %} Foobar {% {% {% {% endraw %}'
    assert_template_result ' test {% raw %} {% endraw %}', '{% raw %} test {% raw %} {% {% endraw %}endraw %}'
  end

  def test_raw_is_not_greedy
    assert_template_result ' {{Foo}}   {{Bar}} ', '{% raw %} {{Foo}} {% endraw %} {% raw %} {{Bar}} {% endraw %}'
  end
end
