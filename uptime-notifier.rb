#!/usr/bin/ruby

# Uptime Notifier
#
# Super simplistic website monitoring. Crontab is up and enjoy!
#
# Usage: ruby uptime-notifier.rb
#
# p.s. This was just a quick Thanksgiving proof of concept, I do plan on
#      expanding this and giving is some sick configuration options.
#
# Requires terminal-notifier:
#     https://github.com/alloy/terminal-notifier

require 'net/http'

url = 'http://this-website-should-be-down.com'

resource = Net::HTTP.get_response(URI.parse(url.to_s))

unless (resource.code =~ /2|3\d{2}/)
then
	`terminal-notifier \
		-title "Uptime Notifier" \
		-message "OH NOES, it looks like #{URI.parse(url).host} is down!!~!" \
		-open #{url} \
		-group Uptime Notifier \
		-remove Uptime Notifier`
end
