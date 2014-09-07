xml.instruct!
xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:atom" => "http://www.w3.org/2005/Atom", "version" => "2.0" do
  xml.channel do
    xml.title "Jabrutouch"
    xml.description "Clases de Guemara segun el orden de dafyomi mundial en Español"
    xml.link "http://www.dafyomi.es"
    xml.language "es"
    xml.lastBuildDate @now.strftime(DATE_FORMAT)
    xml.pubDate @now.strftime(DATE_FORMAT)
    xml.docs "http://blogs.law.harvard.edu/tech/rss"
    xml.tag! "itunes:explicit", "No"
    xml.tag! "itunes:image", nil, href: "http://jabrutouch-podcast.herokuapp.com/logo-jabrutouch.png"
    xml.tag! "itunes:category", text: "Religion &amp; Spirituality" do
      xml.tag! "itunes:category", nil, text: "Judaism"
    end
    xml.tag! "atom:link", nil, href: "http://jabrutouch-podcast.herokuapp.com/podcast.xml", rel: "self", type: "application/rss+xml"
    @items.each_with_index do |item, index|
      xml.item do
        xml.title item_title(item)
        xml.guid item_url(item)
        xml.description nil
        xml.enclosure nil, url: item_url(item), type: "audio/mpeg"
        xml.category item[:name]
        xml.pubDate item[:date].strftime(DATE_FORMAT)
        xml.tag! "itunes:author", "Jabrutouch"
        xml.tag! "itunes:explicit", "No"
        xml.tag! "itunes:subtitle", "Dafyomi En Español"
        xml.tag! "itunes:summary", "Clases de Guemara segun el orden de dafyomi mundial"
        xml.tag! "itunes:order", index+1
      end
    end
  end
end
