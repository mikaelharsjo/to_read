class GoogleOauthWebViewController < UIViewController
	include BubbleWrap
	#include URI
	# https://code.google.com/apis/console/#project:232700103718:access
	CLIENT_ID = '232700103718-g143gh9ldfr2ehr79jffeti5us2f6i7k.apps.googleusercontent.com'   #web app '232700103718-dvs6lvd99smtrsa35acsrmb1mfjmhhmg.apps.googleusercontent.com' #'232700103718.apps.googleusercontent.com'
	CLIENT_SECRET = '9nOVefsxHSxKjGfuZdxujy6u' #'Z78cwB1VMFr6cs6L_MvHb4-p' #'msGejkhE_enVitNpjJOYyneN'
	REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob' #'https://developers.google.com/oauthplayground'
	def loadView
		# Background color while loading and scrolling beyond the page boundaries
		background = UIColor.blackColor
		self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
		self.view.backgroundColor = background
		webFrame = UIScreen.mainScreen.applicationFrame
		webFrame.origin.y = 0.0
		@webView = UIWebView.alloc.initWithFrame(webFrame)
		@webView.backgroundColor = background
		@webView.scalesPageToFit = true
		@webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
		@webView.delegate = self
		#@webView.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('index2', ofType:'html'))))
		#redirect_uri = 'urn:ietf:wg:oauth:2.0:oob' #'http://localhost'
		scope = 'http://www.google.com/reader/api/*'
		response_type = 'code'
		# from playground
		#url = "https://accounts.google.com/o/oauth2/auth?redirect_uri=#{redirect_uri}&response_type=code&client_id=#{CLIENT_ID}&approval_prompt=force&scope=http%3A%2F%2Fwww.google.com%2Freader%2Fapi%2F%2A&access_type=offline"
		url = "https://accounts.google.com/o/oauth2/auth?redirect_uri=#{REDIRECT_URI}&response_type=#{response_type}&client_id=#{CLIENT_ID}&approval_prompt=force&scope=#{scope}&access_type=offline"

		@webView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(url)))
		#@webView.loadHTMLString('<h1><a href="http://www.fngtps.com">Click me!</h1>', baseURL:nil)
	end
	
	# Remove the following if you're showing a status bar that's not translucent
	def wantsFullScreenLayout
		true
	end
	
	# Only add the web view when the page has finished loading
	def webViewDidFinishLoad(webView)
		self.view.addSubview(@webView)
	# get code if authentication is done

		code = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('code').value")

		unless code.empty? 
			#puts code
			url_string = "https://accounts.google.com/o/oauth2/token"
			post_body = "code=#{code}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=#{REDIRECT_URI}&grant_type=authorization_code"
			url = NSURL.URLWithString(url_string)

			request = NSMutableURLRequest.requestWithURL(url)
			request.setTimeoutInterval(30)
			request.setHTTPMethod("POST")
			request.setHTTPBody(post_body.to_s.dataUsingEncoding(NSUTF8StringEncoding))
			queue = NSOperationQueue.alloc.init

			NSURLConnection.sendAsynchronousRequest(request,
				queue: queue,
				completionHandler: lambda do |response, data, error|
				if(data.length > 0 && error.nil?)
					json = JSON.parse data

					p json
					p json['token_type']
					#p data
					#p response
					#html = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)
					#puts data.access_token
					#puts data.token_type
					#puts data.expires_in
					#puts refresh_token
					p "HTML = #{html}"
				elsif( data.length == 0 && error.nil? )
					p "Nothing was downloaded"
				elsif(!error.nil?)
					p "Error: #{error}"
				end
				end
			)

			#webView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString('http://google.com/reader')))
		end	
	end
	
	# Open absolute links in Mobile Safari
	def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)
		if inType == UIWebViewNavigationTypeLinkClicked && inRequest.URL.scheme != 'file' 
			UIApplication.sharedApplication.openURL(inRequest.URL)
			return false
		end
		true
	end
end