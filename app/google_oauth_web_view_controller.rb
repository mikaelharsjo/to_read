class GoogleOauthWebViewController < UIViewController
		# https://code.google.com/apis/console/#project:232700103718:access
	CLIENT_ID = '232700103718.apps.googleusercontent.com'
	CLIENT_SECRET = 'msGejkhE_enVitNpjJOYyneN'  
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
		redirect_uri = 'urn:ietf:wg:oauth:2.0:oob' #'http://localhost'
		scope = 'http://www.google.com/reader/api/*'
		response_type = 'code'
		url = "https://accounts.google.com/o/oauth2/auth?response_type=#{response_type}&client_id=#{CLIENT_ID}&redirect_uri=#{redirect_uri}&scope=#{scope}"
		#App.open_url("https://accounts.google.com/o/oauth2/auth?response_type=#{response_type}&client_id=#{CLIENT_ID}&redirect_uri=#{redirect_uri}&scope=#{scope}")

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
		if code
			puts code
		end	
	end
	
	# Enable rotation
	def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
		# On the iPhone, don't rotate to upside-down portrait orientation
		if UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad
			if interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				return false
			end
		end
		true
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