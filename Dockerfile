# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file into the container
COPY app.jar app.jar

# Run the Java application
CMD ["java", "-jar", "app.jar"]

