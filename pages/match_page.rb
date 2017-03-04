require 'selenium-webdriver'
require_relative '../support/helpers'
class MatchPage < Helpers

  def initialize(driver)
    @match_room_area = {by: :class, selector: 'match-vs'}
    @copy_to_clipboard = {by: :class, selector: 'clipboard-button'}
    @post_game_close = {by: :css, selector: '.modal-dialog__content button.close'}
    # @match_cancelled = {by: :class, selector: 'match-vs__details__item'}
    @connect_string_box = {by: :class, selector: 'drop-text-hide'}
    @voting_popup = {by: :css, selector: ".btn-primary[translate-once='OK']"}

    @element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @match_vote_wait = Selenium::WebDriver::Wait.new(:timeout => 300) # 5 mins for map to be chosen
    @match_warmup_wait = Selenium::WebDriver::Wait.new(:timeout => 300) # 5 mins for someone to not join
    @match_playtime_wait = Selenium::WebDriver::Wait.new(:timeout => 3600) # 60 mins for game to finish
    @post_match_model_close_wait = Selenium::WebDriver::Wait.new(:timeout => 5) # 5s between each match finished modal appearing
    @driver = driver
  end

  def on_match_page
    element_present?(@match_room_area)
  end

  def user_needs_to_vote
    sleep 3
    element_present?(@voting_popup)
  end

  def copy_to_clipboard_when_ready
    @match_vote_wait.until { element_present?(@copy_to_clipboard) }
    sleep 3
    click_on(@copy_to_clipboard)
    connect_string = fi_find_element(@connect_string_box).text.gsub('connect ', '')
    # @driver.navigate.to "steam://connect/#{connect_string}"
  end

  def someone_did_not_join
    match_cancelled = false
    begin
      puts "waiting to see if match was cancelled"
      @match_warmup_wait.until { !element_present?(@copy_to_clipboard) }
      puts "match cancelled apparently"
      match_cancelled = true
    rescue
    end
    puts "returning #{match_cancelled} for match_cancelled"
    match_cancelled
  end

  def dismiss_match_results_when_finished
    puts "waiting #{@match_playtime_wait}s until post game modal is present"
    @match_playtime_wait.until { element_present?(@post_game_close) }
    click_on(@post_game_close) while element_present?(@post_game_close, @post_match_model_close_wait)
  end
end
