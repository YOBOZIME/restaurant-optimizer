# restaurant-optimizer (final project)

## Objectifs du projet

Ce projet vise à optimiser la gestion et l'organisation d'un restaurant en fournissant des outils pour:
- Planification des tables et optimisation de l'occupation
- Gestion des réservations et des listes d'attente
- Optimisation des parcours du personnel en cuisine et en salle
- Analyse simple des performances (taux d'occupation, temps d'attente)

## Technologies utilisées

Le dépôt contient principalement les langages suivants:
- Java
- JavaScript
- CSS

Selon l'architecture du projet, les technologies suivantes peuvent être pertinentes:
- Backend: Java (Spring Boot)
- Frontend: JavaScript (React, plain JS)
- Styles: CSS
- Outils de build possibles: Maven


## Prérequis

- Java JDK 11+ installé
- Maven

## Instructions pour exécuter le projet (exemples généraux)

1. Récupérer le code:

   git clone https://github.com/YOBOZIME/restaurant-optimizer.git
   cd restaurant-optimizer

   ./mvnw clean package   
   java -jar target/<votre-artifact>.jar



2. Variables d'environnement / configuration

   - Créez un fichier de configuration (ex: application.properties ou .env) avec les paramètres nécessaires (base de données, ports, etc.).
   - Exemple (application.properties):
     server.port=8080
     spring.datasource.url=jdbc:postgresql://localhost:5432/restaurant

3. Tests

   - Maven: mvn test
   - Frontend: npm test
