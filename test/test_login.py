import time

from pages.login_page import LoginPage

class TestLogin:

    def setup_method(self):
        self.login_page = LoginPage(self.driver)

    def test_login(self):
        self.login_page.open()
        self.login_page.enter_login("boton@inbox.ru")
        time.sleep(4)

