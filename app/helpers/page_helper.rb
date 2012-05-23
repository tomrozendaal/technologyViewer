module PageHelper
	# Returns the full title on a per-page basis.
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
