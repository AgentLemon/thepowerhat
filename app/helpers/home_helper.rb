module HomeHelper
  def current_user_name
    UserPresenter.new(current_user).username
  end

  def text_with_tags(text)
    text = html_escape(text)
    add_hashtags!(text)
    text = markdown.render(text)
    add_code!(text)
    text
  end

  protected

  def markdown
    @markdown ||= begin
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
      Redcarpet::Markdown.new(renderer, strikethrough: true, underline: true)
    end
  end

  def add_hashtags!(text)
    text.gsub!(Tag::Support::TAGS_REGEXP) do |hashtag|
      link_to("#{hashtag}", "?search=#{hashtag[1..-1]}", "ng-click" => "$event.stopPropagation()") if hashtag.present?
    end
  end

  def add_code!(text)
    regexp = Regexp.new "\\<code\\>((?<!\\<\\/code).)+\\<\\/code\\>", Regexp::MULTILINE
    text.gsub!(/\<\/?pre\>/, '')
    text.gsub! regexp do |match|
      match.gsub!(/\<\/?code\>/, '')
      match.gsub!(/\<br>\n/, "\n")
      match.gsub!(/\A\n+/, '')
      extra_lines = match =~ /\n\Z/ ? 0 : 1
      %Q{
        <div class="code-container">
          <div class="line-counter">
            #{ (1..(match.scan(/\n/).size) + extra_lines).to_a.map{ |i| "<span data-line='#{i}'>#{i}</span>" }.join('<br>') }
          </div>
          <div class="code-wrap">
            <div class="code">
              #{ match.gsub(' ', '&nbsp;').split(/\n/).map{ |i| "<span>#{i}</span>" }.join('<br>') }
            </div>
          </div>
        </div>
      }
    end
  end
end