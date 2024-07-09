CREATE TABLE `mhealth_db`.`users`(
`id` int NOT NULL,
`name` varchar(45),
`email` varchar(45) UNIQUE,
`password` varchar(45),
PRIMARY KEY(`id`)
)ENGINE=InnoDB 	AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;