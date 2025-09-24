# Sample Java ECS Application

A simple **Spring Boot REST API** application to demonstrate **AWS ECS deployment**.  

This project supports **multiple environments (dev, QA)** using Spring profiles and can be built as a **Docker image**.

---

## 📂 Project Structure

sample-java-ecs/
├── src/
│ └── main/
│ ├── java/com/example/demo/
│ │ ├── DemoApplication.java
│ │ └── HelloController.java
│ └── resources/
│ ├── application.properties
│ ├── application-dev.properties
│ └── application-qa.properties
├── src/test/java/com/example/demo/
│ └── HelloControllerTest.java
├── pom.xml
├── Dockerfile
└── .github/workflows/deploy-ecs.yml


---

## ⚡ Features

- Spring Boot REST API with endpoints:
  - `/` → Returns environment-specific greeting  
  - `/health` → Returns `OK`  
- Supports **multi-environment configurations** using Spring profiles (`dev` & `qa`).  
- Unit tests with **JUnit 5** and **Spring Boot Test**.  
- Dockerized for **ECS deployment**.  
- Automated **GitHub Actions pipeline** for build, ECR push, and ECS deployment.

---

## 🔧 Prerequisites

- JDK 17+  
- Maven 3.9+  
- Docker 20+  
- VS Code (recommended) with **Java Extension Pack**  
- AWS account with **ECR + ECS permissions**

## 🚀 Running Locally

1. Clone the repository:
2. Run in dev environment:
    export SPRING_PROFILES_ACTIVE=dev
    mvn clean spring-boot:run
3. Run in QA environment:
    export SPRING_PROFILES_ACTIVE=qa
    mvn clean spring-boot:run
4. Test endpoints:
    curl http://localhost:8080/
    curl http://localhost:8080/health
5. 🧪 Running Unit Tests
    mvn test
    
    Expected output:
        / endpoint returns "Hello from DEV environment!" or "Hello from QA environment!"
        /health endpoint returns OK
---
## 🐳 Docker
- Build Docker image:
    docker build -t sample-java-ecs .
- Run Docker container:
    docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=dev sample-java-ecs

---

##  Switching Environments
    # Dev
    export SPRING_PROFILES_ACTIVE=dev

    # QA
    export SPRING_PROFILES_ACTIVE=qa
---
## Best Practices Used

    Single Docker image for all environments
    Environment-specific config via Spring profiles & environment variables
    Unit tests included for basic endpoints
    Dockerfile at project root for CI/CD-friendly builds
    Automated GitHub Actions deployment to ECS

---
## 🛠 Git Hooks Setup

To ensure commit message standards and pre-commit checks for Maven builds and tests, please set up Git hooks after cloning the repository.

### Steps:

1. Clone the repo:
2. Make the setup script executable and run it
    chmod +x .githooks/setup-hooks.sh
    ./.githooks/setup-hooks.sh

---
