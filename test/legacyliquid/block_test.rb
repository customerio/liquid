require 'test_helper'

class VariableTest < Test::Unit::TestCase
  include LegacyLiquid

  def test_blankspace
    template = LegacyLiquid::Template.parse("  ")
    assert_equal ["  "], template.root.nodelist
  end

  def test_variable_beginning
    template = LegacyLiquid::Template.parse("{{funk}}  ")
    assert_equal 2, template.root.nodelist.size
    assert_equal Variable, template.root.nodelist[0].class
    assert_equal String, template.root.nodelist[1].class
  end

  def test_variable_end
    template = LegacyLiquid::Template.parse("  {{funk}}")
    assert_equal 2, template.root.nodelist.size
    assert_equal String, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
  end

  def test_variable_middle
    template = LegacyLiquid::Template.parse("  {{funk}}  ")
    assert_equal 3, template.root.nodelist.size
    assert_equal String, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
    assert_equal String, template.root.nodelist[2].class
  end

  def test_variable_many_embedded_fragments
    template = LegacyLiquid::Template.parse("  {{funk}} {{so}} {{brother}} ")
    assert_equal 7, template.root.nodelist.size
    assert_equal [String, Variable, String, Variable, String, Variable, String],
                 block_types(template.root.nodelist)
  end

  def test_with_block
    template = LegacyLiquid::Template.parse("  {% comment %} {% endcomment %} ")
    assert_equal [String, Comment, String], block_types(template.root.nodelist)
    assert_equal 3, template.root.nodelist.size
  end

  def test_with_custom_tag
    LegacyLiquid::Template.register_tag("testtag", Block)

    assert_nothing_thrown do
      template = LegacyLiquid::Template.parse( "{% testtag %} {% endtesttag %}")
    end
  end

  private
    def block_types(nodelist)
      nodelist.collect { |node| node.class }
    end
end # VariableTest
