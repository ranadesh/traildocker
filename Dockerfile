# Use OpenJDK as the base image
FROM openjdk:11-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the target directory to the container
COPY target/devops-project-1.0-SNAPSHOT.jar app.jar

# Run the Java application
CMD ["java", "-jar", "app.jar"]

