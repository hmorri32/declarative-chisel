require 'minitest'
require 'minitest/autorun'
require './lib/chisel'

class TestChisel < Minitest::Test
  def test_it_converts_markdown_to_html

    markdown = '# My Life in Desserts

## Chapter 1: The Beginning

"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."'

    expected_html = '<h1>My Life in Desserts</h1>

<h2>Chapter 1: The Beginning</h2>

<p>
  "You just <em>have</em> to try the cheesecake," he said. "Ever since it appeared in
  <strong>Food &amp; Wine</strong> this place has been packed every night."
</p>'

    assert_equal expected_html, Chisel.new(markdown).to_html
  end

  def string_to_chunks(chunk)
    Chisel.new('').string_to_chunks(chunk)
  end

  def chunk_to_html(chunk)
    Chisel.new('').chunk_to_html(chunk)
  end

  def test_it_delineates_chunk_by_blank_line
    
    assert_equal ["a\nb", 'c', 'd'], string_to_chunks("a\nb\n\nc\n\n\nd")
  end

  def test_it_converts_chunk_hashes_to_h_tags

    assert_equal '<h1>My Life in Desserts</h1>',      chunk_to_html('# My Life in Desserts')
    assert_equal '<h2>Chapter 1: The Beginning</h2>', chunk_to_html('## Chapter 1: The Beginning')
  end

  def test_it_converts_everything_else_into_p

    assert_equal "<p>\n  line 1\n  line 2\n</p>", chunk_to_html("line 1\nline 2")
  end

  def test_it_handles_lists

    markdown = 'My favorite cuisines are:

* Sushi
* Barbeque
* Mexican'

    expected_html = '<p>
  My favorite cuisines are:
</p>

<ul>
  <li>Sushi</li>
  <li>Barbeque</li>
  <li>Mexican</li>
</ul>'

    assert_equal expected_html, Chisel.new(markdown).to_html

  end

  def test_it_handles_lists_and_p_tags

    markdown = 
'cool stuff

* sup'

    expected_html =
'<p>
  cool stuff
</p>

<ul>
  <li>sup</li>
</ul>'

  actual_html = Chisel.new(markdown).to_html

  assert_equal expected_html, actual_html
  end
end