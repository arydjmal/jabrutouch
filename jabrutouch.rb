require 'sinatra'
require 'open-uri'
require 'builder'

MASEHTOT      = [{name: 'Berajot', pages: 64, url_name: 'Brachot', slug: 'Brjt'}, {name: 'Shabat', pages: 157, slug: 'Sh'}, {name: 'Eruvin', pages: 105, slug: 'Erv'}, {name: 'Pesajim', pages: 121, slug: 'Pes'}, {name: 'Shekalim', pages: 22, slug: 'Shk'}, {name: 'Yoma', pages: 88, slug: 'Yma'}, {name: 'Suca', pages: 56, slug: 'Sc'}, {name: 'Beitza', pages: 40, slug: 'Btza'}, {name: 'Rosh Hashana', pages: 35, slug: 'Rh', url_name: 'RoshHashana'}, {name: 'Taanit', pages: 31, slug: 'Taa'}, {name: 'Meguila', pages: 32, slug: 'MG'}, {name: 'Moed Katan', pages: 29, url_name: 'MoedKatan', slug: 'MDK'}, {name: 'Jaguiga', pages: 27, slug: 'JG'}, {name: 'Yevamot', pages: 122, slug: 'yv'}, {name: 'Ketubot', pages: 112, slug: 'kt'}, {name: 'Nedarim', pages: 91, slug: 'Nd'}, {name: 'Nazir', pages: 66, slug: 'Nz'}, {name: 'Sota', pages: 49, slug: 'So', url_name: 'Sotah'}, {name: 'Guitin', pages: 90, slug: 'GT'}, {name: 'Kidushin', pages: 82, slug: 'Kd'}, {name: 'Bava Kama', pages: 119, slug: 'Bk', url_name: 'BavaKama'}, {name: 'Bava Metzia', pages: 119, slug: 'Bm', url_name: 'Bava-Metzia'}, {name: 'Bava Batra', pages: 176, slug: 'BB', url_name: 'Bava-Batra'}, {name: 'Sanhedrin', pages: 113, slug: 'SN'}, {name: 'Makot', pages: 24, slug: 'MK'}, {name: 'Shevuot', pages: 49, slug: 'sh', url_name: 'Shvuot'}, {name: 'Avoda Zara', pages: 76, slug: 'Az', url_name: 'Avoda-Zara'}, {name: 'Horayot', pages: 14, slug: 'Hr', url_name: 'Horaiot'}, {name: 'Zebajim', pages: 120, slug: 'Zb'}, {name: 'Menajot', pages: 110, slug: 'Mn'}, {name: 'Julin', pages: 142, slug: 'Jl'}, {name: 'Bejorot', pages: 61, slug: 'Bjrt'}, {name: 'Erejin', pages: 34, slug: 'Erjn'}, {name: 'Temura', pages: 34, slug: 'Tm'}, {name: 'Keritot', pages: 28, slug: 'Krt', url_name: 'Keritut'}, {name: 'Meila', pages: 22, slug: 'Mla'}, {name: 'Kinnim', pages: 4}, {name: 'Tamid', pages: 10}, {name: 'Midot', pages: 4}, {name: 'Nida', pages: 73, slug: 'Nda'}]
PAGES_IN_SHAS = 2711
STARTED_AT    = Date.parse('3 August 2012')
DATE_FORMAT   = "%a, %d %b %Y 09:00:00 -0500"

helpers do
  def item_title(item)
   "#{item[:name]} #{item[:page]}"
  end

  def item_url(item)
    "http://download.media-line.co.il/Guemara/#{item[:url_name]||item[:name]}/MP3/#{item[:slug]}-#{"%03d" % item[:page]}.mp3"
  end
end

get '/podcast.xml' do
  @now = Date.today
  @items = (-1...30).map {|days_ago| get_daf(@now-days_ago)}
  builder :podcast
end

private
  def get_daf(date)
    todays_page = ((date+1-STARTED_AT)%PAGES_IN_SHAS).to_i
    counter = 0
    MASEHTOT.each do |masehet|
      if todays_page > counter + masehet[:pages]-1
        counter += masehet[:pages]-1
      else
        return masehet.merge(page: todays_page-counter+1, date: date)
      end
    end
    raise 'Oops'
  end
