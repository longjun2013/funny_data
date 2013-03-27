#!/usr/bin/ruby

require './Jigsaw'

jigsaw = Jigsaw.new
response = jigsaw.fetch("https://jigsaw.thoughtworks.com/")

resp = jigsaw.postUserInfo("https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F");
puts resp.body

jigsaw.fetch(resp['location'])
resp1 = jigsaw.postUserInfo("https://cas.thoughtworks.com/cas/login?service=https%3A%2F%2Fjigsaw.thoughtworks.com%2F")
puts resp1.body


resp2 = jigsaw.fetch(resp['location'])
puts resp2.body

