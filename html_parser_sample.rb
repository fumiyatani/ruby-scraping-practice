# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'date'

puts "URLを入力してください"
url = gets.chomp
string = URI.open(url)
html_doc = Nokogiri::HTML5.parse(string)

# //タグ名 + [@class=設定内容]
puts "欲しい要素を入力してください"
html_element = gets.chomp
partners = html_doc.css("#{html_element}").map do |item|
  item.text.strip
end

partners_csv = CSV.generate do |csv|
  csv << [:id, :partner_name]
  partners.each_with_index do |partner_name, idx|
    csv_item = [
      idx,
      partner_name
    ]
    csv << csv_item
  end
end

date_time = DateTime.now.strftime("%Y%m%d%H%M%S")
File.open("./partners_#{date_time}.csv", 'w') do |file|
  file.write(partners_csv)
end
