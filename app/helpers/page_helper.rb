module PageHelper
	# Returns the full title on a per-page basis.
	def full_category(category)
		if category == "wf"
			"webFrameworks"
		elsif category == "cms"
			"contentManagementSystems"
		elsif category == "pl"
			"programmingLanguages"
		end
	end
end
