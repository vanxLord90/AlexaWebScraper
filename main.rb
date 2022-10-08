require 'httparty'
require 'colorize'
require 'nokogiri'
require 'open-uri'
require 'csv'

class Main

    @url= Nokogiri::HTML(URI.open("https://ohiostatebuckeyes.com/sports/w-volley/schedule/season/2022-23/"))
    divTag= @url.xpath("//*[@id='main-content']/section/div/div[6]/div/div")
    i=0
    
    CSV.open("myfile.csv", "w") do |csv|
        csv << ["Date","Time","Location","Opponent","Score","Victory_Status"]
        divTag.search("//div[@class='ohio--schedule-item home_game']").each do |hm|
            homeGames=hm.search("h3")
            versus= homeGames.text
            csv <<[versus.strip]
            
        end
  
    end
   
    end
    
    # File.open("boom.txt","w") do |f|
    #     f.puts divTag
    # end
    
