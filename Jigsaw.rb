require 'net/http'
require 'net/https'

class Jigsaw
	def initialize
		@cookie = ''
		@response
	end	

	def fetch(url)	
		uri = URI.parse(url);
		http = Net::HTTP.new(uri.host, uri.port);
		http.use_ssl = true;

		request = Net::HTTP::Get.new(uri.path);
		request['Set-Cookie'] = @cookie;
		@response = http.start{|http| http.request(request)}
		case @response
			when Net::HTTPRedirection then
				location = @response['location']
				warn "redirected to #{location}"
				puts "existing cookie: #{@cookie}"
				@cookie = @response['set-cookie'];
				puts "cookie from response: #{@cookie} "
				fetch(location)
			else
				puts "existing cookie: #{@cookie}"
				if !@response['set-cookie'].nil? && !url.include?("jigsaw.thoughtworks.com")
					@cookie = @response['set-cookie'];
				end
				puts "cookie from response: #{@cookie} "
				@response;
		end
	end

	def postUserInfo(uri)
		lt = @response.body.match(/type="hidden" name="lt" value="(.*)"/).captures
		execution = @response.body.match(/type="hidden" name="execution" value="(.*)"/).captures
		_eventId = @response.body.match(/type="hidden" name="_eventId" value="(.*)"/).captures

		uri = URI.parse(uri);
		http = Net::HTTP.new(uri.host, uri.port);
		http.use_ssl = true;
	
		request = Net::HTTP::Post.new(uri.path);
		puts "Please input password:"
		password = gets.chomp
		request.set_form_data('username' => 'ljliu', 'password' => password, 'lt' => lt, 'execution' => execution, '_eventId' => _eventId, 'submit' => 'LOGIN');
		request['Set-Cookie'] = @cookie;
		request['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1"
		request['Refer'] = "https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F"
		request['Accept'] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
		@response = http.start{|http| http.request(request)}
		case @response
			when Net::HTTPRedirection then
				location = @response['location']
				warn "post user info, but redirected to #{location}"
				puts "existing cookie: #{@cookie}"
				@cookie = @response['set-cookie']
				puts "cookie from response: #{@cookie} "
				@response
			else
				puts "existing cookie: #{@cookie}"
				if @response['set-cookie'].include?("CASTGC")
					@cookie = "#{@cookie}, #{@response['set-cookie']}"
				else
					@cookie = @response['set-cookie']
				end
				puts "cookie after change: #{@cookie} "
				@response;
		end
	end

	def test
		puts 'test'
	end
end
