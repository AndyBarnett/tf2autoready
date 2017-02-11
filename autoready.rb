require 'selenium-webdriver'
require 'page-object'
 
login_button = {by: :css, selector: ".btn[translate-once='LOGIN']"}
login_modal = {by: :class, selector: "modal-content"}
email_field = {by: :id, selector: 'login_email'}
password_field = {by: :id, selector: 'login_password'}
login_submit_button = {by: :css, selector: "[ui-view='loginContent'] .btn-primary"}
play_game_button = {by: :css, selector: "button[ng-click='quickPlay()']"}
play_game_modal = {by: :class, selector: 'modal-content'}
ladder_dropdown = {by: :css, selector: "[ng-if='!isLoadingLadders'] select"}
ladders = {by: :css, selector: "[ng-if='!isLoadingLadders'] option"}
join_types = {by: :css, selector: '.flex button'}
lets_play = {by: :css, selector: "button[ng-click='submit()']"}
continue = {by: :css, selector: "button[translate-once='CONTINUE']"}
preferred_ladder = ARGV[0].nil? ? 'Super TF2 Ladder' : ARGV[0]
preferred_join_type = ARGV[1].nil? ? 'AS SOLO' : ARGV[1]
email = ENV['faceit_email'].nil? ? ARGV[2] : ENV['faceit_email']
password = ENV['faceit_password'].nil? ? ARGV[3] : ENV['faceit_password']

@driver = Selenium::WebDriver.for :firefox
@element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)

@driver.navigate.to "https://www.faceit.com/en/tf2"

def find_element(ele)
	element = @element_wait.until { @driver.find_element(ele[:by], ele[:selector]) }
end

def find_elements(ele)
	element = @element_wait.until { @driver.find_elements(ele[:by], ele[:selector]) }
end

def element_present?(ele)
	begin
		find_element(ele)
		true
	rescue
		false
	end
end

def click_on(ele)
	find_element(ele).click
end

def fill_in(ele, value)
	find_element(ele).send_keys(value)
end

click_on(login_button)
fill_in(email_field, email)
fill_in(password_field, password)
click_on(login_submit_button)
@element_wait.until { !element_present?(login_modal) }
click_on(play_game_button)

click_on(ladder_dropdown)

find_elements(ladders).each do |ladder|
	if ladder.text.include?(preferred_ladder)
		ladder.click
		break
	end
	raise('ladder not found')
end
click_on(play_game_modal)

find_elements(join_types).each do |join_type|
	if join_type.text == preferred_join_type
		join_type.click
		break
	 end
end

click_on(lets_play)
click_on(continue)