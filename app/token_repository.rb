class TokenRepository
	def initialize
		@google_access_tokens = NSUserDefaults.standardUserDefaults
	end

	def save(key, value)
		@google_access_tokens.setObject(value, forKey: key)
	end

	def get(key)
		@google_access_tokens.stringForKey key
	end	
end