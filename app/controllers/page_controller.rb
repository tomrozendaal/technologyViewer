#require 'fastercsv' #
require 'csv'
class PageController < ApplicationController
	def index		
	end

	def overview
		@csv_file = 'data/latest_overview_aspect_data.csv'
	end

	def programmingLanguages
		@csv_file = 'data/latest_pl_aspect_data.csv'
		@history_file = 'data/history_pl_aspect_data.csv'
		@current_path = programmingLanguages_path
		@title = 'Programming Languages'

		@top_rated = Hash.new
		@total_total = 0
		@total_adoption = 0
		@total_evolution = 0
		@total_knowledge = 0
		@total_newsvalue = 0
		@total_sentiment = 0
		CSV.foreach("public/#{@csv_file}", :headers => true) do |csv_obj|
			@top_rated["#{csv_obj['technology']}".to_sym] = 
				{
					:adoption => Integer(csv_obj['adoption']), 
					:evolution => Integer(csv_obj['evolution']), 
					:knowledge => Integer(csv_obj['knowledge']), 
					:sentiment => Integer(csv_obj['sentiment']),
					:newsvalue => Integer(csv_obj['newsworthiness']),
					:total => Integer(csv_obj['total']),
					:category => csv_obj['category'],
					:technology => csv_obj['technology']
				}
				
			@total_total = @total_total + Integer(csv_obj['total'])
			@total_adoption = @total_adoption + Integer(csv_obj['adoption'])
			@total_evolution = @total_evolution + Integer(csv_obj['adoption'])
			@total_knowledge = @total_knowledge + Integer(csv_obj['knowledge'])
			@total_newsvalue = @total_newsvalue + Integer(csv_obj['adoption'])
			@total_sentiment = @total_sentiment + Integer(csv_obj['sentiment'])
		end
		if @total_sentiment <= 0
			@total_sentiment = 50
		end

		@rising_tech = get_rising(@history_file, @top_rated)
		@declining_tech = get_declining(@history_file, @top_rated)
	end

	def webFrameworks
		@csv_file = 'data/latest_wf_aspect_data.csv'
		@history_file = 'data/history_wf_aspect_data.csv'
		@current_path = webFrameworks_path
		@title = 'Web Frameworks'

		@top_rated = Hash.new
		@total_total = 0
		@total_adoption = 0
		@total_evolution = 0
		@total_knowledge = 0
		@total_newsvalue = 0
		@total_sentiment = 0
		CSV.foreach("public/#{@csv_file}", :headers => true) do |csv_obj|
			@top_rated["#{csv_obj['technology']}".to_sym] = 
				{
					:adoption => Integer(csv_obj['adoption']), 
					:evolution => Integer(csv_obj['evolution']), 
					:knowledge => Integer(csv_obj['knowledge']), 
					:sentiment => Integer(csv_obj['sentiment']),
					:newsvalue => Integer(csv_obj['newsworthiness']),
					:total => Integer(csv_obj['total']),
					:category => csv_obj['category'],
					:technology => csv_obj['technology']
				}
				
			@total_total = @total_total + Integer(csv_obj['total'])
			@total_adoption = @total_adoption + Integer(csv_obj['adoption'])
			@total_evolution = @total_evolution + Integer(csv_obj['adoption'])
			@total_knowledge = @total_knowledge + Integer(csv_obj['knowledge'])
			@total_newsvalue = @total_newsvalue + Integer(csv_obj['adoption'])
			@total_sentiment = @total_sentiment + Integer(csv_obj['sentiment'])
		end
		if @total_sentiment <= 0
			@total_sentiment = 50
		end

		@rising_tech = get_rising(@history_file, @top_rated)
		@declining_tech = get_declining(@history_file, @top_rated)
	end

	def contentManagementSystems
		@csv_file = 'data/latest_cms_aspect_data.csv'
		@history_file = 'data/history_cms_aspect_data.csv'
		@current_path = contentManagementSystems_path
		@title = 'Content Management Systems'

		@top_rated = Hash.new
		@total_total = 0
		@total_adoption = 0
		@total_evolution = 0
		@total_knowledge = 0
		@total_newsvalue = 0
		@total_sentiment = 0
		CSV.foreach("public/#{@csv_file}", :headers => true) do |csv_obj|
			@top_rated["#{csv_obj['technology']}".to_sym] = 
				{
					:adoption => Integer(csv_obj['adoption']), 
					:evolution => Integer(csv_obj['evolution']), 
					:knowledge => Integer(csv_obj['knowledge']), 
					:sentiment => Integer(csv_obj['sentiment']),
					:newsvalue => Integer(csv_obj['newsworthiness']),
					:total => Integer(csv_obj['total']),
					:category => csv_obj['category'],
					:technology => csv_obj['technology']
				}
				
			@total_total = @total_total + Integer(csv_obj['total'])
			@total_adoption = @total_adoption + Integer(csv_obj['adoption'])
			@total_evolution = @total_evolution + Integer(csv_obj['adoption'])
			@total_knowledge = @total_knowledge + Integer(csv_obj['knowledge'])
			@total_newsvalue = @total_newsvalue + Integer(csv_obj['adoption'])
			@total_sentiment = @total_sentiment + Integer(csv_obj['sentiment'])
		end
		if @total_sentiment <= 0
			@total_sentiment = 50
		end

		@rising_tech = get_rising(@history_file, @top_rated)
		@declining_tech = get_declining(@history_file, @top_rated)
	end

	def technology
		@current_path = "/#{request.fullpath.split("/")[1]}"
		@title = request.fullpath.split("/")[1]

		@tech_title = params[:tech].capitalize
		@tech_data = {}
		
		category = ""
		CSV.foreach("public/data/latest_metrics_data.csv", :headers => true) do |csv_obj|
			if csv_obj['technology'] == params[:tech]
				# Adoption
				@tech_data['jobs'] = ts csv_obj['job_amount']
				@tech_data['people'] = ts csv_obj['people_amount']

				# Knowledge
				@tech_data['books'] = ts csv_obj['amazon_books']
				@tech_data['learning_materials'] = ts csv_obj['learning_materials']
				@tech_data['answered_percentage'] = ts csv_obj['answered_percentage']

				# Sentiment
				if csv_obj['positive_ratio'].to_i < 0
					ratio = csv_obj['positive_ratio'].gsub!('-','')
					@tech_data['ratio'] = "1:#{ratio}"
				elsif csv_obj['positive_ratio'].to_i == 0
					@tech_data['ratio'] = "0:0"
				else
					@tech_data['ratio'] = "#{csv_obj['positive_ratio']}:1"
				end
				@tech_data['positive_mes'] = ts csv_obj['positive_messages']
				@tech_data['neutral_mes'] = ts csv_obj['neutral_messages']
				@tech_data['negative_mes'] = ts csv_obj['negative_messages']

				# Newsworthiness
				@tech_data['actuality'] = ts csv_obj['newsworthiness']

				# Miscellaneous
				@tech_data['description'] = csv_obj['description']
				@tech_data['logo'] = csv_obj['logo']
				category = csv_obj['category']
			end
		end

		CSV.foreach("public/data/latest_#{category}_aspect_data.csv", :headers => true) do |csv_obj|
			if csv_obj['technology'] == params[:tech]
				@tech_data['adoption'] = csv_obj['adoption']
				@tech_data['knowledge'] = csv_obj['knowledge']
				@tech_data['sentiment'] = csv_obj['sentiment']
				@tech_data['newsworthiness'] = csv_obj['newsworthiness']
				@tech_data['evolution'] = csv_obj['evolution']
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
		CSV.foreach("public/data/technologies.csv", :headers => true) do |csv_obj|

			if csv_obj['technology'] == query
				query_found = true
				query_category = full_category(csv_obj['category'])
			end
		end

		if query.include? " "
			query.gsub!(' ','-')
		end


		if query_found
			redirect_to "/#{query_category}/technology/#{query}"
		else
			redirect_to "/404/#{query_category}/technology/#{query}"
		end
	end

	def get_rising(file, latest)
		rising_tech = Hash.new
		CSV.foreach("public/#{file}", :headers => true) do |history_tech|
			latest.each_with_index do |latest_tech, index|
				if latest_tech[1][:technology] == history_tech['technology']
					if latest_tech[1][:total].to_i > history_tech['total'].to_i 
						rising_tech["#{latest_tech[1][:technology]}".to_sym] = 
						{
							:adoption => Integer(latest_tech[1][:adoption]), 
							:evolution => Integer(latest_tech[1][:evolution]), 
							:knowledge => Integer(latest_tech[1][:knowledge]), 
							:sentiment => Integer(latest_tech[1][:sentiment]),
							:newsvalue => Integer(latest_tech[1][:newsvalue]),
							:total => Integer(latest_tech[1][:total]),
							:total_old => Integer(history_tech['total']),
							:category => latest_tech[1][:category],
							:technology => latest_tech[1][:technology],
							:increase => (((latest_tech[1][:total].to_f - history_tech['total'].to_f) / latest_tech[1][:total].to_f) * 100).ceil
						}
					end
				end
			end
		end
		return rising_tech
	end

	def get_declining(file, latest)
		declining_tech = Hash.new
		CSV.foreach("public/#{file}", :headers => true) do |history_tech|
			latest.each_with_index do |latest_tech, index|
				if latest_tech[1][:technology] == history_tech['technology']
					if latest_tech[1][:total].to_i < history_tech['total'].to_i 
						declining_tech["#{latest_tech[1][:technology]}".to_sym] = 
						{
							:adoption => Integer(latest_tech[1][:adoption]), 
							:evolution => Integer(latest_tech[1][:evolution]), 
							:knowledge => Integer(latest_tech[1][:knowledge]), 
							:sentiment => Integer(latest_tech[1][:sentiment]),
							:newsvalue => Integer(latest_tech[1][:newsvalue]),
							:total => Integer(latest_tech[1][:total]),
							:total_old => Integer(history_tech['total']),
							:category => latest_tech[1][:category],
							:technology => latest_tech[1][:technology],
							:decrease => (((history_tech['total'].to_f - latest_tech[1][:total].to_f) / history_tech['total'].to_f) * 100).ceil
						}
					end
				end
			end
		end
		return declining_tech
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
