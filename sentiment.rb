class TwitterSentiment
  #loading AFINN-111.txt file and creating hash
  def self.generate_sentiments
   f =  File.read("AFINN-111.txt")   #read the file
   score_hash = {}
   f.each_line do |line|
   	  word,score =	line.split("\t")
   	  score_hash[word] = score.chomp.to_i #converting score into integer
   end
   return score_hash
  end

  #this method calculates sentiment
  def self.calculate_sentiment
   puts "Calcluating Sentiment....please be patient!"
   score = []
	 sentiment = 0
	 tweet_sentiment ={}
	 f =  File.read("tweets_with_top_hashtags")
	 tweets = f.split("-seperator-")
	 tweets = tweets
	 tweets.each do |tweet|
	 	words = tweet.split(" ")
    words = words.map { |e| e.gsub(/[^0-9A-Za-z]/, '')  } #removing special character to read sentiment
	 	words.each do |w|
	 		if generate_sentiments[w.downcase].nil? 
	 			sentiment += 0
	 		else
	 			sentiment += generate_sentiments[w.downcase]
	 		end
	 	end
	 	tweet,sentiment = tweet,sentiment
	 	tweet_sentiment[tweet] = sentiment
	 	sentiment = 0
	 end
	 calculate_emotion(tweet_sentiment)
  end

  #this method generates a file named as emotions and 
  def self.calculate_emotion(tweet_sentiment)
   puts "Hurray...done!"
   puts "Generating a file named as emotions, please look into your current directory i.e. #{Dir.pwd}"
   fl = File.new("emotions",  "w")
   fl.write("Tweet:Emotion:SentimentValue\n")
   tweet_sentiment.each do |k,v|
    if v > 0
    	fl.write("#{k} | POSITIVE | #{v} \n")
    elsif v < 0
    	fl.write("#{k} | NEGATIVE | #{v}\n")
    else
    	fl.write("#{k} | NEUTRAL  | #{v}\n")
    end
   end
   fl.close
  end
  
end

TwitterSentiment.calculate_sentiment
