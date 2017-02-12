require 'selenium-webdriver'
require_relative 'pages/home_page'
require_relative 'pages/match_page'
require_relative 'support/helpers'

preferred_ladder = ARGV[0].nil? ? 'Super TF2 Ladder' : ARGV[0]
preferred_join_type = ARGV[1].nil? ? 'AS SOLO' : ARGV[1]
email = ENV['faceit_email'].nil? ? ARGV[2] : ENV['faceit_email']
password = ENV['faceit_password'].nil? ? ARGV[3] : ENV['faceit_password']

@driver = Selenium::WebDriver.for :firefox
@home_page = HomePage.new(@driver)
@match_page = MatchPage.new(@driver)

def dismiss_all_cancelled_match_modals
  a = !element_present?(@match_page.match_room_area)
  while !element_present?(@match_page.match_room_area)
    if element_present?(@home_page.did_not_check_in_modal)
      sleep 3
      @home_page.dismiss_cancelled_match
    end
  end
end

@home_page.goto
@home_page.log_in(email, password)
@home_page.start_queueing(preferred_ladder, preferred_join_type)
@home_page.wait_for_match
@home_page.set_ready
begin
  dismiss_all_cancelled_match_modals
rescue
end


begin
  @match_page.copy_to_clipboard_when_ready
rescue
end

begin
  @match_page.dismiss_match_results_when_finished
rescue
end





