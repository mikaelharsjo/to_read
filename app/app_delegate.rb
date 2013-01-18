class AppDelegate
	include BubbleWrap	

	def application(application, didFinishLaunchingWithOptions:launchOptions)
		UIApplication.sharedApplication.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
    	@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    	@window.rootViewController = WebViewController.alloc.init
    	@window.makeKeyAndVisible
		#redirect_uri = 'urn:ietf:wg:oauth:2.0:oob' #'http://localhost'
		#scope = 'http://www.google.com/reader/api/*'
		#response_type = 'code'
		#App.open_url("https://accounts.google.com/o/oauth2/auth?response_type=#{response_type}&client_id=#{CLIENT_ID}&redirect_uri=#{redirect_uri}&scope=#{scope}")

		#signInAndGetUnreadCount do |count| 
		#	puts(count)
		#end
		
		# use bubble-wrap instead?
		#url = NSURL.URLWithString("http://www.google.com/reader")
		#UIApplication.sharedApplication.openURL(url)		

		true
 	end

 	def signInAndGetUnreadCount(&block)
 		HTTP.get("https://www.google.com/accounts/ClientLogin?service=reader&Email=mikaelharsjo@gmail.com&Passwd=CA5WAC2WpG4LarHuItrmBzzrMZddxdelvIZ81IFhjbnhhpmiJU&accountType=GOOGLE&continue=http://www.google.com&source=to_read") do |response|
 			@authCookie = parseCookie(response)
 			getUnreadCount(&block)
 		end
 	end

 	def parseCookie(response)
		body = response.body.to_str
		#index_of_sid = body.index("SID=") + 4
		#index_of_lsid = body.index("LSID=") - 5
		index_of_auth = body.index("Auth=") + 5
		#sid = body[index_of_sid, index_of_lsid]
		#puts "sid: #{sid}...."
		#return sid
		body[index_of_auth, body.length]
 	end

 	def getUnreadCount(&block)
 		# TODO: fix later
 		puts "authCookie: #{@authCookie}"
 		#@authCookie = 'DQAAAOEAAACiztP-p4hWZTohXl-e4LlRlRcCrfrRNV2wW3vGyaPbHKeVwIS3w9RJ0tH3MAdX7RdnXWei2gGthtzNzaAIyyuVhqYdecu_7P3fpIJVW_YCRlcvbzkOcvOS6y3Tx2OvhshLT7oLAiC7x9wusyeQPUPnSwaF8KcbG8fdrjeJ52cGINxbEL47ciwXMfApLyzqHEqdlxO7vihSoU132FXaiIeRE4sjSOEdAPLoENm1nTQ0nKCZgEXBz0m6gx79NldMhmSk3iJD6D5ENwfCF3M7kEU1WILnx2FVGsvKHNMjVShh_2HL0GlWcc18GqCjNK5u7FE'
		puts "authCookie: #{@authCookie}"
		HTTP.get("http://www.google.com/reader/api/0/unread-count?output=json",
		{
			:headers => {"Authorization" => "GoogleLogin auth=#{@authCookie}"}
		}) do |response|
		
			json = JSON.parse(response.body.to_str)
			json['unreadcounts'].each do |feed|
				if feed['id'].include? 'com.google/reading-list'
					block.call(feed['count'])
				end
			end
		end
 	end
end
