class AppDelegate
	def application(application, didFinishLaunchingWithOptions:launchOptions)
		BubbleWrap::HTTP.get("https://www.google.com/accounts/ClientLogin?service=reader&Email=mikaelharsjo@gmail.com&Passwd=CA5WAC2WpG4LarHuItrmBzzrMZddxdelvIZ81IFhjbnhhpmiJU") do |response|
			body = response.body.to_str
			index_of_sid = body.index("SID=") + 4
            index_of_lsid = body.index("LSID=") - 5
            sid = resp[index_of_sid, index_of_lsid]
			puts sid
		end

		#BubbleWrap::HTTP.get("http://www.google.com/reader/api/0/unread-count?output=json") do |response|
		#	puts response
			#unread_counts = BubbleWrap::JSON.parse(response.body.to_str)["unreadcounts"]
			#puts response.unreadcounts
		#end
		
		application.applicationIconBadgeNumber = 30
		
		# use bubble-wrap instead?
		url = NSURL.URLWithString("http://www.google.com/reader")
		UIApplication.sharedApplication.openURL(url)

	#if (![[UIApplication.sharedApplication] openURL:url])
	#NSLog(@"%@%@",@"Failed to open url:",[url description]);
		true
 	end
end
