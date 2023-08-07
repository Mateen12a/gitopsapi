# Use an official Python base image
FROM python:3.8.5-slim-buster

# Install required system dependencies (including sudo)
RUN apt-get update && apt-get install -y sudo procps vim

# Add a new user 'argocd' and grant sudo permissions to it
RUN useradd -ms /bin/bash argocd
RUN echo "argocd ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the working directory inside the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Copy the runserver.sh script into the container
COPY runserver.sh /runserver.sh

# Set execute permissions for the runserver.sh script
RUN chmod +x /runserver.sh

# Install application dependencies
RUN pip install -r requirements.txt && pip install gunicorn

# Switch to the 'argocd' user
USER argocd

# Set the entrypoint command
ENTRYPOINT ["/runserver.sh"]
