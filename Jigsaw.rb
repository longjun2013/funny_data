require 'net/http'
require 'net/https'
require './Cookie'

class Jigsaw
	def initialize
		@cookie = Cookie.new
		@response
		@uri
	end	

	def login
		fetch("https://jigsaw.thoughtworks.com/")
		postUserInfo()
	end

	def fetch(url)	
		uri = URI.parse(url);
		@uri = uri;
		http = Net::HTTP.new(uri.host, uri.port);
		http.use_ssl = true;

		request = Net::HTTP::Get.new(uri.path);
		request['Set-Cookie'] = @cookie.getCookie(uri.host);
		@response = http.start{|http| http.request(request)}
		case @response
			when Net::HTTPRedirection then
				location = @response['location']
				puts "existing cookie: #{@cookie.getCookie(uri.host)}"
				@cookie.update(uri.host, @response['set-cookie']);
				puts "cookie after update: #{@cookie.getCookie(uri.host)} "
				warn "redirected to #{location}"
				fetch(location)
			else
				puts "existing cookie: #{@cookie.getCookie(uri.host)}"
				@cookie.update(uri.host, @response['set-cookie']);
				puts "cookie after update: #{@cookie.getCookie(uri.host)} "
				puts @response.body;
		end
	end

	def postUserInfo
		lt = @response.body.match(/type="hidden" name="lt" value="(.*)"/).captures
		execution = @response.body.match(/type="hidden" name="execution" value="(.*)"/).captures
		_eventId = @response.body.match(/type="hidden" name="_eventId" value="(.*)"/).captures

		uri = @uri
		http = Net::HTTP.new(uri.host, uri.port);
		http.use_ssl = true;
	
		request = Net::HTTP::Post.new(uri.path);
		puts "Please input password:"
		password = gets.chomp
		request.set_form_data('username' => 'ljliu', 'password' => password, 'lt' => lt, 'execution' => execution, '_eventId' => _eventId, 'submit' => 'LOGIN');
		request['set-cookie'] = @cookie.getCookie(uri.host);
		request['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1"
		request['Refer'] = "https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F"
		request['Accept'] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
		@response = http.start{|http| http.request(request)}
		case @response
			when Net::HTTPRedirection then
				location = @response['location']
				puts "existing cookie: #{@cookie.getCookie(uri.host)}"
				@cookie.update(uri.host, @response['Set-Cookie'])
				puts "cookie after update: #{@cookie.getCookie(uri.host)} "
				warn "post user info, but redirected to #{location}"
				@response
			else
				puts "existing cookie: #{@cookie.getCookie(uri.host)}"
				@cookie.update(uri.host, @response['set-cookie'])
				puts "cookie after update: #{@cookie.getCookie(uri.host)} "
				@response;
		end
	end

	def test
		puts 'test'
	end
end
