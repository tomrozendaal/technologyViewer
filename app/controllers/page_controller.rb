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
	end

	def webFrameworks
		@csv_file = 'data/latest_wf_aspect_data.csv'
	end

	def contentManagementSystems
		@csv_file = 'data/latest_cms_aspect_data.csv'
	end
end
