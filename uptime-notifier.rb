#!/usr/bin/env ruby

##
# Uptime Notifier
#
# Super simplistic website monitoring. Crontab it up and enjoy!
#
# Note: Conf file should contain one website per line
#
# Another Note: Requires terminal-notifier:
#               https://github.com/alloy/terminal-notifier
#
# @author Josh Sherman
# @link   https://github.com/joshtronic/uptime-notifier
# @usage  ruby uptime-notifier.rb /path/to/uptime-notifier.conf

require 'net/http'

unless ARGV[0].nil?
then
	conf_file = ARGV[0]
else
	conf_file = File.expand_path(File.dirname(__FILE__)) + '/uptime-notifier.conf'
end

if File.exists?(conf_file)
then
	File.open(conf_file).each { |url|
		url.chomp!

		next if (url[0..0] == '#' || url.empty?)

		url.insert(0, 'http://') unless(url.match(/^http\:\/\//))

		resource = Net::HTTP.get_response(URI.parse(url))

		unless (resource.code =~ /2|3\d{2}/)
		then
			`terminal-notifier \
				-title    "Uptime Notifier" \
				-subtitle "Site Down!" \
				-message  "#{URI.parse(url).host}" \
				-open     "http://downforeveryoneorjustme.com/#{URI.parse(url).host}" \
				-group    "Uptime Notifier #{url}" \
				-remove   "Uptime Notifier #{url}"`
		end
	}
else
	puts 'Unable to load configuration.'
end
