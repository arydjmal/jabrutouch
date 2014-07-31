require 'sinatra'
require 'nokogiri'
require 'open-uri'

SHAS = [{masejet: 'Berajot', pages: 64}, {masejet: 'Shabat', pages: 157}, {masejet: 'Eruvin', pages: 105}, {masejet: 'Pesajim', pages: 121}, {masejet: 'Shekalim', pages: 22}, {masejet: 'Yoma', pages: 88}, {masejet: 'Suca', pages: 56}, {masejet: 'Beitza', pages: 40}, {masejet: 'Rosh Hashana', pages: 35}, {masejet: 'Taanit', pages: 31}, {masejet: 'Meguila', pages: 32}, {masejet: 'Moed Katan', pages: 29}, {masejet: 'Jaguiga', pages: 27}, {masejet: 'Yevamot', pages: 122}, {masejet: 'Ketubot', pages: 112}, {masejet: 'Nedarim', pages: 91}, {masejet: 'Nazir', pages: 66}, {masejet: 'Sota', pages: 49}, {masejet: 'Guitin', pages: 90}, {masejet: 'Kidushin', pages: 82}, {masejet: 'Bava Kama', pages: 119}, {masejet: 'Bava Metzia', pages: 119}, {masejet: 'Bava Batra', pages: 176}, {masejet: 'Sanhedrin', pages: 113}, {masejet: 'Makot', pages: 24}, {masejet: 'Shevuot', pages: 49}, {masejet: 'Avoda Zara', pages: 76}, {masejet: 'Horayot', pages: 14}, {masejet: 'Zebajim', pages: 120}, {masejet: 'Menajot', pages: 110}, {masejet: 'Julin', pages: 142}, {masejet: 'Bejorot', pages: 61}, {masejet: 'Erejin', pages: 34}, {masejet: 'Temura', pages: 34}, {masejet: 'Keritot', pages: 28}, {masejet: 'Meila', pages: 22}, {masejet: 'Kinnim', pages: 4}, {masejet: 'Tamid', pages: 10}, {masejet: 'Midot', pages: 4}, {masejet: 'Nida', pages: 73}]
PAGES_IN_SHAS = 2711
STARTED_AT = Date.parse('3 August 2012')

get '/podcast.xml' do
  content_type 'text/xml'
  xml = Nokogiri::XML(open('http://www.dafyomipodcast.com/Dafyomi_Espanol.xml').read)
  # rename feed
  xml.at_css('title').content = 'Jabrutouch'
  # add logo
  image = Nokogiri::XML::Node.new 'itunes:image', xml
  image['href'] = 'http://www.dafyomi.es/_uploads/imagesgallery/logo-jabrutouch.png' 
  xml.at_css('title').add_previous_sibling(image)
  # fix published date
  xml.xpath('//item').each do |daf|
    daf.at_css('title').content.match(/(.*) ([0-9]+)/)
    daf.at_css('pubDate').content = date_of_daf($1, $2.to_i)
  end
  # render
  xml.to_s
end

private
  def date_of_daf(masejet, daf)
    today = Date.today
    todays_page = ((today-STARTED_AT)%PAGES_IN_SHAS).to_i
    cycle_started = today-todays_page
    counter = 0
    SHAS.each do |book|
      if masejet == book[:masejet]
        return (cycle_started + counter + daf - 2).strftime("%a, %d %b %Y 09:00:00 -0500")
      end
      counter += book[:pages]-1
    end
    return 'N/A'
  end
