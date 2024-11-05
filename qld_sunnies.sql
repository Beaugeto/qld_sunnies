-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2024 at 08:04 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qld_sunnies`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE `cart_item` (
  `cart_item_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_item`
--

INSERT INTO `cart_item` (`cart_item_id`, `order_id`, `product_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `orderstatus` enum('carted','order','shipped','delivered') DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `quantity`, `orderstatus`, `order_date`) VALUES
(1, 2, 2, 'carted', '2024-10-31 14:00:00'),
(2, 6, 1, 'delivered', '2024-11-01 14:00:00'),
(3, 4, 3, 'shipped', '2024-11-02 14:00:00'),
(4, 5, 1, 'delivered', '2024-11-03 14:00:00'),
(5, 3, 4, 'order', '2024-11-04 14:00:00');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `check_quantity` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    IF NEW.quantity > 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot exceed 50 items';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_quantity_update` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
    IF NEW.quantity > 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot exceed 50 items';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `category` enum('mens','womens','kids') DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `price`, `stock`, `category`, `description`) VALUES
(1, 'Sunglasses A', 19.99, 0, 'mens', NULL),
(2, 'Sunglasses B', 25.99, 0, 'womens', NULL),
(3, 'Sunglasses C', 15.99, 0, 'kids', NULL),
(4, 'Sunglasses D', 22.99, 0, 'mens', NULL),
(5, 'Sunglasses E', 18.99, 0, 'womens', NULL),
(6, 'Sunglasses F', 20.99, 0, 'kids', NULL),
(7, 'Sunglasses G', 27.99, 0, 'mens', NULL),
(8, 'Sunglasses H', 24.99, 0, 'womens', NULL),
(9, 'Sunglasses I', 16.99, 0, 'kids', NULL),
(10, 'Sunglasses J', 23.99, 0, 'mens', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pass_word` binary(32) DEFAULT NULL,
  `role` enum('customer','admin','super_admin') NOT NULL DEFAULT 'customer',
  `last_active` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `pass_word`, `role`, `last_active`) VALUES
(1, 'Beaugeto@sunnies.com', 0x6861736865645f70617373776f72640000000000000000000000000000000000, 'super_admin', '2024-11-04 13:22:34'),
(2, 'bob@example.com', 0x5061737377307264312100000000000000000000000000000000000000000000, 'customer', '2024-11-05 06:25:05'),
(3, 'kate@example.com', 0x5061737377307264322100000000000000000000000000000000000000000000, 'customer', '2024-11-05 06:25:05'),
(4, 'tim@example.com', 0x5061737377307264332100000000000000000000000000000000000000000000, 'customer', '2024-11-05 06:25:05'),
(5, 'lola@example.com', 0x5061737377307264342100000000000000000000000000000000000000000000, 'customer', '2024-11-05 06:25:05'),
(6, 'usher@example.com', 0x5061737377307264352100000000000000000000000000000000000000000000, 'customer', '2024-11-05 06:25:05');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `before_insert_users` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF LENGTH(NEW.pass_word) < 10 OR
       NEW.pass_word NOT REGEXP '.*[A-Z].*' OR
       NEW.pass_word NOT REGEXP '.*[a-z].*' OR
       NEW.pass_word NOT REGEXP '.*[!@#$%^&*(),.?":{}|<>].*' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 10 characters long and include uppercase, lowercase, and symbols';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_users_two` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF LENGTH(NEW.pass_word) < 10 OR
       NEW.pass_word NOT REGEXP '.*[A-Z].*' OR
       NEW.pass_word NOT REGEXP '.*[a-z].*' OR
       NEW.pass_word NOT REGEXP '.*[!@#$%^&*(),.?":{}|<>].*' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 10 characters long and include uppercase, lowercase, and symbols';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_users_two` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    IF LENGTH(NEW.pass_word) < 10 OR
       NEW.pass_word NOT REGEXP '.*[A-Z].*' OR
       NEW.pass_word NOT REGEXP '.*[a-z].*' OR
       NEW.pass_word NOT REGEXP '.*[!@#$%^&*(),.?":{}|<>].*' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 10 characters long and include uppercase, lowercase, and symbols';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_password_length` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF LENGTH(NEW.pass_word) < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 10 characters long';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_password_length_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    IF LENGTH(NEW.pass_word) < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 10 characters long';
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `idx_category_price` (`category`,`price`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD CONSTRAINT `cart_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `cart_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
