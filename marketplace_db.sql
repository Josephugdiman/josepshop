-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 07, 2026 at 11:43 AM
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
-- Database: `marketplace_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `login_audit`
--

CREATE TABLE `login_audit` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `action` varchar(50) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_sessions`
--

CREATE TABLE `login_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `device_info` text DEFAULT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `user_type` enum('admin','super_admin','user') DEFAULT 'user',
  `is_active` tinyint(1) DEFAULT 1,
  `email_verified` tinyint(1) DEFAULT 0,
  `temp_password` tinyint(1) DEFAULT 0,
  `login_attempts` int(11) DEFAULT 0,
  `session_token` varchar(500) DEFAULT NULL,
  `session_expires_at` datetime DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_expires_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `user_type`, `is_active`, `email_verified`, `temp_password`, `login_attempts`, `session_token`, `session_expires_at`, `reset_token`, `reset_expires_at`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'Mansueto@gmail.com', '$2b$10$q4HM9vv/.AwthTZjUJ0eG.USJuAk.rbYTRRQKHjyDR/2CZdVekare', 'Mansueto', 'User', '09123456789', 'admin', 1, 1, 0, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJNYW5zdWV0b0BnbWFpbC5jb20iLCJ1c2VyX3R5cGUiOiJhZG1pbiIsIm5hbWUiOiJNYW5zdWV0byBVc2VyIiwiaWF0IjoxNzY3NzgwNjI1LCJleHAiOjE3Njc4NjcwMjV9.mCwgbzeYJFeNZuHrPEU66jKyy2JrJCDFtWx9Me0mvlM', '2026-01-08 18:10:25', NULL, NULL, '2026-01-07 18:10:25', '2025-12-22 12:47:25', '2026-01-07 10:10:25');

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` int(11) NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `owner_name` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `stall_number` varchar(50) NOT NULL,
  `section` varchar(50) NOT NULL,
  `application_type` enum('new','renew') DEFAULT 'new',
  `business_type` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','expiring_soon','pending') DEFAULT 'active',
  `registration_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `payment_status` enum('paid','unpaid','partial') DEFAULT 'unpaid',
  `amount_due` decimal(10,2) DEFAULT 0.00,
  `amount_paid` decimal(10,2) DEFAULT 0.00,
  `created_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`id`, `business_name`, `owner_name`, `email`, `phone`, `address`, `stall_number`, `section`, `application_type`, `business_type`, `status`, `registration_date`, `expiry_date`, `payment_status`, `amount_due`, `amount_paid`, `created_by`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'Fresh Fruits Market', 'Juan Dela Cruz', 'juan@example.com', '09171234567', '123 Main Street', 'GF-101', 'Fruits', 'new', 'Fruits & Vegetables', 'active', '2024-01-15', NULL, 'paid', 5000.00, 5000.00, NULL, NULL, '2025-12-22 13:32:31', '2025-12-22 13:32:31'),
(2, 'Meat Masters', 'Maria Santos', 'maria@example.com', '09221234567', '456 Market Road', 'GF-102', 'Meat', 'renew', 'Meat Products', 'active', '2024-01-20', NULL, 'paid', 6000.00, 6000.00, NULL, NULL, '2025-12-22 13:32:31', '2025-12-22 13:32:31'),
(3, 'Dry Goods Depot', 'Pedro Reyes', 'pedro@example.com', '09331234567', '789 Business Ave', 'GF-103', 'Dry Goods', 'new', 'Dry Goods', 'expiring_soon', '2023-12-01', NULL, 'partial', 4500.00, 2000.00, NULL, NULL, '2025-12-22 13:32:31', '2025-12-22 13:32:31'),
(4, 'utanan', 'clint Clarido', 'clarido@gmail.com', '0987654321', 'caballero, citihomes,san carlos', 'stall 23', 'vegetable section', 'new', 'vegetables', 'active', '2025-12-22', '2026-12-22', 'unpaid', 0.00, 0.00, 1, NULL, '2025-12-22 14:59:38', '2025-12-22 14:59:38'),
(5, 'cafeter', 'digong', 'digong@gmail.com', '09123456789', 'Market Address', 'stall 83', 'Section A', 'new', NULL, 'active', '2027-01-05', '2028-01-05', 'unpaid', 0.00, 0.00, 1, NULL, '2026-01-05 13:26:46', '2026-01-05 13:26:46'),
(6, 'bulad ng bayan', 'bongbong', 'bongbong@gmail.com', '09123456789', 'Market Address', 'stall 63', 'Section A', 'new', NULL, 'active', '2027-01-05', '2028-01-05', 'unpaid', 0.00, 0.00, 1, NULL, '2026-01-05 13:31:02', '2026-01-05 13:31:02'),
(7, 'tahung ni karla', 'tribmolu', 'tribmulo@gmail.com', '', 'eco center', 'stall 68', 'Section C', '', 'Food Stall', 'active', '2027-01-05', '2028-01-05', 'unpaid', 0.00, 0.00, 1, 'Updated on 1/5/2026', '2026-01-05 13:59:18', '2026-01-05 14:00:04'),
(8, 'dc cruz prime', 'calbar clay', 'clay@gmail.com', '091212121212', 'taga commonal', 'stall 87', 'Section C', '', 'Food Stall', 'active', '2027-01-06', '2028-01-06', 'unpaid', 0.00, 0.00, 1, NULL, '2026-01-06 02:41:32', '2026-01-06 02:41:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `login_audit`
--
ALTER TABLE `login_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_email` (`email`),
  ADD KEY `idx_audit_created` (`created_at`);

--
-- Indexes for table `login_sessions`
--
ALTER TABLE `login_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token` (`session_token`),
  ADD KEY `idx_sessions_user` (`user_id`),
  ADD KEY `idx_sessions_token` (`session_token`),
  ADD KEY `idx_sessions_expires` (`expires_at`),
  ADD KEY `idx_sessions_active` (`is_active`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_stall` (`stall_number`,`section`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `login_audit`
--
ALTER TABLE `login_audit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_sessions`
--
ALTER TABLE `login_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
