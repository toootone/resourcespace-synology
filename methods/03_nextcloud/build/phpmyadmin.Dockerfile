FROM phpmyadmin/phpmyadmin

# Install haveged for better entropy
RUN apt-get update && apt-get install -y haveged && rm -rf /var/lib/apt/lists/*

# Start haveged with container
CMD ["sh", "-c", "haveged -F && /docker-entrypoint.sh apache2-foreground"] 