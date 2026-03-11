# ---------- Stage 1: Build the application ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /build

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies (improves build speed)
RUN mvn -B -q -e -DskipTests dependency:go-offline

# Copy source code
COPY src ./src

# Build the jar
RUN mvn clean package -DskipTests


# ---------- Stage 2: Create runtime image ----------
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /build/target/*.jar app.jar

# Expose Spring Boot port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java","-jar","app.jar"]
