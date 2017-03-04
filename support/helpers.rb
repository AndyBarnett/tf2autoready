require 'selenium-webdriver'

class Helpers

  def initialize(driver)
    @element_wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @driver = driver
  end

  def fi_find_element(ele, wait = @element_wait)
    wait.until { @driver.find_element(ele[:by], ele[:selector]) }
  end

  def fi_find_elements(ele, wait = @element_wait)
    wait.until { @driver.find_elements(ele[:by], ele[:selector]) }
  end

  def element_present?(ele, wait = nil)
    begin
      if wait.nil?
        @driver.find_element(ele[:by], ele[:selector])
      else
        wait.until { @driver.find_element(ele[:by], ele[:selector]) }
      end
      true
    rescue
      false
    end
  end

  def click_on(ele)
    fi_find_element(ele).click
  end

  def click_on_while_element_present(click_ele, present_ele)
    fi_find_element(present_ele)
  end

  def fill_in(ele, value)
    fi_find_element(ele).send_keys(value)
  end

end