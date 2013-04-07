#!/usr/bin/ruby

require 'rubygems'
require 'mechanize'
require 'date'

File.open("data.txt", 'w') {}
agent = Mechanize.new
page = agent.get("https://jigsaw.thoughtworks.com/")

form = page.forms.first

form.username = "ljliu"
`stty -echo`
puts "Please input password:"
form.password = gets.chomp
`stty echo`
agent.submit(form)

page = agent.page.link_with(:text => 'Assignments').click

def fetchInfo(agent, link)
	line = link.text << "#"
	profilePage = agent.get("https://jigsaw.thoughtworks.com#{link.href}");
	peul = profilePage.search(".//div[@id='project_experiences']")[0].children[1]
	pelis = peul.children.filter(".//li")
	pelis.each do |e|
		spans = e.children.filter(".//span")
		
		from_date = spans[0].children.filter(".//span")[0].text
		line << Date.strptime(from_date, "%b %d, %Y").strftime("%Y%m%d")
		line << " - "
		end_date = spans[0].children.filter(".//span")[1].text
		line << Date.strptime(end_date, "%b %d, %Y").strftime("%Y%m%d")
	
		line << "|"
		line << spans[2].children.filter(".//a")[0].text
		line << "||"
	end
	puts line
	File.open("data.txt",'a') {|file| file.write("#{line}\n")}
end

page1 = agent.submit(page.forms[2], page.forms[2].buttons.first)

page1.links_with(:href => /\/consultants\/[0-9]+/).each do |link|
	fetchInfo(agent, link)
end

page2 = agent.get("https://jigsaw.thoughtworks.com/assignment_schedule/consultant_info?page=2&per_page=116&utf8=%E2%9C%93&criteria%5Bbusiness_unit%5D=1649050217%3AChina&criteria%5Boffice%5D=10100%2C10140%2C56723499%2C274224486&criteria%5Boffice_type%5D=ConsultantStaffingInOffice&criteria%5Bstart_date%5D=Mar-25-2013")

page2.links_with(:href => /\/consultants\/[0-9]+/).each do |link|
	fetchInfo(agent, link)
end

