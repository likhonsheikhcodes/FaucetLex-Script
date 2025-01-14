-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 05-01-2025 a las 17:28:01
-- Versión del servidor: 10.11.11-MariaDB
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u909036809_teledbdata`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referral_history`
--

CREATE TABLE `referral_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `referred_user_id` int(11) NOT NULL,
  `reward_amount` decimal(10,6) NOT NULL,
  `claim_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(255) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`, `description`) VALUES
(1, 'hcaptcha_site_key', '', 'The public site key for hCaptcha.'),
(2, 'hcaptcha_secret_key', '', 'The secret key for server-side validation of hCaptcha.'),
(3, 'banner_pop_html', '<iframe data-aa=\'2335393\' src=\'//ad.a-ads.com/2335393?size=125x125\' style=\'width:125px; height:125px; border:0px; padding:0; overflow:hidden; background-color: transparent;\'></iframe>\n', 'HTML code for the pop-up banner ad.'),
(4, 'banner_pop_enabled', 'true', 'Enable or disable the pop-up banner.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings_api`
--

CREATE TABLE `settings_api` (
  `id` int(11) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `api_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings_api`
--

INSERT INTO `settings_api` (`id`, `api_key`, `api_value`) VALUES
(1, 'faucetpay_api_key', 'YOURAPI');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings_claim`
--

CREATE TABLE `settings_claim` (
  `id` int(11) NOT NULL,
  `button_label` varchar(50) NOT NULL,
  `reward_amount` decimal(10,6) NOT NULL,
  `cooldown` int(11) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings_claim`
--

INSERT INTO `settings_claim` (`id`, `button_label`, `reward_amount`, `cooldown`, `description`) VALUES
(1, 'Claim 1', 0.000027, 1, 'First claim button, cooldown of 15 minutes.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings_referral`
--

CREATE TABLE `settings_referral` (
  `id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `referral_percentage` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings_referral`
--

INSERT INTO `settings_referral` (`id`, `description`, `referral_percentage`) VALUES
(1, 'Referral Reward Percentage', 90.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings_refferal`
--

CREATE TABLE `settings_refferal` (
  `id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `reward_amount` decimal(10,6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings_refferal`
--

INSERT INTO `settings_refferal` (`id`, `description`, `reward_amount`) VALUES
(1, 'Reward', 0.000027);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `settings_withdraw`
--

CREATE TABLE `settings_withdraw` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(255) NOT NULL,
  `setting_value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `settings_withdraw`
--

INSERT INTO `settings_withdraw` (`id`, `setting_key`, `setting_value`) VALUES
(1, 'min_withdraw_amount', '0.0003'),
(2, 'max_withdrawals_per_day', '3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SiteContent`
--

CREATE TABLE `SiteContent` (
  `id` int(11) NOT NULL,
  `content_key` varchar(255) NOT NULL,
  `content_value` text NOT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `SiteContent`
--

INSERT INTO `SiteContent` (`id`, `content_key`, `content_value`, `last_updated`) VALUES
(1, 'site_title', 'EARN USDT', '2024-06-16 18:22:04'),
(2, 'welcome_message', 'Welcome to our Tether Faucet! Please disable any ad blockers to ensure full functionality of the platform.', '2024-06-16 18:21:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Users`
--

CREATE TABLE `Users` (
  `id` int(11) NOT NULL,
  `wallet_address` varchar(255) NOT NULL,
  `balance` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `registration_date` timestamp NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) NOT NULL,
  `referral_code` varchar(64) NOT NULL,
  `referred_by` int(11) DEFAULT NULL,
  `last_claim_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `Users`
--

INSERT INTO `Users` (`id`, `wallet_address`, `balance`, `registration_date`, `ip_address`, `referral_code`, `referred_by`, `last_claim_time`) VALUES
(169, 'TREvY2bkf2mDP7E4ktMqgMYNMnqEMESXe8', 0.000081, '2024-06-29 10:32:23', '2a02:a58:85c4:e600:5523:20ff:4bd0:1966', '81009', NULL, '2024-07-02 04:53:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `withdrawal_history`
--

CREATE TABLE `withdrawal_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(20,6) NOT NULL,
  `withdrawal_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `withdrawal_limits`
--

CREATE TABLE `withdrawal_limits` (
  `user_id` int(11) NOT NULL,
  `withdrawal_date` date NOT NULL,
  `withdrawal_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `referral_history`
--
ALTER TABLE `referral_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `referred_user_id` (`referred_user_id`);

--
-- Indices de la tabla `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indices de la tabla `settings_api`
--
ALTER TABLE `settings_api`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `settings_claim`
--
ALTER TABLE `settings_claim`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `button_label` (`button_label`);

--
-- Indices de la tabla `settings_referral`
--
ALTER TABLE `settings_referral`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `settings_refferal`
--
ALTER TABLE `settings_refferal`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `settings_withdraw`
--
ALTER TABLE `settings_withdraw`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `SiteContent`
--
ALTER TABLE `SiteContent`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `content_key` (`content_key`);

--
-- Indices de la tabla `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wallet_address` (`wallet_address`),
  ADD UNIQUE KEY `referral_code` (`referral_code`),
  ADD KEY `referred_by` (`referred_by`);

--
-- Indices de la tabla `withdrawal_history`
--
ALTER TABLE `withdrawal_history`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `withdrawal_limits`
--
ALTER TABLE `withdrawal_limits`
  ADD PRIMARY KEY (`user_id`,`withdrawal_date`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `referral_history`
--
ALTER TABLE `referral_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `settings_api`
--
ALTER TABLE `settings_api`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `settings_claim`
--
ALTER TABLE `settings_claim`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `settings_referral`
--
ALTER TABLE `settings_referral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `settings_refferal`
--
ALTER TABLE `settings_refferal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `settings_withdraw`
--
ALTER TABLE `settings_withdraw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `SiteContent`
--
ALTER TABLE `SiteContent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=644;

--
-- AUTO_INCREMENT de la tabla `withdrawal_history`
--
ALTER TABLE `withdrawal_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=308;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `referral_history`
--
ALTER TABLE `referral_history`
  ADD CONSTRAINT `referral_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  ADD CONSTRAINT `referral_history_ibfk_2` FOREIGN KEY (`referred_user_id`) REFERENCES `Users` (`id`);

--
-- Filtros para la tabla `Users`
--
ALTER TABLE `Users`
  ADD CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`referred_by`) REFERENCES `Users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
