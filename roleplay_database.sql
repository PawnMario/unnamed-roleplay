-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Czas generowania: 18 Mar 2019, 19:19
-- Wersja serwera: 10.1.13-MariaDB
-- Wersja PHP: 5.5.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `roleplay_database`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `myrp_characters`
--

CREATE TABLE `myrp_characters` (
  `char_uid` int(11) NOT NULL,
  `char_gid` int(11) NOT NULL,
  `char_name` varchar(32) NOT NULL,
  `char_time` int(11) NOT NULL,
  `char_cash` int(11) NOT NULL DEFAULT '850',
  `char_bankcash` int(11) NOT NULL,
  `char_skin` smallint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `myrp_characters`
--

INSERT INTO `myrp_characters` (`char_uid`, `char_gid`, `char_name`, `char_time`, `char_cash`, `char_bankcash`, `char_skin`) VALUES
(0, 0, 'Mario323', 1467456477, 0, 0, 0),
(1, 5, 'Mario', -721975647, 850, 0, 162);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `myrp_char_groups`
--

CREATE TABLE `myrp_char_groups` (
  `char_uid` int(11) NOT NULL,
  `group_belongs` int(11) NOT NULL,
  `group_perm` mediumint(6) NOT NULL,
  `group_title` varchar(32) NOT NULL,
  `group_payment` int(11) NOT NULL,
  `group_skin` smallint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `myrp_char_groups`
--

INSERT INTO `myrp_char_groups` (`char_uid`, `group_belongs`, `group_perm`, `group_title`, `group_payment`, `group_skin`) VALUES
(1, 8, 0, '', 0, 0),
(1, 6, 0, '', 0, 0),
(1, 11, 11, '', 0, 0),
(1, 12, 11, '', 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `myrp_groups`
--

CREATE TABLE `myrp_groups` (
  `group_uid` int(11) NOT NULL,
  `group_name` varchar(32) NOT NULL,
  `group_type` smallint(2) NOT NULL,
  `group_cash` int(11) NOT NULL,
  `group_tag` varchar(5) NOT NULL DEFAULT 'NONE',
  `group_color` int(11) NOT NULL,
  `group_flags` int(11) NOT NULL,
  `group_owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `myrp_groups`
--

INSERT INTO `myrp_groups` (`group_uid`, `group_name`, `group_type`, `group_cash`, `group_tag`, `group_color`, `group_flags`, `group_owner`) VALUES
(1, 'Testowa grupa', 1, 0, 'TEST', 0, 0, 0),
(2, 'Siema test', 5, 0, 'SIEM', 0, 0, 0),
(3, 'GRUPA 15', 15, 0, '', 0, 0, 0),
(4, 'GRUPSON', 11, 0, '', 0, 0, 0),
(5, 'GRUPINSON', 15, 0, 'GROP', -1, 0, 0),
(6, 'Central Gym', -1, 0, 'GYM', -10270806, 0, 0),
(7, 'GYM', 4, 0, 'NONE', -1, 0, 0),
(8, 'Central Bank', 10, 0, 'BANK', 866792362, 0, 0),
(9, 'Test', 1, 0, 'NONE', -1, 0, 0),
(10, 'GROVE STREET HOME', 20, 0, 'NONE', 866792362, 0, 0),
(11, 'Central Bar', 2, 0, 'EAT', -65366, 0, 0),
(12, 'Central Hotel', 9, 0, 'SNOO', 48042, 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `myrp_items`
--

CREATE TABLE `myrp_items` (
  `item_uid` int(11) NOT NULL,
  `item_name` varchar(32) NOT NULL,
  `item_value1` int(11) NOT NULL,
  `item_value2` int(11) NOT NULL,
  `item_place` tinyint(1) NOT NULL,
  `item_owner` int(11) NOT NULL,
  `item_type` int(11) NOT NULL,
  `item_posx` float NOT NULL,
  `item_posy` float NOT NULL,
  `item_posz` float NOT NULL,
  `item_world` int(11) NOT NULL,
  `item_interior` int(11) NOT NULL,
  `item_favorite` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `myrp_items`
--

INSERT INTO `myrp_items` (`item_uid`, `item_name`, `item_value1`, `item_value2`, `item_place`, `item_owner`, `item_type`, `item_posx`, `item_posy`, `item_posz`, `item_world`, `item_interior`, `item_favorite`) VALUES
(1, 'TestowyItem', 2570, 0, 0, 0, 21, 1797.21, -1904.85, 13.4, 0, 0, 0),
(2, 'Hamburger', 770, 0, 0, 0, 21, 1797.21, -1904.85, 13.5136, 0, 0, 0),
(3, 'Przedmiot:0', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(4, 'Przedmiot:1', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(5, 'Przedmiot:2', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(6, 'Przedmiot:3', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(7, 'Przedmiot:4', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(8, 'Przedmiot:5', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(9, 'Przedmiot:6', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(10, 'Przedmiot:7', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(13, 'Przedmiot:10', 0, 0, 0, 0, 10, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(14, 'Przedmiot:11', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(15, 'Przedmiot:12', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(16, 'Przedmiot:13', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(17, 'Przedmiot:14', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(18, 'Przedmiot:15', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(19, 'Przedmiot:16', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(20, 'Przedmiot:17', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(21, 'Przedmiot:18', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(22, 'Przedmiot:19', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(26, 'Przedmiot:23', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(27, 'Przedmiot:24', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(28, 'Przedmiot:25', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(30, 'Przedmiot:27', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(31, 'Przedmiot:28', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(32, 'Przedmiot:29', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(33, 'Przedmiot:30', 0, 0, 0, 0, 0, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(34, 'Przedmiot:31', 0, 0, 0, 0, 0, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(35, 'Przedmiot:32', 0, 0, 0, 0, 0, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(36, 'Przedmiot:33', 0, 0, 0, 0, 0, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(37, 'Przedmiot:34', 0, 0, 0, 0, 0, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(41, 'Przedmiot:21', 0, 0, 0, 0, 3, 1958.04, 1310.81, 9.2501, 0, 0, 0),
(42, 'ITEMEK', 37, 0, 0, 0, 3, 1797.21, -1904.85, 13.6271, 0, 0, 0),
(50, 'Hamburgerowy Tost', 20, 30, 0, 0, 1, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(51, 'Hamburgerowy Tost', 20, 30, 0, 0, 2, 1958.31, 1310.24, 9.2501, 0, 0, 0),
(55, 'Hamburger', 30, 0, 0, 0, 2, 1748.87, -1857.9, 13.4141, 0, 0, 0),
(56, 'Rolki ROLLERCASTER', 0, 0, 1, 1, 29, 1764.16, -1865.09, 13.5731, 0, 0, 1),
(57, 'Torba NIKE', -794, 0, 0, 0, 21, 1767.99, -1853.43, 13.4141, 0, 0, 1),
(63, 'L&D', 28, 2, 0, 0, 3, 1752.19, -1856.04, 13.4141, 0, 0, 0),
(64, 'Czysta p³yta', 0, 0, 0, 0, 24, 1746.78, -1855.99, 13.4141, 0, 0, 1),
(68, 'Sledzie w sosie', 30, 0, 0, 0, 2, 1746.78, -1855.99, 13.4141, 0, 0, 0),
(69, 'Wodka', 23, 0, 0, 0, 22, 1752.19, -1856.04, 13.4141, 0, 0, 0),
(71, 'AK-47', 31, 500, 0, 0, 6, 1746.65, -1856.55, 13.4141, 0, 0, 0),
(72, 'TEST', 11, 4, 0, 0, 2, 1746.99, -1858, 13.4141, 0, 0, 0),
(73, 'Torba Reebok', 618, 0, 0, 0, 21, 1766.86, -1854.75, 13.4141, 0, 0, 0),
(74, 'Torbella', 220, 0, 0, 0, 21, 1795.03, -1901.49, 13.4003, 0, 0, 0),
(75, 'Torba NIKE', 0, 0, 1, 1, 21, 0, 0, 0, 0, 0, 1),
(76, 'Audio Book', 0, 0, 0, 0, 0, 1746.13, -1857.72, 13.4141, 0, 0, 0),
(77, 'Czester', 0, 0, 0, 0, 0, 1735.53, -1854.95, 13.4141, 0, 0, 0),
(78, 'Gizmo', 0, 0, 0, 0, 0, 1735.53, -1854.95, 13.4141, 0, 0, 0),
(79, 'Hugo', 0, 0, 0, 0, 0, 1735.53, -1854.95, 13.4141, 0, 0, 0),
(80, 'Ziomex', 0, 0, 0, 0, 0, 1735.53, -1854.95, 13.4141, 0, 0, 0),
(81, 'Ziomex', 0, 0, 0, 0, 0, 1746.13, -1857.72, 13.4141, 0, 0, 0),
(82, 'Hugo', 0, 0, 0, 0, 0, 1746.13, -1857.72, 13.4141, 0, 0, 0),
(83, 'Gizmo', 0, 0, 0, 0, 0, 1746.13, -1857.72, 13.4141, 0, 0, 0),
(84, 'Hugo', 0, 0, 0, 0, 0, 1749.83, -1855.13, 13.4141, 0, 0, 0),
(85, 'Gizmo', 0, 0, 0, 0, 0, 1749.83, -1855.13, 13.4141, 0, 0, 0),
(86, 'Ziomex', 0, 0, 0, 0, 0, 1749.83, -1855.13, 13.4141, 0, 0, 0),
(87, 'Gizmo', 0, 0, 0, 0, 0, 1751.25, -1852.65, 13.4141, 0, 0, 0),
(88, 'Ziomex', 0, 0, 0, 0, 0, 1751.25, -1852.65, 13.4141, 0, 0, 0),
(89, 'Eugeniusz', 0, 0, 0, 0, 0, 1751.25, -1852.65, 13.4141, 0, 0, 0),
(90, 'Eugeniusz', 0, 0, 0, 0, 0, 1746.99, -1855.84, 13.4141, 0, 0, 0),
(91, 'Ziomex', 0, 0, 0, 0, 0, 1752.95, -1856.13, 13.4141, 0, 0, 0),
(92, 'Gizmo', 0, 0, 0, 0, 0, 1746.99, -1855.84, 13.4141, 0, 0, 0),
(93, 'Ziomex', 0, 0, 0, 0, 0, 1746.99, -1855.84, 13.4141, 0, 0, 0),
(94, 'Gizmo', 0, 0, 0, 0, 0, 1744.73, -1856.07, 13.4141, 0, 0, 0),
(95, 'Ziomex', 0, 0, 0, 0, 0, 1744.73, -1856.07, 13.4141, 0, 0, 0),
(96, 'Lolo', 0, 0, 0, 0, 0, 1744.73, -1856.07, 13.4141, 0, 0, 0),
(97, 'Lolo', 0, 0, 0, 0, 0, 1752.95, -1856.13, 13.4141, 0, 0, 0),
(98, 'Gizmo', 0, 0, 0, 0, 0, 1752.95, -1856.13, 13.4141, 0, 0, 0),
(99, 'Gizmo', 0, 0, 0, 0, 0, 1752.77, -1857.74, 13.4141, 0, 0, 0),
(100, 'Lolo', 0, 0, 0, 0, 0, 1752.77, -1857.74, 13.4141, 0, 0, 0),
(101, 'Zyzu', 0, 0, 0, 0, 0, 1752.77, -1857.74, 13.4141, 0, 0, 0),
(102, 'Zyzu', 0, 0, 0, 0, 0, 1748.32, -1854.8, 13.4141, 0, 0, 0),
(103, 'Lolo', 0, 0, 0, 0, 0, 1748.32, -1854.8, 13.4141, 0, 0, 0),
(104, 'Gizmo', 0, 0, 0, 0, 0, 1748.32, -1854.8, 13.4141, 0, 0, 0),
(105, 'Gizmo', 0, 0, 0, 0, 0, 1750.22, -1856.28, 13.4141, 0, 0, 0),
(106, 'Lolo', 0, 0, 0, 0, 0, 1750.22, -1856.28, 13.4141, 0, 0, 0),
(107, 'Zyzu', 0, 0, 0, 0, 0, 1750.22, -1856.28, 13.4141, 0, 0, 0),
(108, 'Zyzu', 0, 0, 0, 0, 0, 1751.33, -1857.03, 13.4141, 0, 0, 0),
(109, 'Lolo', 0, 0, 0, 0, 0, 1751.33, -1857.03, 13.4141, 0, 0, 0),
(110, 'Gizmo', 0, 0, 0, 0, 0, 1751.33, -1857.03, 13.4141, 0, 0, 0),
(111, 'Gizmo', 0, 0, 0, 0, 0, 1748.73, -1855.65, 13.4141, 0, 0, 0),
(112, 'Lolo', 0, 0, 0, 0, 0, 1748.73, -1855.65, 13.4141, 0, 0, 0),
(113, 'Zyzu', 0, 0, 0, 0, 0, 1748.73, -1855.65, 13.4141, 0, 0, 0),
(114, 'Zyzu', 0, 0, 0, 0, 0, 1748.46, -1855.43, 13.4141, 0, 0, 0),
(115, 'Lolo', 0, 0, 0, 0, 0, 1748.46, -1855.43, 13.4141, 0, 0, 0),
(116, 'Gizmo', 0, 0, 0, 0, 0, 1748.46, -1855.43, 13.4141, 0, 0, 0),
(117, 'Gizmo', 0, 0, 0, 0, 0, 1747.42, -1855.8, 13.4141, 0, 0, 0),
(118, 'Lolo', 0, 0, 0, 0, 0, 1747.42, -1855.8, 13.4141, 0, 0, 0),
(119, 'Lolo', 0, 0, 0, 0, 0, 1747.18, -1856.99, 13.4141, 0, 0, 0),
(120, 'Gizmo', 0, 0, 0, 0, 0, 1747.18, -1856.99, 13.4141, 0, 0, 0),
(121, 'Ekler', 0, 0, 0, 0, 0, 1747.18, -1856.99, 13.4141, 0, 0, 0),
(122, 'Ekler', 0, 0, 0, 0, 0, 1747.44, -1857.74, 13.4141, 0, 0, 0),
(123, 'Gizmo', 0, 0, 0, 0, 0, 1747.44, -1857.74, 13.4141, 0, 0, 0),
(124, 'Lolo', 0, 0, 0, 0, 0, 1747.44, -1857.74, 13.4141, 0, 0, 0),
(125, 'Lolo', 0, 0, 0, 0, 0, 1751.58, -1852.41, 13.4141, 0, 0, 0),
(126, 'Gizmo', 0, 0, 0, 0, 0, 1751.58, -1852.41, 13.4141, 0, 0, 0),
(127, 'Ekler', 0, 0, 0, 0, 0, 1751.58, -1852.41, 13.4141, 0, 0, 0),
(128, 'Ekler', 0, 0, 0, 0, 0, 1747.38, -1857.58, 13.4141, 0, 0, 0),
(129, 'Gizmo', 0, 0, 0, 0, 0, 1747.38, -1857.58, 13.4141, 0, 0, 0),
(130, 'Lolo', 0, 0, 0, 0, 0, 1747.38, -1857.58, 13.4141, 0, 0, 0),
(131, 'Gizmo', 0, 0, 0, 0, 0, 1748.28, -1854.15, 13.4141, 0, 0, 0),
(132, 'Lolo', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(133, 'Gizmo', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(134, 'Kutas', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(135, 'Dombas', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(136, 'Kukiz', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(137, 'Johnny', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(138, 'Kalesony', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(139, 'Blaupunkt', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(140, 'Giorgio', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(141, 'Dupsztyl', 0, 0, 0, 0, 0, 1748.49, -1856.46, 13.4141, 0, 0, 0),
(142, 'Dupsztyl', 0, 0, 0, 0, 0, 1748.28, -1854.15, 13.4141, 0, 0, 0),
(143, 'Giorgio', 0, 0, 0, 0, 0, 1748.28, -1854.15, 13.4141, 0, 0, 0),
(144, 'Blaupunkt', 0, 0, 0, 0, 0, 1748.28, -1854.15, 13.4141, 0, 0, 0),
(145, 'Blaupunkt', 0, 0, 0, 0, 0, 1752.57, -1853.72, 13.4141, 0, 0, 0),
(146, 'Giorgio', 0, 0, 0, 0, 0, 1752.57, -1853.72, 13.4141, 0, 0, 0),
(147, 'Dupsztyl', 0, 0, 0, 0, 0, 1752.57, -1853.72, 13.4141, 0, 0, 0),
(148, 'Dupsztyl', 0, 0, 0, 0, 0, 1749.91, -1856.59, 13.4141, 0, 0, 0),
(149, 'Giorgio', 0, 0, 0, 0, 0, 1749.91, -1856.59, 13.4141, 0, 0, 0),
(150, 'Blaupunkt', 0, 0, 0, 0, 0, 1749.91, -1856.59, 13.4141, 0, 0, 0),
(151, 'Giorgio', 0, 0, 0, 0, 0, 1750.83, -1853.52, 13.4141, 0, 0, 0),
(152, 'Blaupunkt', 0, 0, 0, 0, 0, 1750.83, -1853.52, 13.4141, 0, 0, 0),
(153, 'Dupsztyl', 0, 0, 0, 0, 0, 1750.83, -1853.52, 13.4141, 0, 0, 0),
(32560, 'Blaupunkt', 0, 0, 0, 0, 0, 1750.29, -1855.39, 13.4141, 0, 0, 0),
(32561, 'Dupsztyl', 0, 0, 0, 0, 0, 1750.29, -1855.39, 13.4141, 0, 0, 0),
(32562, 'Giorgio', 0, 0, 0, 0, 0, 1750.29, -1855.39, 13.4141, 0, 0, 0),
(32563, 'Giorgio', 0, 0, 0, 0, 0, 1748.67, -1855.71, 13.4141, 0, 0, 0),
(32564, 'Dupsztyl', 0, 0, 0, 0, 0, 1748.67, -1855.71, 13.4141, 0, 0, 0),
(32565, 'Blaupunkt', 0, 0, 0, 0, 0, 1748.67, -1855.71, 13.4141, 0, 0, 0),
(32566, 'Okulary', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32567, 'Ciemny podkoszulek', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32568, 'Rolki', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32569, 'Kawalek Pizzy', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32570, 'Lody', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32571, 'Marihuana', 0, 0, 0, 0, 0, 1653.8, -1890.32, 13.5521, 0, 0, 0),
(32572, 'Marihuana', 0, 0, 1, 1, 0, 1765.41, -1849.43, 13.5781, 0, 0, 0),
(32573, 'Kawalek Pizzy', 0, 0, 0, 0, 0, 1747.07, -1856.51, 13.4141, 0, 0, 0),
(32574, 'Lody', 0, 0, 1, 1, 0, 1765.41, -1849.43, 13.5781, 0, 0, 0),
(32575, 'Kawalek Pizzy', 0, 0, 1, 1, 0, 1749.64, -1855.74, 13.4141, 0, 0, 0),
(32576, 'Czapka', 0, 0, 0, 0, 0, 1750.98, -1858.97, 13.4141, 0, 0, 0),
(32577, 'Amfetamina', 0, 0, 0, 0, 0, 1750.98, -1858.97, 13.4141, 0, 0, 0),
(32578, 'Rolki', 0, 0, 0, 0, 0, 1750.98, -1858.97, 13.4141, 0, 0, 0),
(32579, 'Rekawice', 0, 0, 1, 1, 0, 1765.41, -1849.43, 13.5781, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `myrp_vehicles`
--

CREATE TABLE `myrp_vehicles` (
  `veh_uid` int(11) NOT NULL,
  `veh_model` smallint(3) NOT NULL,
  `veh_posx` float NOT NULL,
  `veh_posy` float NOT NULL,
  `veh_posz` float NOT NULL,
  `veh_posa` float NOT NULL,
  `veh_col1` smallint(3) NOT NULL,
  `veh_col2` smallint(3) NOT NULL,
  `veh_int` int(11) NOT NULL,
  `veh_world` int(11) NOT NULL,
  `veh_ownertype` tinyint(1) NOT NULL,
  `veh_owner` int(11) NOT NULL,
  `veh_health` float NOT NULL DEFAULT '1000',
  `veh_mileage` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `myrp_vehicles`
--

INSERT INTO `myrp_vehicles` (`veh_uid`, `veh_model`, `veh_posx`, `veh_posy`, `veh_posz`, `veh_posa`, `veh_col1`, `veh_col2`, `veh_int`, `veh_world`, `veh_ownertype`, `veh_owner`, `veh_health`, `veh_mileage`) VALUES
(1, 411, 1947.06, 1312.85, 9.109, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(2, 411, 1948.07, 1322.66, 9.109, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(3, 411, 1965.61, 1368.49, 9.258, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(4, 411, 1951.23, 1302.63, 9.109, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(5, 411, 1943.49, 1294.03, 9.331, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(6, 411, 1944.91, 1309.84, 9.109, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(7, 411, 1950.27, 1316.51, 9.109, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(8, 411, 1939.83, 1320.06, 9.258, 0, 32, 44, 0, 0, 1, 1, 1000, 0),
(9, 411, 1951.78, 1308.49, 9.109, 0, 32, 44, 0, 0, 0, 0, 1000, 0),
(10, 411, 1939.77, 1299.93, 9.258, 0, 32, 44, 0, 0, 0, 0, 1000, 0),
(11, 462, 1966.68, 1285.43, 10.82, 0, 11, 54, 0, 0, 1, 1, 1000, 0),
(12, 411, 1970.25, 1281.29, 10.82, 0, 31, 4, 0, 0, 0, 0, 1000, 0),
(13, 411, 1969.17, 1287.88, 10.82, 0, 31, 4, 0, 0, 2, 10, 1000, 0),
(14, 462, 1765.41, -1845.52, 13.577, 0, 11, 55, 0, 0, 0, 0, 1000, 0),
(15, 468, 1803.17, -1843.14, 13.2463, 204.301, 32, 44, 0, 0, 1, 1, 778.624, 0),
(16, 411, 1817.8, -1898.54, 13.401, 0, 3, 3, 0, 0, 0, 0, 1000, 0),
(17, 411, 1758.98, -1851.9, 13.414, 0, 3, 4, 0, 0, 0, 0, 1000, 0);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `myrp_characters`
--
ALTER TABLE `myrp_characters`
  ADD PRIMARY KEY (`char_uid`);

--
-- Indexes for table `myrp_groups`
--
ALTER TABLE `myrp_groups`
  ADD PRIMARY KEY (`group_uid`);

--
-- Indexes for table `myrp_items`
--
ALTER TABLE `myrp_items`
  ADD PRIMARY KEY (`item_uid`),
  ADD KEY `owner` (`item_place`,`item_owner`);

--
-- Indexes for table `myrp_vehicles`
--
ALTER TABLE `myrp_vehicles`
  ADD PRIMARY KEY (`veh_uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `myrp_characters`
--
ALTER TABLE `myrp_characters`
  MODIFY `char_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT dla tabeli `myrp_groups`
--
ALTER TABLE `myrp_groups`
  MODIFY `group_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT dla tabeli `myrp_items`
--
ALTER TABLE `myrp_items`
  MODIFY `item_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32580;
--
-- AUTO_INCREMENT dla tabeli `myrp_vehicles`
--
ALTER TABLE `myrp_vehicles`
  MODIFY `veh_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
