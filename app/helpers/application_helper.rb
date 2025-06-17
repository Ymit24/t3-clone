require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

module ApplicationHelper
  class HTML < Redcarpet::Render::HTML
    def block_code(code, language)
      lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
      formatter = Rouge::Formatters::HTML.new

      # Generate the highlighted code
      highlighted = formatter.format(lexer.lex(code))

      # Create a wrapper with the code block and copy button
      <<~HTML
        <div class="code-block-wrapper relative group">
          <pre class="highlight"><code class="language-#{lexer.tag}">#{highlighted}</code></pre>
          <div class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
            <button type="button" class="copy-code-button bg-gray-700 hover:bg-gray-600 text-gray-300 rounded p-1.5 text-xs"#{' '}
                    onclick="copyCodeToClipboard(this)"#{' '}
                    title="Copy to clipboard">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
              </svg>
            </button>
          </div>
        </div>
      HTML
    end
    include Rouge::Plugins::Redcarpet
  end

  def markdown(text)
    return "" if text.nil?

    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" }
      # prettify: true
    }

    extensions = {
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      no_intra_emphasis: true,
      strikethrough: true,
      superscript: true
      # disable_indented_code_blocks: true,
    }

    renderer = HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
end
