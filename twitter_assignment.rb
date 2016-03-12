require 'json'

class DataAnalysis
  #loading json file...
  def initialize_file
    f = File.read("english_tweets.json")
	  arr = f.split("\n")
	  arr.delete_if {|i| i == "\r"}
	  puts "Total Objects are #{arr.count}"
	  #Checking for the proper data in file...
	  begin
	   JSON.parse(arr.last)
	  rescue JSON::ParserError => e
	   arr.pop #removing last element which if it is unable to parse
	  end
    counts(arr)
  end

  #this methods returns count of tweets, hashtags
  def counts(arr)
    puts "*********************************************************************************"
    puts "Calculating counts...."
    count = 0
    hashtags_count = 0
    top_hash_tags =[]
    arr.each do |i|
      unless JSON.parse(i)['created_at'].nil? 
        count += 1
        hashtags_count += 1  if !JSON.parse(i)['entities']['hashtags'].empty?
        top_hash_tags << JSON.parse(i)['entities']['hashtags'] if !JSON.parse(i)['entities']['hashtags'].empty?
      end
    end
    puts "Total Number of tweets #{count}" 
    puts "#{hashtags_count} of tweets has hashtags" 
    print_results(arr,top_hash_tags)
  end

  #this method prints the value of top 10 hashtags
  def print_results(arr,top_hash_tags)
    puts "*********************************************************************************"
    puts "Printing top 10 popular hash tags..."
    top_hash_tags = top_hash_tags.flatten
    top_hash_tags = top_hash_tags.map { |e| e['text']  }
    word_count = Hash.new(0)
    th = top_hash_tags.each { |word| word_count[word] += 1 }
    word_count = word_count.sort_by {|_key, value| value}.reverse.take(10)
    puts "The 10 most popular hashtags with their frequencies are:"
    word_count.to_h.each do |k,v|
     puts "Hashtag: #{k} appeared #{v} times"
    end
    create_file(word_count,arr)
  end

  #this method creates a file with tweets with top hashtags
  def create_file(word_count,arr)
    puts "*********************************************************************************"
    puts "Sentiment Calcuation..."
    hashtags = word_count.to_h.keys
    fl = File.new("tweets_with_top_hashtags",  "w")
    arr.each do |i|
      unless JSON.parse(i)['created_at'].nil? 
        if !JSON.parse(i)['entities']['hashtags'].empty?
          hashtags.each do |hi|
            if (JSON.parse(i)['entities']['hashtags'].map { |e| e['text']  }).include?(hi)
              fl.write(JSON.parse(i)['text'])
              fl.write("-seperator-")  #separating the tweets by this word
            end
          end
        end
      end
    end
    fl.close
  end
end


data = DataAnalysis.new
data.initialize_file











