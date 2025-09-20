# Step 1 :  Uses the official Python 3.11 slim image as the base “Slim” means it’s a lightweight image with only the essentials.

FROM python:3.11-slim

# steps 2  : Updates package lists.

# Installs required system packages:

# curl, gnupg2, apt-transport-https → needed for downloading and adding Microsoft’s SQL Server repository.

# unixodbc, unixodbc-dev → drivers for ODBC (connecting to databases like MSSQL).

# libgssapi-krb5-2 → library for authentication.

# Downloads and installs Microsoft’s signing key + repo for SQL Server drivers.

# Installs MS SQL ODBC Driver (msodbcsql18) and SQL command-line tools (mssql-tools18) Cleans up unnecessary files to keep image size smaller.
RUN apt-get update && apt-get install -y     curl gnupg2 apt-transport-https unixodbc unixodbc-dev libgssapi-krb5-2   
&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -     && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list  
&& apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18     && apt-get clean && rm -rf /var/lib/apt/lists/*


# step 3 : Sets the working directory to /app  All following commands will run inside /app.

WORKDIR /app

#steps 4 : Copies only requirements.txt from your project into the container.
COPY requirements.txt .

#step5 : Installs Python dependencies listed in requirements.txt. --no-cache-dir avoids storing temporary files → reduces image size.
RUN pip install --no-cache-dir -r requirements.txt

# steps5 : Copies all project files from your local machine into the container under /app.
COPY . .

#steps 6 : Exposes port 8000 so the Django server inside the container can be accessed from outside
EXPOSE 8000

#steps 7: Default command to run when the container starts:

# Runs database migrations (python manage.py migrate).
# Starts Django development server on 0.0.0.0:8000 (so it’s accessible from outside the container).

CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
