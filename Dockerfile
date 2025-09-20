FROM python:3.11-slim

RUN apt-get update && apt-get install -y     curl gnupg2 apt-transport-https unixodbc unixodbc-dev libgssapi-krb5-2     && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -     && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list     && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18     && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
