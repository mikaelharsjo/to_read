class AppDelegate
	include BubbleWrap
	def application(application, didFinishLaunchingWithOptions:launchOptions)
		
		HTTP.get("https://www.google.com/accounts/ClientLogin?service=reader&Email=mikaelharsjo@gmail.com&Passwd=CA5WAC2WpG4LarHuItrmBzzrMZddxdelvIZ81IFhjbnhhpmiJU&accountType=GOOGLE") do |response|
			body = response.body.to_str
			#puts body
			index_of_sid = body.index("SID=") + 4
			index_of_lsid = body.index("LSID=") - 5
			index_of_auth = body.index("Auth=") + 5
			sid = body[index_of_sid, index_of_lsid]
			auth = body[index_of_auth, body.length]
			#puts auth
			
			cookie = {
				Name: 'SID',
				Value: sid,
				Path: '/',
				Domain: '.google.com'
			}

			authorization_header = "GoogleLogin auth=#{auth}" 
			#puts authorization_header

			HTTP.get("http://www.google.com/reader/api/0/unread-count?output=json",
				{
					:headers => {"Authorization" => "GoogleLogin auth=DQAAAOEAAACiztP-p4hWZTohXl-e4LlRlRcCrfrRNV2wW3vGyaPbHKeVwIS3w9RJ0tH3MAdX7RdnXWei2gGthtzNzaAIyyuVhqYdecu_7P3fpIJVW_YCRlcvbzkOcvOS6y3Tx2OvhshLT7oLAiC7x9wusyeQPUPnSwaF8KcbG8fdrjeJ52cGINxbEL47ciwXMfApLyzqHEqdlxO7vihSoU132FXaiIeRE4sjSOEdAPLoENm1nTQ0nKCZgEXBz0m6gx79NldMhmSk3iJD6D5ENwfCF3M7kEU1WILnx2FVGsvKHNMjVShh_2HL0GlWcc18GqCjNK5u7FE"}
				}) do |response|
				#puts response
				unreadcounts = JSON.parse(response.body.to_str)['unreadcounts'] #.unreadcounts
				unreadcounts.each do |feed| 
					puts(feed.count)
				end

				#puts response.body.to_str
			end	
		end
		
		application.applicationIconBadgeNumber = 30
		
		# use bubble-wrap instead?
		url = NSURL.URLWithString("http://www.google.com/reader")
		UIApplication.sharedApplication.openURL(url)

	#if (![[UIApplication.sharedApplication] openURL:url])
	#NSLog(@"%@%@",@"Failed to open url:",[url description]);
		true
 	end
end

class GoogleAuthenticator
	def fetch_sid		
		BubbleWrap::HTTP.get("https://www.google.com/accounts/ClientLogin?service=reader&Email=mikaelharsjo@gmail.com&Passwd=CA5WAC2WpG4LarHuItrmBzzrMZddxdelvIZ81IFhjbnhhpmiJU") do |response|
			body = response.body.to_str
			index_of_sid = body.index("SID=") + 4
			index_of_lsid = body.index("LSID=") - 5
			sid = body[index_of_sid, index_of_lsid]
			puts 'ss'
			#puts "sid #{@sid}"
		end
	end
end
