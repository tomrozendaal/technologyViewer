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

		@top_rated = Hash.new
		@total_total = 0
		@total_adoption = 0
		@total_evolution = 0
		@total_knowledge = 0
		@total_newsvalue = 0
		@total_sentiment = 0
		FasterCSV.foreach("public/#{@csv_file}", :headers => true) do |csv_obj|
			@top_rated["#{csv_obj['technology']}".to_sym] = 
				{
					:adoption => Integer(csv_obj['adoption']), 
					:evolution => Integer(csv_obj['adoption']), 
					:knowledge => Integer(csv_obj['knowledge']), 
					:sentiment => Integer(csv_obj['sentiment']),
					:newsvalue => Integer(csv_obj['adoption']),
					:total => Integer(csv_obj['total']),
					:category => csv_obj['category']
				}
				
			@total_total = @total_total + Integer(csv_obj['total'])
			@total_adoption = @total_adoption + Integer(csv_obj['adoption'])
			@total_evolution = @total_evolution + Integer(csv_obj['adoption'])
			@total_knowledge = @total_knowledge + Integer(csv_obj['knowledge'])
			@total_newsvalue = @total_newsvalue + Integer(csv_obj['adoption'])
			@total_sentiment = @total_sentiment + Integer(csv_obj['sentiment'])

		end
		#@top_rated.sort_by { |k, v| v[:sentiment] }
		#@top_rated.sort
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
		@tech_data = {}
		FasterCSV.foreach("public/data/latest_overview_aspect_data.csv", :headers => true) do |csv_obj|
			if csv_obj['technology'] == params[:tech]
				@tech_data['adoption'] = csv_obj['adoption']
				@tech_data['knowledge'] = csv_obj['knowledge']
				@tech_data['sentiment'] = csv_obj['sentiment']
			end
		end
		FasterCSV.foreach("public/data/latest_metrics_data.csv", :headers => true) do |csv_obj|
			if csv_obj['technology'] == params[:tech]
				# Adoption
				@tech_data['jobs'] = ts csv_obj['job_amount']
				@tech_data['people'] = ts csv_obj['people_amount']

				# Knowledge
				@tech_data['books'] = ts csv_obj['amazon_books']
				@tech_data['learning_materials'] = ts csv_obj['learning_materials']
				@tech_data['answered_percentage'] = ts csv_obj['answered_percentage']

				# Sentiment
				@tech_data['ratio'] = ts csv_obj['positive_ratio']
			end
		end
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

	def ts( st )
	  st = st.reverse
	  r = ""
	  max = if st[-1].chr == '-'
	    st.size - 1
	  else
	    st.size
	  end
	  if st.to_i == st.to_f
	    1.upto(st.size) {|i| r << st[i-1].chr ; r << ',' if i%3 == 0 and i < max}
	  else
	    start = nil
	    1.upto(st.size) {|i|
	      r << st[i-1].chr
	      start = 0 if r[-1].chr == '.' and not start
	      if start
	        r << ',' if start % 3 == 0 and start != 0  and i < max
	        start += 1
	      end
	    }
	  end
	  r.reverse
	end
end
