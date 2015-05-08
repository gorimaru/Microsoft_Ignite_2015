require 'scraperwiki'
# -*- coding: utf-8 -*-

require 'rubygems'
require 'open-uri'
require 'nokogiri'

if RUBY_VERSION < '1.9.0'
  $KCODE = 'UTF8'
end

def parse_doc(doc)
  result = []
  doc.xpath('//div[@class="entry-meta"]').each do |entry|
    session_name = entry.xpath('a[1]/text()').to_s
    session_code = entry.xpath('ul[@class="details"]/li[@class="timing code"]/a/text()').to_s
    downloads = entry.xpath('ul[@class="details"]/li[@class="slides presentation"]/a/@href').to_s
    puts "#{session_name}, #{session_code}, #{downloads}"
    result << {
      'session_name' => session_name,
      'session_code' => session_code,
      'downloads' => downloads
    }
  end

  result
end

urls = (1..5).map {|i| "http://channel9.msdn.com/Events/Ignite/2015?sort=status&direction=asc&page=#{i}" }
urls.each do |url|
  puts "Fetching #{url}"
  doc = Nokogiri::HTML.parse(open(url))
  data = parse_doc(doc)
  
  puts "#SAVE!!"
  ScraperWiki.save(['session_name', 'session_code', 'downloads'], data)
end
