# Demo Deployment Project

A simple Hello World project built to explore and understand GenAI coding tools and their capabilities. This project serves as a practical example of how AI-assisted development can help in creating and maintaining Spring Boot applications.

## Technology Stack

- Java 21
- Spring Boot 3
- Spring WebFlux (Reactive Programming)
- Maven (Build Tool)

## Project Features

Currently, the project includes:

- A reactive REST endpoint that demonstrates basic parameter handling
- Modern Java features utilizing Java 21
- Spring Boot 3 best practices

## API Endpoints

### Hello World Endpoint

```
GET /api/hello
```

Query Parameters:
- `name` (optional): The name to greet. Defaults to "World" if not provided.

Example Requests:
```bash
# Default greeting
curl http://localhost:8080/api/hello

# Custom greeting
curl http://localhost:8080/api/hello?name=Alice
```

## Getting Started

### Prerequisites

- Java 21 JDK
- Maven

### Running the Application

1. Clone the repository
2. Navigate to the project directory
3. Run the application using Maven:
   ```bash
   mvn spring-boot:run
   ```
4. The application will start on `http://localhost:8080`

## Project Purpose

This project serves as a learning tool for:
- Understanding GenAI coding tools and their capabilities
- Exploring modern Java development practices
- Demonstrating Spring Boot 3 reactive programming concepts

## Contributing

This is a demonstration project for learning purposes. Feel free to fork and experiment! 