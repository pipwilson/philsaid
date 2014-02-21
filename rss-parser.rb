require 'rss'
require 'open-uri'
require 'slack-notifier'
require 'nokogiri'
require 'kramdown'

@url = 'http://philsaid.tumblr.com/rss'

def get_text_to_say
	open(@url) do |rss|
		feed = RSS::Parser.parse(rss)

	  	item = feed.items.sample

	  	if item.description == nil && item.title != nil
	    	item.description = item.title
	    end    	

	    return "#{item.title}" + " <#{item.link}|#>"
	end

end

def post_to_slack(message)
	notifier = Slack::Notifier.new("uniofbathdmc", ENV['SLACK_TOKEN_PHILSAID'])
	notifier.ping(message, channel: "#test")
end

# post_to_slack
post_to_slack Kramdown::Document.new(get_text_to_say, :input => 'html').to_kramdown

#puts Nokogiri::HTML(get_text_to_say).text
#puts Slack::Notifier::LinkFormatter.format(message)
