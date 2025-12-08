# Stage 1: Build the app using Maven (this creates the WAR file)
FROM maven:3.8.1-openjdk-17-slim AS builder

# Set the working directory inside the container for the build
WORKDIR /app

# Copy all your project files (pom.xml, src, etc.) into the container
COPY . .

# Run Maven to clean and build the WAR file (skip tests to speed up)
RUN mvn clean package -DskipTests

# Stage 2: Runtime environment with Tomcat (smaller image, no build tools)
FROM tomcat:9.0-jdk17-corretto

# Add labels for metadata (optional, good practice)
LABEL maintainer="your-email@example.com" \
      version="1.0" \
      description="EmailListWebApp on Tomcat"

# Remove Tomcat's default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from Stage 1 into Tomcat's webapps folder
COPY --from=builder /app/target/ch12.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Tomcat's default port for HTTP)
EXPOSE 8080

# Healthcheck to verify the app is running (optional, helps Render detect readiness)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Command to start Tomcat when the container runs
CMD ["catalina.sh", "run"]
