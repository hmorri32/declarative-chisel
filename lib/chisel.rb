class Chisel
def initialize(markdown)
    @markdown = markdown
  end

  def to_html
    markdown_chunks = string_to_chunks(@markdown)
    html_chunks     = markdown_chunks.map do |chunk| 
      chunk_to_html(chunk)
    end
    chunks_to_string html_chunks
  end

  def string_to_chunks(string)
    string.split(/\n\n+/)
  end

  def chunk_to_html(input)
    # remove leading hashes and yung space
    first_char  = input.index(' ') + 1
    level       = first_char - 1
    last_char   = -1
    header_text = input[first_char..last_char]
    
    # and den wrap it with yung tags 
    "<h#{level}>#{header_text}</h#{level}>"
    
  end

end

im_running_the_program = ($PROGRAM_NAME == __FILE__)

if im_running_the_program
  markdown_file = ARGV[0]
  html_file     = ARGV[1]
  markdown      = File.read(markdown_file)
  html          = Chisel.new(markdown).to_html

  File.write(html_file, html)

  num_lines_of_markdown = markdown.lines.count
  num_lines_of_html     = html.lines.count

  puts "converted #{markdown_file} (#{num_lines_of_markdown} lines) to #{html_file} (#{num_lines_of_html} lines)"
end