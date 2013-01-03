class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.applicationIconBadgeNumber = 30
    puts "#{App.name} (#{App.documents_path})"
    true
  end
end
