require 'nokogiri'
require 'http'
require 'erb'
include ERB::Util

# 生成url
query=ARGV
query =  url_encode(query)
base_url = 'https://www.google.com/search?ei=6nOmWr-zE8eUjwTH0qqoCg&q='
url=sprintf('%s%s&ie=UTF-8',base_url,query)

# 发送请求,抽取返回结果前三项
body = HTTP.get(url).to_s
doc = Nokogiri::HTML(body)
items_number = doc.xpath('//div[@id="resultStats"]').text.gsub!(/\D/,"")
items=doc.xpath('//h3/a')[0..2]

# 输出总记录与前三项记录
i = 0
items.each do |item|
	i += 1
	puts "共#{items_number}个记录, 前三条为:"
	puts " 网站标题#{i}: #{item.text}"
	puts " 网址 #{item.attr("href").to_s.delete!('/url?q=?')}"
end