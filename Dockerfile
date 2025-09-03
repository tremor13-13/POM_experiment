# Используем официальный образ Python на основе Debian Bullseye, в котором уже есть apt
FROM python:3.11-bullseye

# Устанавливаем зависимости для Chrome и другие необходимые утилиты
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    gnupg2 \
    unzip && \
    # Устанавливаем ключ и репозиторий для Google Chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    # Обновляем список пакетов с добавленным репозиторием Google
    apt-get update && \
    # Устанавливаем Chrome
    apt-get install -y --no-install-recommends google-chrome-stable && \
    # Очищаем кеш apt, чтобы уменьшить размер итогового образа
    apt-get purge --auto-remove -y && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем ChromeDriver (АЛГОРИТМ ИЗМЕНЕН!)
# Скачиваем актуальную версию ChromeDriver, совместимую с установленным Chrome
RUN CHROME_MAJOR_VERSION=$(google-chrome --version | sed -E 's/.* ([0-9]+)\.[0-9]+\.[0-9]+.*/\1/') && \
    CHROMEDRIVER_VERSION=$(wget -q -O - "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_MAJOR_VERSION}") && \
    wget -q -O /tmp/chromedriver.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/ && \
    rm -rf /tmp/chromedriver.zip /usr/local/bin/chromedriver-linux64 && \
    chmod +x /usr/local/bin/chromedriver

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файл с зависимостями в контейнер
COPY requirements.txt .

# Устанавливаем Python-зависимости из requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Копируем ВЕСЬ остальной код проекта
COPY . .

# Команда по умолчанию, которая выполняется при запуске контейнера.
CMD ["pytest", "-v", "--tb=short"]