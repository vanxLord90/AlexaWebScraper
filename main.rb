require 'httparty'
require 'colorize'
require 'nokogiri'
require 'open-uri'
require 'spreadsheet'

class Main

    @url= Nokogiri::HTML(URI.open("https://ohiostatebuckeyes.com/sports/w-volley/schedule/season/2022-23/"))
    divTag= @url.xpath("//*[@id='main-content']/section/div/div[6]/div/div")
    i=0
    oppArr=[]
    dateArr=[]

    
       locArr=[]
       maxLen=0
       posMax=0
        divTag.search("h3").each do |hm|
            oppArr[i]=hm.text
            triml=oppArr[i].lstrip
            trimr= triml.rstrip
            oppArr[i]=trimr+""
            maxLen=trimr.length
            if((oppArr[i].to_s).length>maxLen)
                maxLen=oppArr[i].length
                posMax=i
                puts posMax.to_s
            end
            i=i+1
        end
        i=0
        divTag.search("//span[@class='ohio--schedule-location']").each do |lm|
            boom=lm.text
          
            if(boom.include?("Covelli") || boom.include?("Columbus, Ohio"))
                locArr[i]="home"
            elsif(!(boom.include?("Covelli")))
                locArr[i]="away"
            end
          
            i=i+1

        end
        

        i=0
        divTag.search("div[@class='ohio--schedule-date']").each do |dm|
            dateArr[i]=dm.text
     
            i=i+1
        end
        rArr=[]


        i=0
        sArr=[]
        divTag.search("span[@class='results']").each do |rm|
            if((rm.text).include?("W"))
                rArr[i]="win"
                
                rmText= rm.text
                posColon=rmText.index(":")
                pos= posColon-6
                score= rmText[pos...posColon]
                sArr[i]=score
                
            elsif((rm.text).include?("L"))
                rArr[i]="loss"
                rmText= rm.text
                posColon=rmText.index(":")
                pos= posColon-6
                score= rmText[pos...posColon]
                scoreR= score.rstrip
                scoreL=scoreR.lstrip
                sArr[i]=scoreL

            else
                break
            end
            i=i+1
            
        end

        j=rArr.length
       
        divTag.search("span").each do |rrm|
            spText= rrm.text
            if(spText.include?("pm")|| spText.include?("TBA"))
                spTextr= spText.rstrip
                spTextl=spTextr.lstrip
                rArr[j]=spTextl

                sArr[j]=" To Be Played"
                j=j+1
            end
        end
        
        sArr[0]=sArr[0]+"        "
        

     
        # book = Spreadsheet:: Workbook.new
        # shee1= book.create_worksheet 
        # shee1.row(0).concat %w{Date Location Opponent Score Results}
        # for a in 0..dateArr.length do
        #     shee1.row(a).p
        
        n=oppArr.length
        CSV.open("myfile.csv", "w") do |csv|
            csv<<["Date,Location,Opponent,Score,Result"]
            
            #puts oppArr[1].strip+" "+dateArr[1].strip
             #puts (rArr[14].to_s)
             for c in 0..dateArr.length do
                csv<<[(dateArr[c].to_s).strip+","+(locArr[c].to_s).strip+","+(oppArr[c].to_s).strip+","+(sArr[c].to_s).strip+","+(rArr[c].to_s).strip]
             end
        end
   
    end

