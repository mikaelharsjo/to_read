class AppDelegate
	include BubbleWrap	

	def application(application, didFinishLaunchingWithOptions:launchOptions)
		UIApplication.sharedApplication.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
    	@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    	@window.rootViewController = GoogleOauthWebViewController.alloc.init
    	@window.makeKeyAndVisible		

		true
 	end

 	def getUnreadCount(&block)
 		# TODO: use oauth instead
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
