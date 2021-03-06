require 'selenium-webdriver'
require 'selenium/webdriver/support/select'
require_relative '../support/helpers'

class HomePage < Helpers

  def initialize(driver)
    @chat_close_button = {by: :css, selector: ".chat-window__header [ng-click='close()']"}
    @login_button = {by: :css, selector: ".btn[translate-once='LOGIN']"}
    @login_modal = {by: :class, selector: "modal-content"}
    @email_field = {by: :id, selector: 'login_email'}
    @password_field = {by: :id, selector: 'login_password'}
    @login_submit_button = {by: :css, selector: "[ui-view='loginContent'] .btn-primary"}
    @play_game_button = {by: :css, selector: "button[ng-click='quickPlay()']"}
    @play_game_modal = {by: :class, selector: 'modal-content'}
    @ladder_dropdown = {by: :css, selector: "[ng-if='!isLoadingLadders'] select"}
    @ladders = {by: :css, selector: "[ng-if='!isLoadingLadders'] option"}
    @join_types = {by: :css, selector: '.flex button'}
    @lets_play = {by: :css, selector: "button[ng-click='submit()']"}
    @continue = {by: :css, selector: "button[translate-once='CONTINUE']"}
    @stay_free = {by: :css, selector: "span[translate-once='STAY-FREE-FOR-NOW']"}
    @set_ready = {by: :css, selector: ".modal-dialog__actions button.btn-primary[translate-once='ACCEPT']"}
    @set_ready2 = {by: :css, selector: ".modal-dialog__actions button[translate-once='ACCEPT']"}
    @set_ready3 = {by: :css, selector: ".modal-dialog__actions .btn-primary[translate-once='ACCEPT']"}
    @set_ready4 = {by: :css, selector: "button[translate-once='ACCEPT']"}
    @set_ready5 = {by: :css, selector: ".btn-primary[translate-once='ACCEPT']"}
    @set_ready6 = {by: :css, selector: "button.btn-primary[translate-once='ACCEPT']"}

    @did_not_check_in_modal = {by: :css, selector: "label[translate-once='OTHERS-DIDNT-CHECK-IN']"}
    @did_not_check_in_ok = {by: :css, selector: ".modal-dialog__actions .btn-primary[translate-once='OK']"}
    @any_continue_button = {by: :css, selector: ".btn-primary[translate-once='CONTINUE']"}
    @any_ok_button = {by: :css, selector: ".btn-primary[translate-once='OK']"}
    @any_accept_button = {by: :css, selector: ".btn-primary[translate-once='ACCEPT']"}

    @driver = driver
    @element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @queue_wait = Selenium::WebDriver::Wait.new(:timeout => 1200) # up to 20 minutes of waiting for match
  end

  def goto
    @driver.navigate.to "https://www.faceit.com/en/tf2"
  end

  def log_in(email, password)
    click_on(@login_button)
    fill_in(@email_field, email)
    fill_in(@password_field, password)
    click_on(@login_submit_button)
    @element_wait.until { !element_present?(@login_submit_button) }
  end

  def start_queueing(preferred_ladder, preferred_join_type)
    click_on(@play_game_button)
    sleep 5
    click_on(@ladder_dropdown)

    # dropdown_options = Selenium::WebDriver::Support::Select.new(fi_find_element(@ladder_dropdown))
    # puts dropdown_options.options[0].text
    # dropdown_options.select_by(:text, "#{preferred_ladder} (97/20000)")

    fi_find_elements(@ladders).each do |ladder|
      if ladder.text.include?(preferred_ladder)
        ladder.click
        @ladder_selected = true
        break
      end
    end

    raise('ladder not found') unless @ladder_selected

    click_on(@play_game_modal)

    fi_find_elements(@join_types).each do |join_type|
      if join_type.text == preferred_join_type
        join_type.click
        break
      end
    end

    click_on(@lets_play)
    sleep 2
    click_on(@stay_free) if element_present?(@stay_free)
    click_on(@continue) if element_present?(@continue)
  end

  def wait_for_match
    click_on(@chat_close_button) if element_present?(@chat_close_button)
    @queue_wait.until { element_present?(@set_ready) }
  end

  def set_ready_present?
    element_present?(@set_ready)
  end

  def ok_or_continue_or_accept_button_present?
    element_present?(@any_ok_button) ||
        element_present?(@any_continue_button) ||
        element_present?(@any_accept_button)
  end

  def click_any_ok_or_continue_or_accept_button
    click_on(@any_ok_button) if element_present?(@any_ok_button)
    click_on(@any_continue_button) if element_present?(@any_continue_button)
    click_on(@any_accept_button) if element_present?(@any_accept_button)
  end

  def set_ready
    click_on(@set_ready)
  end

  def dismiss_cancelled_match
    click_on(@did_not_check_in_ok)
  end

  def did_not_check_in_present
    element_present?(@did_not_check_in_ok)
  end
end