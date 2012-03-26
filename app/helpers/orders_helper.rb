module OrdersHelper
  def states_by_country
    state_options = {}
    Carmen::country_codes.each do |country|
      states = Carmen::states(country) rescue []
      state_options[country] = options_for_select(states)
    end
    javascript_tag("var states = #{state_options.to_json}")
  end
end
