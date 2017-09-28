require 'minitest/autorun'
require './lib/chisel'

class TestChisel < Minitest::Test
  def test_it_converts_markdown_to_html
    skip
    markdown = '# My Life in Desserts
    
## Chapter 1: The Beginning
    
"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."'

    actual_html = Chisel.new(markdown).to_html
    expected_html = '<h1>My Life in Desserts</h1>
    
<h2>Chapter 1: The Beginning</h2>
    
<p>
  "You just <em>have</em> to try the cheesecake," he said. "Ever since it appeared in
  <strong>Food &amp; Wine</strong> this place has been packed every night."
</p>'

    assert_equal expected_html, actual_html
  end

  def test_it_delineates_chunk_by_blank_line
    skip
    markdown = "a\nb\n\nc\n\n\nd"
    actual_chunks = Chisel.new('').string_to_chunks(markdown)
    expected_chunks = ["a\nb", 'c', 'd']
    assert_equal expected_chunks, actual_chunks
  end

  def test_it_converts_chunk_hashes_to_html_tags
    input_chunk   = '# My Life in Desserts'
    actual_chunk  = Chisel.new('').chunk_to_html(input_chunk)
    expected_html = '<h1>My Life in Desserts</h1>'

    assert_equal expected_html, actual_chunk

    input_chunk   = '## Chapter 1: The Beginning'
    actual_chunk  = Chisel.new('').chunk_to_html(input_chunk)
    expected_html = '<h2>Chapter 1: The Beginning</h2>'
    
    assert_equal expected_html, actual_chunk
  end

  def test_it_converts_everything_else_into_p
    skip
  end
end