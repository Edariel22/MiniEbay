-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: miniebay
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bids`
--

DROP TABLE IF EXISTS `bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bids` (
  `bid_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `userName` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `placed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bid_id`),
  KEY `product_id` (`product_id`),
  KEY `userName` (`userName`),
  CONSTRAINT `bids_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bids_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `users` (`userName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bids`
--

LOCK TABLES `bids` WRITE;
/*!40000 ALTER TABLE `bids` DISABLE KEYS */;
INSERT INTO `bids` VALUES (1,1,'Elias',2.00,'2025-11-02 03:25:49'),(2,1,'Elias',1.00,'2025-11-02 03:28:02'),(3,1,'Elias',3.00,'2025-11-02 03:28:08'),(4,1,'Elias',-12.00,'2025-11-02 03:28:23'),(5,2,'Bob1',1.00,'2025-11-02 14:22:25');
/*!40000 ALTER TABLE `bids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `dept_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `building` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Electronics',NULL),(2,'Books',NULL),(3,'Computers',NULL),(8,'Cheese','231');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menuelement`
--

DROP TABLE IF EXISTS `menuelement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menuelement` (
  `menuID` varchar(20) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menuelement`
--

LOCK TABLES `menuelement` WRITE;
/*!40000 ALTER TABLE `menuelement` DISABLE KEYS */;
INSERT INTO `menuelement` VALUES ('menu1','Main Menu','Pages for all users');
/*!40000 ALTER TABLE `menuelement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `dept_id` int NOT NULL,
  `start_bid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `due_date` datetime NOT NULL,
  `picture_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `userName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `dept_id` (`dept_id`),
  KEY `userName` (`userName`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `users` (`userName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Wireless Keyboard','Compact mechanical keyboard',3,45.00,'2025-11-01 23:59:00','/images/keyboard.jpg','2025-11-01 15:17:08','Elias'),(2,'Programming Book','Intro to Java web development',2,15.00,'2025-11-30 23:59:00','/images/book.jpg','2025-11-01 15:17:08','Elias'),(3,'Laptop','Lightweight 14-inch laptop, 16GB RAM',3,650.00,'2025-12-15 23:59:00','/images/laptop.jpg','2025-11-01 15:17:08','Elias'),(5,'Book',NULL,2,45.00,'2025-12-15 23:59:00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `roleId` varchar(20) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(100) NOT NULL,
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('rol1','Admin','Administrative user'),('rol2','Regular User','Standard registered user');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleuser`
--

DROP TABLE IF EXISTS `roleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roleuser` (
  `userName` varchar(50) NOT NULL,
  `roleId` varchar(20) NOT NULL,
  PRIMARY KEY (`userName`,`roleId`),
  KEY `roleId` (`roleId`),
  CONSTRAINT `roleuser_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `users` (`userName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `roleuser_ibfk_2` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleuser`
--

LOCK TABLES `roleuser` WRITE;
/*!40000 ALTER TABLE `roleuser` DISABLE KEYS */;
INSERT INTO `roleuser` VALUES ('Elias','rol1'),('Angel','rol2'),('Bob1','rol2'),('Bob2','rol2'),('user1','rol2'),('userNew','rol2'),('userNew1','rol2'),('userNew56','rol2');
/*!40000 ALTER TABLE `roleuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolewebpagegood`
--

DROP TABLE IF EXISTS `rolewebpagegood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolewebpagegood` (
  `roleId` varchar(20) NOT NULL,
  `pageURL` varchar(50) NOT NULL,
  `dateAssign` date NOT NULL,
  PRIMARY KEY (`roleId`,`pageURL`),
  KEY `pageURL` (`pageURL`),
  CONSTRAINT `rolewebpagegood_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rolewebpagegood_ibfk_2` FOREIGN KEY (`pageURL`) REFERENCES `webpagegood` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolewebpagegood`
--

LOCK TABLES `rolewebpagegood` WRITE;
/*!40000 ALTER TABLE `rolewebpagegood` DISABLE KEYS */;
INSERT INTO `rolewebpagegood` VALUES ('rol1','adminDepartments.jsp','2025-11-01'),('rol1','adminProducts.jsp','2025-11-01'),('rol1','adminUsers.jsp','2025-11-01'),('rol1','findProduct.jsp','2025-11-01'),('rol1','queryDatabaseGoodMiniEbay.jsp','2025-11-01'),('rol1','sellProduct.jsp','2025-11-02'),('rol1','welcomeMenu.jsp','2025-11-01'),('rol2','findProduct.jsp','2025-11-01'),('rol2','queryDatabaseGoodMiniEbay.jsp','2025-11-01'),('rol2','sellProduct.jsp','2025-11-02'),('rol2','welcomeMenu.jsp','2025-11-01');
/*!40000 ALTER TABLE `rolewebpagegood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userName` varchar(50) NOT NULL,
  `hashing` mediumtext NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('Angel','1b4f0e9851971998e732078544c96b36c3d01cedf7caa332359d6f1d83567014','Angel Ortiz','9392774596'),('Bob1','63ed66548ebd6671d6e7a8abba2678282f8c0e0334da789e1cd4375637cfe854','Bob','00000000'),('Bob2','bob','bbo','4345645'),('Elias','a40e8afc6e736dfef35e809f3e8af1dfaf37a992436f88baeae45b2897419f9f','Elias Medina','7876059637'),('user1','f9777362314a88ba0d7df701ed6bebd0a3577be33befe72babc40c39de65ab1f','bob','7876059637'),('userNew','cd73dc267c0edb56f8a21d9cb1c3fc65bb4788772cb3b38e28715dd0464b3e0c','Bob','78574576898'),('userNew1','28e9b95264c64c79c32afb68bb51231e1f481cabb0ed2a8ab9c903dca7a7bcee','Bob','78574576898'),('userNew56','737ac7e1a6bd0ae1f2bdcebcda0730a8dc2ad4ee6f50238ca8f79ce75898917c','Bob','78574576898');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpagegood`
--

DROP TABLE IF EXISTS `webpagegood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpagegood` (
  `pageURL` varchar(50) NOT NULL,
  `pageTitle` varchar(50) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `menuID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`pageURL`),
  KEY `menuID` (`menuID`),
  CONSTRAINT `webpagegood_ibfk_1` FOREIGN KEY (`menuID`) REFERENCES `menuelement` (`menuID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpagegood`
--

LOCK TABLES `webpagegood` WRITE;
/*!40000 ALTER TABLE `webpagegood` DISABLE KEYS */;
INSERT INTO `webpagegood` VALUES ('addUser.jsp','Signing Up','Normal User Signup page','menu1'),('adminDepartments.jsp','Manage Departments','View and edit departments','menu1'),('adminProducts.jsp','Manage Products','View and edit all products','menu1'),('adminUsers.jsp','Manage Users','View and edit registered users','menu1'),('findProduct.jsp','Find Product',NULL,'menu1'),('queryDatabaseGoodMiniEbay.jsp','Product List','Displays product listings','menu1'),('sellProduct.jsp','Sell Product','Page for users to list a new product','menu1'),('validationHashing.jsp','Login Validation','User authentication page','menu1'),('welcomeMenu.jsp','Welcome Menu','Main dashboard after login','menu1');
/*!40000 ALTER TABLE `webpagegood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpageprevious`
--

DROP TABLE IF EXISTS `webpageprevious`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpageprevious` (
  `currentPageURL` varchar(50) NOT NULL,
  `previousPageURL` varchar(50) NOT NULL,
  PRIMARY KEY (`currentPageURL`,`previousPageURL`),
  KEY `previousPageURL` (`previousPageURL`),
  CONSTRAINT `webpageprevious_ibfk_1` FOREIGN KEY (`currentPageURL`) REFERENCES `webpagegood` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `webpageprevious_ibfk_2` FOREIGN KEY (`previousPageURL`) REFERENCES `webpagegood` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpageprevious`
--

LOCK TABLES `webpageprevious` WRITE;
/*!40000 ALTER TABLE `webpageprevious` DISABLE KEYS */;
INSERT INTO `webpageprevious` VALUES ('findProduct.jsp','findProduct.jsp'),('welcomeMenu.jsp','validationHashing.jsp'),('adminDepartments.jsp','welcomeMenu.jsp'),('adminProducts.jsp','welcomeMenu.jsp'),('adminUsers.jsp','welcomeMenu.jsp'),('findProduct.jsp','welcomeMenu.jsp'),('queryDatabaseGoodMiniEbay.jsp','welcomeMenu.jsp');
/*!40000 ALTER TABLE `webpageprevious` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-02 11:02:01
