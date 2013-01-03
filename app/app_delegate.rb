class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.applicationIconBadgeNumber = 30
    url = NSURL.URLWithString("http://www.google.com/reader")
	UIApplication.sharedApplication.openURL(url)

	#if (![[UIApplication.sharedApplication] openURL:url])
	#NSLog(@"%@%@",@"Failed to open url:",[url description]);
    true
  end
end
