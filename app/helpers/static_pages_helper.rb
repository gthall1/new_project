module StaticPagesHelper

	def get_amount_types
		case current_user.credits
			when 0..999
				['Sorry You Dont Have Enough Credits']
			when 1000..1949
				[["$5 - 1000 credits",1000]]
			when 1950..3899
				[["$5 - 1000 credits",1000],["$10 - 1950 credits",1950]]
			when 3900
				[["$5 - 1000 credits",1000],["$10 - 1950 credits",1950],["$20 - 3900 credits",3900]]
		end
		
	end
end
