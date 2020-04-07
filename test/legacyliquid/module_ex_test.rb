require 'test_helper'

class TestClassA
  liquid_methods :allowedA, :chainedB
  def allowedA
    'allowedA'
  end
  def restrictedA
    'restrictedA'
  end
  def chainedB
    TestClassB.new
  end
end

class TestClassB
  liquid_methods :allowedB, :chainedC
  def allowedB
    'allowedB'
  end
  def chainedC
    TestClassC.new
  end
end

class TestClassC
  liquid_methods :allowedC
  def allowedC
    'allowedC'
  end
end

class TestClassC::LegacyLiquidDropClass
  def another_allowedC
    'another_allowedC'
  end
end

class ModuleExTest < Test::Unit::TestCase
  include LegacyLiquid

  def setup
    @a = TestClassA.new
    @b = TestClassB.new
    @c = TestClassC.new
  end

  def test_should_create_LegacyLiquidDropClass
    assert TestClassA::LegacyLiquidDropClass
    assert TestClassB::LegacyLiquidDropClass
    assert TestClassC::LegacyLiquidDropClass
  end

  def test_should_respond_to_liquid
    assert @a.respond_to?(:to_liquid)
    assert @b.respond_to?(:to_liquid)
    assert @c.respond_to?(:to_liquid)
  end

  def test_should_return_LegacyLiquidDropClass_object
    assert @a.to_liquid.is_a?(TestClassA::LegacyLiquidDropClass)
    assert @b.to_liquid.is_a?(TestClassB::LegacyLiquidDropClass)
    assert @c.to_liquid.is_a?(TestClassC::LegacyLiquidDropClass)
  end

  def test_should_respond_to_liquid_methods
    assert @a.to_liquid.respond_to?(:allowedA)
    assert @a.to_liquid.respond_to?(:chainedB)
    assert @b.to_liquid.respond_to?(:allowedB)
    assert @b.to_liquid.respond_to?(:chainedC)
    assert @c.to_liquid.respond_to?(:allowedC)
    assert @c.to_liquid.respond_to?(:another_allowedC)
  end

  def test_should_not_respond_to_restricted_methods
    assert ! @a.to_liquid.respond_to?(:restricted)
  end

  def test_should_use_regular_objects_as_drops
    assert_equal 'allowedA', LegacyLiquid::Template.parse("{{ a.allowedA }}").render('a'=>@a)
    assert_equal 'allowedB', LegacyLiquid::Template.parse("{{ a.chainedB.allowedB }}").render('a'=>@a)
    assert_equal 'allowedC', LegacyLiquid::Template.parse("{{ a.chainedB.chainedC.allowedC }}").render('a'=>@a)
    assert_equal 'another_allowedC', LegacyLiquid::Template.parse("{{ a.chainedB.chainedC.another_allowedC }}").render('a'=>@a)
    assert_equal '', LegacyLiquid::Template.parse("{{ a.restricted }}").render('a'=>@a)
    assert_equal '', LegacyLiquid::Template.parse("{{ a.unknown }}").render('a'=>@a)
  end
end # ModuleExTest
