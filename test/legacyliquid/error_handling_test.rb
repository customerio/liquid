require 'test_helper'

class ErrorDrop < LegacyLiquid::Drop
  def standard_error
    raise LegacyLiquid::StandardError, 'standard error'
  end

  def argument_error
    raise LegacyLiquid::ArgumentError, 'argument error'
  end

  def syntax_error
    raise LegacyLiquid::SyntaxError, 'syntax error'
  end

  def exception
    raise Exception, 'exception'
  end

end

class ErrorHandlingTest < Test::Unit::TestCase
  include LegacyLiquid

  def test_standard_error
    assert_nothing_raised do
      template = LegacyLiquid::Template.parse( ' {{ errors.standard_error }} '  )
      assert_equal ' LegacyLiquid error: standard error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal StandardError, template.errors.first.class
    end
  end

  def test_syntax

    assert_nothing_raised do

      template = LegacyLiquid::Template.parse( ' {{ errors.syntax_error }} '  )
      assert_equal ' LegacyLiquid syntax error: syntax error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal SyntaxError, template.errors.first.class

    end
  end

  def test_argument
    assert_nothing_raised do

      template = LegacyLiquid::Template.parse( ' {{ errors.argument_error }} '  )
      assert_equal ' LegacyLiquid error: argument error ', template.render('errors' => ErrorDrop.new)

      assert_equal 1, template.errors.size
      assert_equal ArgumentError, template.errors.first.class
    end
  end

  def test_missing_endtag_parse_time_error
    assert_raise(LegacyLiquid::SyntaxError) do
      template = LegacyLiquid::Template.parse(' {% for a in b %} ... ')
    end
  end

  def test_unrecognized_operator
    assert_nothing_raised do
      template = LegacyLiquid::Template.parse(' {% if 1 =! 2 %}ok{% endif %} ')
      assert_equal ' LegacyLiquid error: Unknown operator =! ', template.render
      assert_equal 1, template.errors.size
      assert_equal LegacyLiquid::ArgumentError, template.errors.first.class
    end
  end

  # LegacyLiquid should not catch Exceptions that are not subclasses of StandardError, like Interrupt and NoMemoryError
  def test_exceptions_propagate
    assert_raise Exception do
      template = LegacyLiquid::Template.parse( ' {{ errors.exception }} '  )
      template.render('errors' => ErrorDrop.new)
    end
  end
end # ErrorHandlingTest
