require 'net/http'
require 'net/https'

def fetch(uri)
	uri = URI.parse(uri);
	http = Net::HTTP.new(uri.host, uri.port);
	http.use_ssl = true;

	request = Net::HTTP::Get.new(uri.path);
	res = http.start{|http| http.request(request)}
	case res
		when Net::HTTPRedirection then
			location = res['location']
			warn "redirected to #{location}"
			fetch(location)
		else
			res;
	end
end

fetch("https://jigsaw.thoughtworks.com/");
def post(uri)
	uri = URI.parse(uri);
	http = Net::HTTP.new(uri.host, uri.port);
	http.use_ssl = true;

	request = Net::HTTP::Post.new(uri.path);
	request.set_form_data('username' => 'ljliu', 'password' => '42031341');
	res = http.start{|http| http.request(request)}
	case res
		when Net::HTTPRedirection then
			location = res['location']
			warn "redirected to #{location}"
			fetch(location)
		else
			res;
	end
end

puts "submit"
puts post("https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F");

