#!/usr/bin/ruby

require 'date'

class Consultant
	def initialize(name)
		@name = name
		@projects = []
	end
	
	def name
		return @name
	end

	def << (project)
		@projects << project
	end

	def getWorkingProject(date)
		@projects.each do |p|
			return p if p.isDuring?(date)
		end
		nil
	end

	def to_s
		"#{@name} join #{@projects} projects."
	end
end

class Project
	def initialize(name, startDate, endDate)
		@name = name
		@startDate = startDate
		@endDate = endDate
	end

	def isDuring?(date)
		date >= @startDate  && date <= @endDate
	end	
	
	def name
		return @name
	end

	def to_s
		"#{@name}: from #{@startDate} to #{@endDate} || "
	end
end

class TimelineSlice
	def initialize(date)
		@date = date
		@projects = {}
	end

	def add(projectName,consultantName)
		@projects[projectName] = [] if @projects[projectName].nil?
		@projects[projectName] |= [consultantName]
	end

	def to_s
		line = "#{@date}\n"
		
		line << @projects.reduce("") { |s, (k, v)|
			s << "#{k}: #{v.join(', ')}\n"
		}	
	end
end

class TimelineAnalysis
	def initialize
		@consultants = []
		@timelineStart = Date.strptime("20060101", "%Y%m%d")
		@timelineEnd = Date.strptime("20130401", "%Y%m%d")
		@timelineSlices = []
	end	

	def process
		loadData
		analysis
	end

	def loadData
		File.readlines('origin_data.txt').each do |line|
			line = line.chomp
			consultantName = line.scan(/[^#]+/)[0]
			consultant = Consultant.new(consultantName)	

			next if line.scan(/[^#]+/)[1].nil?
			projectsString = line.scan(/[^#]+/)[1].split("||")
			projectsString.each do |s|
				name = s.split("|")[1]
				startDate = Date.strptime(s.split("|")[0].split(" - ")[0], "%Y%m%d")
				endDate = Date.strptime(s.split("|")[0].split(" - ")[1], "%Y%m%d")
				project = Project.new(name, startDate, endDate)
				consultant << project
			end
			@consultants <<  consultant
		end	
	end

	def analysis
		week_iterate(@timelineStart, @timelineEnd) do |date| 
			timelineSlice = TimelineSlice.new(date)
			@consultants.each do |c|
				project = c.getWorkingProject(date)
				next if project.nil?
				timelineSlice.add(project.name, c.name)
			end
			@timelineSlices << timelineSlice
		end
		puts @timelineSlices
	end

	def week_iterate(startTime, endTime, &block)
		begin
			yield(startTime)
		end while (startTime += 7) <= endTime
	end
end

TimelineAnalysis.new.process


