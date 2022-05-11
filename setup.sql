DROP TABLE IF EXISTS `test`;

CREATE TABLE `test` (
  `name` varchar(100) DEFAULT NULL,
  `prename` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `test` WRITE;
INSERT INTO `test` VALUES ('Payton','Gary'),('Kemp','Shawn'),('McMillan','Nate'),('Perkins','Sam'),('Schrempf','Detlef');
UNLOCK TABLES;

