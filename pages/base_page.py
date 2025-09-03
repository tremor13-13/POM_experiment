from selenium.webdriver.remote.webdriver import WebDriver

class BasePage:

    _LOGO = ("xpath", "//a[contains(@class, 'navbar-brand')]")

    def __init__(self, driver):
        self.driver: WebDriver = driver

    def open(self):
        self.driver.get(self._PAGE_URL)