class Cookie
	def initialize
		@cookie = {}
	end

	def update(host, cookie)
		puts "to be update #{cookie}"
		if !cookie.nil?
			keyValuePair = cookie.scan(/([^, ;]+)=([^,;]+)/)
			if @cookie[host].nil?
				@cookie[host] = {}
			end
			
			keyValuePair.each do |keyValue|
				if !(keyValue[0] == "Path" || keyValue[0] == "Expires")
					@cookie[host][keyValue[0]] = keyValue[1]
				end
			end
		end
	end

	def getCookie(host)
		if @cookie[host].nil?
			""
		else
			string = @cookie[host].reduce('') { |s, (k,v)|
				s << "#{k}=#{v}; "
			}
			string[0..-3]	
		end
	end

	def get
		@cookie
	end
end
