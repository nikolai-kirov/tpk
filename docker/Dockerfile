# Use the official Python image as the base image
FROM python:3.8-slim-buster

# Set environment variable for Flask app
ENV FLASK_APP=hello

# Set working directory inside the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app/

# Expose port for Flask app
EXPOSE 80

# Start the Flask app
CMD ["flask", "run", "--host", "0.0.0.0"]
