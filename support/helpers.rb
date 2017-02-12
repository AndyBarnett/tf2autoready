require 'selenium-webdriver'

class Helpers

  def initialize(driver)
    @driver = driver
  end

  def find_element(ele)
    @element_wait.until { @driver.find_element(ele[:by], ele[:selector]) }
  end

  def find_elements(ele)
    @element_wait.until { @driver.find_elements(ele[:by], ele[:selector]) }
  end

  def element_present?(ele)
    begin
      @driver.find_element(ele[:by], ele[:selector])
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
end