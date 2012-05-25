require 'fastercsv' #
require 'csv'
class PageController < ApplicationController
	def index		
	end

	def overview
		@csv_file = 'data/latest_overview_aspect_data.csv'
	end

	def programmingLanguages
		@csv_file = 'data/latest_pl_aspect_data.csv'
		@current_path = programmingLanguages_path
		@title = 'Programming Languages'
	end

	def webFrameworks
		@csv_file = 'data/latest_wf_aspect_data.csv'
		@current_path = webFrameworks_path
		@title = 'Web Frameworks'
	end

	def contentManagementSystems
		@csv_file = 'data/latest_cms_aspect_data.csv'
		@current_path = contentManagementSystems_path
		@title = 'Content Management Systems'
	end

	def technology
		@title = params[:tech].capitalize
	end

	def about
		@title = 'About'
	end

	def help
		@title = 'Help'
	end

	def search
		query = params[:tech].downcase
		query_found = false
		query_category = ''
		FasterCSV.foreach("public/data/latest_overview_aspect_data.csv", :headers => true) do |csv_obj|
			if csv_obj['technology'] == query
				query_found = true
				query_category = full_category(csv_obj['category'])
			end
		end

		if query_found
			redirect_to "/#{query_category}/technology/#{query}"
		else
			redirect_to "/404/#{query_category}/technology/#{query}"
		end
	end

	def full_category(category)
		if category == "wf"
			"web-frameworks"
		elsif category == "cms"
			"content-management-systems"
		elsif category == "pl"
			"programming-languages"
		end
	end
end
