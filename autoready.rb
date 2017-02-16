require 'selenium-webdriver'
require 'win32/sound'
require_relative 'pages/home_page'
require_relative 'pages/match_page'
require_relative 'support/helpers'

include Win32

preferred_ladder = ARGV[0].nil? ? 'Super TF2 Ladder' : ARGV[0]
preferred_join_type = ARGV[1].nil? ? 'AS SOLO' : ARGV[1]
email = ENV['faceit_email'].nil? ? ARGV[2] : ENV['faceit_email']
password = ENV['faceit_password'].nil? ? ARGV[3] : ENV['faceit_password']

@driver = Selenium::WebDriver.for :firefox
@home_page = HomePage.new(@driver)
@match_page = MatchPage.new(@driver)

def dismiss_all_cancelled_match_modals
  while !@match_page.on_match_page
    if @home_page.did_not_check_in_modal_present
      sleep 3
      @home_page.dismiss_cancelled_match
    end
  end
end

begin
  @home_page.goto
  @home_page.log_in(email, password)
  @home_page.start_queueing(preferred_ladder, preferred_join_type)

  while true
    @home_page.wait_for_match
    @home_page.set_ready
    dismiss_all_cancelled_match_modals
    @match_page.copy_to_clipboard_when_ready
    Sound.play("C:/Windows/Media/tada.wav")

    @match_page.dismiss_match_results_when_finished unless @match_page.someone_did_not_join
  end
rescue
  # Needs user attention
  5.times do
    Sound.play("C:/Windows/Media/Windows Critical Stop.wav")
  end
end




