require 'selenium-webdriver'

class Helpers

  def initialize(driver)
    @element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @driver = driver
  end

  def fi_find_element(ele, wait = @element_wait)
    wait.until { @driver.fi_find_element(ele[:by], ele[:selector]) }
  end

  def fi_find_elements(ele, wait = @element_wait)
    wait.until { @driver.fi_find_elements(ele[:by], ele[:selector]) }
  end

  def element_present?(ele, wait = @element_wait)
    begin
      @driver.fi_find_element(ele, wait)
      true
    rescue
      false
    end
  end

  def click_on(ele)
    fi_find_element(ele).click
  end

  def fill_in(ele, value)
    fi_find_element(ele).send_keys(value)
  end
end