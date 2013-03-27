#!/usr/bin/ruby

require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get("https://jigsaw.thoughtworks.com/")

form = page.forms.first

form.username = "ljliu"
puts "Please input password:"
form.password = gets.chomp
agent.submit(form)

page = agent.page.link_with(:text => 'Assignments').click

page = agent.submit(page.forms[2], page.forms[2].buttons.first)
#pp page
page2 = agent.get("https://jigsaw.thoughtworks.com/assignment_schedule/consultant_info?page=2&per_page=116&utf8=%E2%9C%93&criteria%5Bbusiness_unit%5D=1649050217%3AChina&criteria%5Boffice%5D=10100%2C10140%2C56723499%2C274224486&criteria%5Boffice_type%5D=ConsultantStaffingInOffice&criteria%5Bstart_date%5D=Mar-25-2013")


page2.links_with(:href => /\/consultants\/.+/).each do |link|
	puts link.text
end

