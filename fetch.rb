#!/usr/bin/ruby

require 'net/http'
require 'net/https'


cookie = "";
def fetch(uri, cookie)
	uri = URI.parse(uri);
	http = Net::HTTP.new(uri.host, uri.port);
	http.use_ssl = true;

	request = Net::HTTP::Get.new(uri.path);
	request['Set-Cookie'] = cookie;
	res = http.start{|http| http.request(request)}
	case res
		when Net::HTTPRedirection then
			location = res['location']
			warn "redirected to #{location}"
			cookie = res['set-cookie'];
			fetch(location,cookie)
		else
			res;
	end
end

casResp = fetch("https://jigsaw.thoughtworks.com/", cookie);
cookie = casResp.response['set-cookie']


lt = casResp.body.match(/type="hidden" name="lt" value="(.*)"/).captures
execution = casResp.body.match(/type="hidden" name="execution" value="(.*)"/).captures
_eventId = casResp.body.match(/type="hidden" name="_eventId" value="(.*)"/).captures

puts lt;
puts execution;
puts _eventId;

puts cookie;
def post(uri, cookie, lt, execution, _eventId, password)
	uri = URI.parse(uri);
	http = Net::HTTP.new(uri.host, uri.port);
	http.use_ssl = true;

	request = Net::HTTP::Post.new(uri.path);
	request.set_form_data('username' => 'ljliu', 'password' => password, 'lt' => lt, 'execution' => execution, '_eventId' => _eventId, 'submit' => 'LOGIN');
	request['Set-Cookie'] = cookie;
	request['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1"
	request['Refer'] = "https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F"
	request['Accept'] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
	res = http.start{|http| http.request(request)}
	case res
		when Net::HTTPRedirection then
			location = res['location']
			warn "redirected to #{location}"
			res;
		else
			res;
	end
end

resp = post("https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F", cookie, lt, execution, _eventId, 'fdsa');

cookie = resp['set-cookie'];

resp2 = fetch(resp['location'], cookie);
lt = resp2.body.match(/type="hidden" name="lt" value="(.*)"/).captures
execution = resp2.body.match(/type="hidden" name="execution" value="(.*)"/).captures
_eventId = resp2.body.match(/type="hidden" name="_eventId" value="(.*)"/).captures

resp3 = post(resp['location'], cookie, lt, execution, _eventId, "14175674");

puts resp3;

