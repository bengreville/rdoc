require 'rubygems'
require 'rdoc/markup/formatter_test_case'
require 'rdoc/markup/to_ansi'
require 'minitest/autorun'

class TestRDocMarkupToAnsi < RDoc::Markup::FormatterTestCase

  add_visitor_tests

  def setup
    super
    
    @to = RDoc::Markup::ToAnsi.new
  end

  def accept_blank_line
    assert_equal "\e[0m\n", @to.res.join
  end

  def accept_heading
    assert_equal "\e[0mHello\n", @to.res.join
  end

  def accept_list_end_bullet
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_end_label
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_end_lalpha
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_end_note
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_end_number
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_end_ualpha
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def accept_list_item_end_bullet
    assert_equal 0, @to.indent, 'indent'
  end

  def accept_list_item_end_label
    assert_equal 0, @to.indent, 'indent'
  end

  def accept_list_item_end_lalpha
    assert_equal 0, @to.indent, 'indent'
    assert_equal 'b', @to.list_index.last
  end

  def accept_list_item_end_note
    assert_equal 0, @to.indent, 'indent'
  end

  def accept_list_item_end_number
    assert_equal 0, @to.indent, 'indent'
    assert_equal 2, @to.list_index.last
  end

  def accept_list_item_end_ualpha
    assert_equal 0, @to.indent, 'indent'
    assert_equal 'B', @to.list_index.last
  end

  def accept_list_item_start_bullet
    assert_equal %W"\e[0m", @to.res
    assert_equal '* ', @to.prefix
  end

  def accept_list_item_start_label
    assert_equal %W"\e[0m", @to.res
    assert_equal 'cat: ', @to.prefix

    assert_equal 5, @to.indent
  end

  def accept_list_item_start_lalpha
    assert_equal %W"\e[0m", @to.res
    assert_equal 'a. ', @to.prefix

    assert_equal 'a', @to.list_index.last
    assert_equal 3, @to.indent
  end

  def accept_list_item_start_note
    assert_equal %W"\e[0m", @to.res
    assert_equal 'cat: ', @to.prefix

    assert_equal 5, @to.indent
  end

  def accept_list_item_start_number
    assert_equal %W"\e[0m", @to.res
    assert_equal '1. ', @to.prefix

    assert_equal 1, @to.list_index.last
    assert_equal 3, @to.indent
  end

  def accept_list_item_start_ualpha
    assert_equal %W"\e[0m", @to.res
    assert_equal 'A. ', @to.prefix

    assert_equal 'A', @to.list_index.last
    assert_equal 3, @to.indent
  end

  def accept_list_start_bullet
    assert_equal "\e[0m",   @to.res.join
    assert_equal [nil],     @to.list_index
    assert_equal [:BULLET], @to.list_type
    assert_equal [1],       @to.list_width
  end

  def accept_list_start_label
    assert_equal "\e[0m",  @to.res.join
    assert_equal [nil],    @to.list_index
    assert_equal [:LABEL], @to.list_type
    assert_equal [4],      @to.list_width
  end

  def accept_list_start_lalpha
    assert_equal "\e[0m",   @to.res.join
    assert_equal ['a'],     @to.list_index
    assert_equal [:LALPHA], @to.list_type
    assert_equal [1],       @to.list_width
  end

  def accept_list_start_note
    assert_equal "\e[0m", @to.res.join
    assert_equal [nil],   @to.list_index
    assert_equal [:NOTE], @to.list_type
    assert_equal [4],     @to.list_width
  end

  def accept_list_start_number
    assert_equal "\e[0m",   @to.res.join
    assert_equal [1],       @to.list_index
    assert_equal [:NUMBER], @to.list_type
    assert_equal [1],       @to.list_width
  end

  def accept_list_start_ualpha
    assert_equal "\e[0m",   @to.res.join
    assert_equal ['A'],     @to.list_index
    assert_equal [:UALPHA], @to.list_type
    assert_equal [1],       @to.list_width
  end

  def accept_paragraph
    assert_equal "\e[0mhi\n", @to.res.join
  end

  def accept_rule
    assert_equal "\e[0m" + '-' * 78, @to.res.join
  end

  def accept_verbatim # FormatterTestCase doesn't set indent for ToAnsi
    assert_equal "\e[0m  hi\n  world\n\n", @to.res.join
  end

  def end_accepting
    assert_equal "\e[0mhi", @to.end_accepting
  end

  def start_accepting
    assert_equal 0, @to.indent
    assert_equal %W"\e[0m", @to.res
    assert_empty @to.list_index
    assert_empty @to.list_type
    assert_empty @to.list_width
  end

  def test_accept_heading_1
    @to.start_accepting
    @to.accept_heading @RMP::Heading.new(1, 'Hello')

    assert_equal "\e[0m\e[1;32mHello\e[m\n", @to.end_accepting
  end

  def test_accept_heading_2
    @to.start_accepting
    @to.accept_heading @RMP::Heading.new(2, 'Hello')

    assert_equal "\e[0m\e[4;32mHello\e[m\n", @to.end_accepting
  end

  def test_accept_heading_3
    @to.start_accepting
    @to.accept_heading @RMP::Heading.new(3, 'Hello')

    assert_equal "\e[0m\e[32mHello\e[m\n", @to.end_accepting
  end

  def test_accept_heading_4
    @to.start_accepting
    @to.accept_heading @RMP::Heading.new(4, 'Hello')

    assert_equal "\e[0mHello\n", @to.end_accepting
  end

  def test_accept_heading_indent
    @to.start_accepting
    @to.indent = 3
    @to.accept_heading @RMP::Heading.new(1, 'Hello')

    assert_equal "\e[0m   \e[1;32mHello\e[m\n", @to.end_accepting
  end

  def test_accept_heading_b
    @to.start_accepting
    @to.indent = 3
    @to.accept_heading @RMP::Heading.new(1, '*Hello*')

    assert_equal "\e[0m   \e[1;32m\e[1mHello\e[m\e[m\n", @to.end_accepting
  end

  def test_accept_list_item_start_note_2
    list = @RMP::List.new(:NOTE,
             @RMP::ListItem.new('<tt>teletype</tt>',
                                @RMP::Paragraph.new('teletype description')))

    @to.start_accepting

    list.accept @to

    expected = "\e[0m\e[7mteletype\e[m: teletype description\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_b
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('reg <b>bold words</b> reg')

    expected = "\e[0mreg \e[1mbold words\e[m reg\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_i
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('reg <em>italic words</em> reg')

    expected = "\e[0mreg \e[3mitalic words\e[m reg\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_indent
    @to.start_accepting
    @to.indent = 3
    @to.accept_paragraph @RMP::Paragraph.new('words ' * 30)

    expected = <<-EXPECTED
\e[0m   words words words words words words words words words words words words
   words words words words words words words words words words words words
   words words words words words words 
    EXPECTED

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_plus
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('regular +teletype+ regular')

    expected = "\e[0mregular \e[7mteletype\e[m regular\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_star
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('regular *bold* regular')

    expected = "\e[0mregular \e[1mbold\e[m regular\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_underscore
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('regular _italic_ regular')

    expected = "\e[0mregular \e[3mitalic\e[m regular\n"

    assert_equal expected, @to.end_accepting
  end

  def test_accept_paragraph_wrap
    @to.start_accepting
    @to.accept_paragraph @RMP::Paragraph.new('words ' * 30)

    expected = <<-EXPECTED
\e[0mwords words words words words words words words words words words words words
words words words words words words words words words words words words words
words words words words 
    EXPECTED

    assert_equal expected, @to.end_accepting
  end

  def test_accept_rule_indent
    @to.start_accepting
    @to.indent = 3

    @to.accept_rule @RMP::Rule.new(1)

    assert_equal "\e[0m   " + '-' * 75, @to.end_accepting
  end

  def test_accept_verbatim_indent
    @to.start_accepting

    @to.indent = 2

    @to.accept_verbatim @RMP::Verbatim.new('    ', 'hi', "\n",
                                           '     ', 'world', "\n")

    assert_equal "\e[0m    hi\n     world\n\n", @to.end_accepting
  end

  def test_accept_verbatim_big_indent
    @to.start_accepting

    @to.indent = 2

    @to.accept_verbatim @RMP::Verbatim.new('    ', 'hi', "\n",
                                           '    ', 'world', "\n")

    assert_equal "\e[0m    hi\n    world\n\n", @to.end_accepting
  end

  def test_attributes
    assert_equal 'Dog', @to.attributes("\\Dog")
  end

  def test_list_nested
    doc = @RMP::Document.new(
            @RMP::List.new(:BULLET,
              @RMP::ListItem.new(nil,
                @RMP::Paragraph.new('l1'),
                @RMP::List.new(:BULLET,
                  @RMP::ListItem.new(nil,
                    @RMP::Paragraph.new('l1.1')))),
              @RMP::ListItem.new(nil,
                @RMP::Paragraph.new('l2'))))

    output = doc.accept @to

    expected = <<-EXPECTED
\e[0m* l1
  * l1.1
* l2
    EXPECTED

    assert_equal expected, output
  end

  def test_list_verbatim # HACK overblown
    doc = @RMP::Document.new(
            @RMP::List.new(:BULLET,
              @RMP::ListItem.new(nil,
                @RMP::Paragraph.new('list', 'stuff'),
                @RMP::BlankLine.new(),
                @RMP::Verbatim.new('   ', '*', ' ', 'list', "\n",
                                   '     ', 'with', "\n",
                                   "\n",
                                   '     ', 'second', "\n",
                                   "\n",
                                   '     ', '1.', ' ', 'indented', "\n",
                                   '     ', '2.', ' ', 'numbered', "\n",
                                   "\n",
                                   '     ', 'third', "\n",
                                   "\n",
                                   '   ', '*', ' ', 'second', "\n"))))

    output = doc.accept @to

    expected = <<-EXPECTED
\e[0m* list stuff

    * list
      with

      second

      1. indented
      2. numbered

      third

    * second

    EXPECTED

    assert_equal expected, output
  end

end

