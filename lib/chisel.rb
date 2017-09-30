class Chisel
def initialize(markdown)
    @markdown = markdown
  end

  def to_html
    html_chunks = string_to_chunks(@markdown).map {|chunk| chunk_to_html(chunk)}
    chunks_to_string(html_chunks)
  end

  def chunks_to_string(chunk)
    chunk.join("\n\n") 
  end
  
  def string_to_chunks(string)
    string.split(/\n\n+/)
  end

  def chunk_to_html(input)
    return header_to_html(input)    if header?(input)
    paragraph_to_html(input)
    # list_to_html(input)
  end

  def paragraph_to_html(input)
    markdown_lines     = format_paragraph(input).lines
    indented_paragraph = markdown_lines.map{|line| "  #{line.chomp}\n"}.join
    "<p>\n#{indented_paragraph}</p>"
  end

  def list_to_html(text)
    li_tags = text.gsub!("* ", '  <li>')
                  .split("\n")
                  .reject {|item| !item.start_with?("  <li>")}
                  .map{|item| "#{item}</li>"}
                  .join("\n")

    p_tags  = text.split("\n")
                  .reject {|item| item.start_with?("  <li>")}.join

      "<ul>\n#{li_tags}\n</ul>"
    end
  end

  def header?(input)
    input[0] == '#'
  end

  def paragraph?(input)
    input[0] != '#' && input[0] != "*"
  end

  def list?(input)
    input[0..1] == "* "
  end

  def format_paragraph(text)
    text.gsub("**").with_index { |_, index| "<#{'/' if index.odd?}strong>" }
        .gsub("*").with_index  { |_, index| "<#{'/' if index.odd?}em>" }
        .gsub("&", "&amp;")
  end

  def header_to_html(input)
    first_char  = input.index(' ') + 1
    level       = first_char - 1
    header_text = input[first_char..-1]

    "<h#{level}>#{header_text}</h#{level}>"
  end

end


if $PROGRAM_NAME == __FILE__
  markdown_file  = ARGV[0]
  html_file      = ARGV[1]
  markdown       = File.read(markdown_file)
  html           = Chisel.new(markdown).to_html

  File.write(html_file, html)

  puts "converted #{markdown_file} (#{markdown.lines.count} lines) to #{html_file} (#{html.lines.count} lines)"
end