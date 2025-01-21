FROM python:3.9-slim

# Install wget and the Postgres client
RUN apt-get update && apt-get install -y wget postgresql-client

WORKDIR /app

# Copy in the loading script
COPY load_data.sh .
RUN chmod +x load_data.sh

# Default command just runs the script
CMD ["./load_data.sh"]
