from pages.base_page import BasePage

class LoginPage(BasePage):

    _PAGE_URL = "https://www.freeconferencecall.com/ru/ru/login"
    _LOGIN_FILED = "//input[@id='login_email']"

    def enter_login(self, login):
        self.driver.find_element(*self._LOGIN_FILED).send_keys(login)
