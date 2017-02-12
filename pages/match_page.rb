require 'selenium-webdriver'
require_relative '../support/helpers'


class MatchPage < Helpers

  def initialize(driver)
    @match_room_area = {by: :class, selector: 'match-vs'}
    @copy_to_clipboard = {by: :class, selector: 'clipboard-button'}
    @post_game_close = {by: :css, selector: '.modal-dialog__content button.close'}

    @driver = driver
    @element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @match_vote_wait = Selenium::WebDriver::Wait.new(:timeout => 300) # 5 mins for map to be chosen
    @match_playtime_wait = Selenium::WebDriver::Wait.new(:timeout => 3600) # 60 mins for game to finish
  end

  def copy_to_clipboard_when_ready
    @match_vote_wait.until { element_present?(@copy_to_clipboard) }
    sleep 3
    click_on(@copy_to_clipboard)
  end

  def dismiss_match_results_when_finished
    @match_playtime_wait.until { element_present?(@post_game_close) }
    click_on(@post_game_close) while element_present?(@post_game_close)
  end
end