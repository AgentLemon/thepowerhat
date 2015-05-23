module HomeHelper

  def current_user_name
    UserPresenter.new(current_user).username
  end

  def text_with_tags(text)
    text = html_escape(text)
    text = add_bold text
    text = add_itallic text
    text = add_code text
    text = add_hashtags text
    simple_format(text)
  end

  protected

  def add_hashtags(text)
    text.gsub(Tag::Support::TAGS_REGEXP) do |hashtag|
      link_to("#{hashtag}", "?search=#{hashtag[1..-1]}", "ng-click" => "$event.stopPropagation()") if hashtag.present?
    end
  end

  def add_bold(text)
    bbcode text, "b" do |match|
      "<strong>#{match}</strong>"
    end
  end

  def add_itallic(text)
    bbcode text, "b" do |match|
      "<i>#{match}</i>"
    end
  end

  def add_code(text)
    bbcode text, "code" do |match|
      %Q{<div class="code-container"><div class="line-counter">#{(1..(match.scan(/\n/).size + 1)).to_a.inject(""){ |result, i| result << "<span data-line='#{i}'>#{i}</span><br/>" }}</div>} <<
      %Q{<div class="code-wrap"><div class="code">#{match.gsub(" ", "&nbsp;").gsub(/\r/, "").split("\n").inject(""){ |result, i| result << "<span>#{i}</span><br/>" }}</div></div></div>}
    end
  end

  def bbcode(text, code, &block)
    size = code.size
    regexp = Regexp.new "\\[#{code}\\]((?<!\\[\\/#{code}).)+\\[\\/#{code}\\]", Regexp::MULTILINE
    regexp_newline = Regexp.new "(?<=\\[#{code}\\])\\r?\\n|\\r?\\n(?=\\[\\/#{code}\\])", Regexp::MULTILINE
    text.gsub! regexp do |match|
      block.call match.gsub(regexp_newline, "")[(size + 2)..-(size + 4)]
    end
    text
  end

end