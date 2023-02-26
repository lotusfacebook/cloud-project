# Cloud Project
---
Focus: react-and-spring-data-rest

The application has a react frontend and a Spring Boot Rest API, packaged as a single module Maven application. You can build the application using maven and run it as a Spring Boot application using the flat jar generated in target (`java -jar target/*.jar`).

You can test the main API using the following curl commands (shown with its output):

---

\$ curl -v -u greg:turnquist localhost:8080/api/employees/3
{
"firstName" : "Frodo",
"lastName" : "Baggins",
"description" : "ring bearer",
"manager" : {
"name" : "greg",
"roles" : [ "ROLE_MANAGER" ]
},
"\_links" : {
"self" : {
"href" : "http://localhost:8080/api/employees/1"
}
}
}

---

To see the frontend, navigate to http://localhost:8080. You are immediately redirected to a login form. Log in as `greg/turnquist`

---

# Build the maven application

To build the Maven application, install Maven (https://maven.apache.org/) and build the spring boot application using the command "`mvn package`".
This will build the java file that can be used to run the application. This java file is usually located in the target directory.
To run the application after the build is done successfully, run this command "`java -jar target/*.jar`".

# How to clone, configure and deploy this solution

- To clone this repository, simply run the command (`git clone https://github.com/promiseuche/cloud-project.git`).
- You also need to ensure that you create a resource group called "cloudproject" before you proceed.
- Grant the service connection for the pipeline ownership access to the resource group to ensure smooth deployment.
- Next, proceed with the deployment

