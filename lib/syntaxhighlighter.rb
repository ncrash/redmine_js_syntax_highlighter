module Redmine
  module SyntaxHighlighting
    module JsSyntaxHighlighter
	  SETTING_KEY_THEME = "JsSyntaxHighlighter Theme"
	  DEFAULT_THEME = "Default"
	  THEMES = %w[
	    Default
		Django
		Eclipse
		Emacs
		FadeToGrey
		Midnight
		RDark
	  ]
      
      class << self     
        def highlight_by_filename(text, filename)
			# I don't see a way how to use JavaScript highlighter
			Redmine::SyntaxHighlighting::CodeRay.highlight_by_filename(text, filename)
			#language = File.extname(filename)			
			# "<pre class=\"brush: " + language[1..-1] + "\">" + text.gsub("<", "&lt;") + ""
        end
        
        def highlight_by_language(text, language)
			# TODO how to select by brush class, so we don't need jsh
			"<pre class=\"jsh brush: " + language + "\">" + text.gsub("<", "&lt;") + "</pre>"
			#"</code></pre><pre class=\"brush: " + language + "\">" + text.gsub("<", "&lt;") + "</pre><pre><code>"			
        end
        
        def theme
		  # return user setting for theme
		  user_theme = User.current.custom_value_for(CustomField.first(:conditions => {:name => Redmine::SyntaxHighlighting::JsSyntaxHighlighter::SETTING_KEY_THEME}))
		  user_theme || self::DEFAULT_THEME
        end
      end
      
      class Assets < Redmine::Hook::ViewListener
        def view_layouts_base_html_head(context)
		  # javascript_include_tag("src/shCore.js", :plugin => "redmine_syntaxhighlighter")
		  #js = ""
		  #js << "SyntaxHighlighter.autoloader("
		  #js << "'bash shell     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushBash.js',"
		  #js << "'css     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushCss.js',"
		  #js << "'js jscript javascript     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushJScript.js',"		  
		  #js << "'php     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushPhp.js',"		  		  
          #js << "'xml xhtml xslt html xhtml http://alexgorbatchev.com/pub/sh/current/scripts/shBrushXml.js'"
		  #js << ");"
		  #js = "SyntaxHighlighter.all();"
		  
		  js = "document.observe('dom:loaded', function() {"
		  js << "$$('pre.jsh').each(function(e) { e.up().replace(e); });"
		  js << "SyntaxHighlighter.highlight();"
		  js << "});"

      o = ""
      o << javascript_include_tag("/javascripts/shCore.js")
      # o << javascript_include_tag("/javascripts/shAutoloader.js")
      o << javascript_include_tag("/javascripts/shBrushAS3.js")
      o << javascript_include_tag("/javascripts/shBrushAppleScript.js")
      o << javascript_include_tag("/javascripts/shBrushBash.js")
      o << javascript_include_tag("/javascripts/shBrushCSharp.js")
      o << javascript_include_tag("/javascripts/shBrushColdFusion.js")
      o << javascript_include_tag("/javascripts/shBrushCpp.js")
      o << javascript_include_tag("/javascripts/shBrushCss.js")
      o << javascript_include_tag("/javascripts/shBrushDelphi.js")
      o << javascript_include_tag("/javascripts/shBrushDiff.js")
      o << javascript_include_tag("/javascripts/shBrushErb.js")
      o << javascript_include_tag("/javascripts/shBrushErlang.js")
      o << javascript_include_tag("/javascripts/shBrushGroovy.js")
      o << javascript_include_tag("/javascripts/shBrushJScript.js")
      o << javascript_include_tag("/javascripts/shBrushJava.js")
      o << javascript_include_tag("/javascripts/shBrushJavaFX.js")
      o << javascript_include_tag("/javascripts/shBrushPerl.js")
      o << javascript_include_tag("/javascripts/shBrushPhp.js")
      o << javascript_include_tag("/javascripts/shBrushPlain.js")
      o << javascript_include_tag("/javascripts/shBrushPowerShell.js")
      o << javascript_include_tag("/javascripts/shBrushPython.js")
      o << javascript_include_tag("/javascripts/shBrushRuby.js")
      o << javascript_include_tag("/javascripts/shBrushSass.js")
      o << javascript_include_tag("/javascripts/shBrushScala.js")
      o << javascript_include_tag("/javascripts/shBrushSql.js")
      o << javascript_include_tag("/javascripts/shBrushVb.js")
      o << javascript_include_tag("/javascripts/shBrushXml.js")
      o << stylesheet_link_tag("/stylesheets/shCore#{Redmine::SyntaxHighlighting::JsSyntaxHighlighter.theme}.css")
		  o << javascript_tag(js)
		  o
		  #stylesheet_link_tag("styles/shCore.css", :plugin => "redmine_syntaxhighlighter") # not working ?
          #stylesheet_link_tag("javascripts/styles/#{Redmine::SyntaxHighlighting::JsSyntaxHighlighter.theme}", :plugin => "redmine_syntaxhighlighter")		  
        end
      end
    end
  end
end
