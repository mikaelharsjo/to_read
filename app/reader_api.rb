class ReaderAPI
	include BubbleWrap
	
	def initialize
		@tokenRepository = TokenRepository.new
	end

 	def getUnreadCount(&block)
 		url = "http://www.google.com/reader/api/0/unread-count?output=json&access_token=@tokenRepository.get('access_token')"
		HTTP.get(url,
		{
			#:headers => {"Authorization" => "Bearer #{@tokenRepository.get 'access_token'}"}
		}) do |response|
			p response
			json = JSON.parse(response.body.to_str)
			json['unreadcounts'].each do |feed|
				if feed['id'].include? 'com.google/reading-list'
					puts feed['count']
					block.call(feed['count'])
				end
			end
		end
 	end	
end