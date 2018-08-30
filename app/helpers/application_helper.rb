module ApplicationHelper
	require 'json'
	require 'rouge'
	require 'redcarpet'
  	require 'rouge/plugins/redcarpet'

	# Pull in color library
	file = File.read('colors.json')
	$color_hash = JSON.parse(file)


	def active_class(link_path)
	  current_page?(link_path) ? "active" : ""
	end

	# Color helper 
	def color(color_name, color_level, mode="Hex")
		color = $color_hash[color_name][color_level][mode]

		return color
	end

	class HTML < Redcarpet::Render::HTML
    	include Rouge::Plugins::Redcarpet
  	end

  	# Render code highlighting from markdown
	def markdown(text)
	    render_options = {
	        filter_html: true,
	        hard_wrap: true,
	        link_attributes: { rel: 'nofollow' }
	    }
	    renderer = HTML.new(render_options)

	    extensions = {
	        autolink: true,
	        fenced_code_blocks: true,
	        lax_spacing: true,
	        no_intra_emphasis: true,
	        strikethrough: true,
	        superscript: true
	    }
	    markdown = Redcarpet::Markdown.new(renderer, extensions)
	    markdown.render(text)
	end

	# Color Peeks
	def color_peek(color_name, color_level)
		block = ('<span class="color-peek bg-' + color_name + '-' + color_level + '"></span>').html_safe
		return block
	end

	# Determine the sidebar based on the URL
	def render_sidebar
		if request.path_info.include?( '/patterns' )
			render(partial: "sidebar_patterns")
		else
			render(partial: "sidebar_default")
		end
	end
end
