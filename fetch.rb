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

puts fetch("https://jigsaw.thoughtworks.com/");
