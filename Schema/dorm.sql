-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 16, 2016 at 08:55 PM
-- Server version: 10.1.9-MariaDB
-- PHP Version: 5.6.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dorm`
--

-- --------------------------------------------------------

--
-- Table structure for table `administration`
--

CREATE TABLE `administration` (
  `Faculty_ID` int(11) NOT NULL,
  `canAssign` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `buildings`
--

CREATE TABLE `buildings` (
  `Name` varchar(11) NOT NULL,
  `Manager` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `faculty`
--

CREATE TABLE `faculty` (
  `ID` int(11) NOT NULL,
  `Name` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupleaders`
--

CREATE TABLE `groupleaders` (
  `Student_ID` int(11) NOT NULL,
  `Group_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupmembers`
--

CREATE TABLE `groupmembers` (
  `Group_ID` int(11) NOT NULL,
  `Student_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `ID` int(11) NOT NULL,
  `Name` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`ID`, `Name`) VALUES
(1, 'NewGroup'),
(2, 'SecondGroup'),
(3, 'ThirdGroup?');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `B_Name` varchar(11) NOT NULL,
  `Number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `selectiontimes`
--

CREATE TABLE `selectiontimes` (
  `Student_ID` int(11) NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `studentrooms`
--

CREATE TABLE `studentrooms` (
  `Room_Number` int(11) NOT NULL,
  `Capacity` int(11) DEFAULT NULL,
  `Group_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `ID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `GradYear` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`ID`, `Name`, `GradYear`) VALUES
(20, 'Jake', '2018-08-30');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administration`
--
ALTER TABLE `administration`
  ADD PRIMARY KEY (`Faculty_ID`);

--
-- Indexes for table `buildings`
--
ALTER TABLE `buildings`
  ADD PRIMARY KEY (`Name`),
  ADD KEY `Manager` (`Manager`);

--
-- Indexes for table `faculty`
--
ALTER TABLE `faculty`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `groupleaders`
--
ALTER TABLE `groupleaders`
  ADD PRIMARY KEY (`Student_ID`,`Group_ID`),
  ADD KEY `Group_ID` (`Group_ID`);

--
-- Indexes for table `groupmembers`
--
ALTER TABLE `groupmembers`
  ADD PRIMARY KEY (`Group_ID`,`Student_ID`),
  ADD KEY `Student_ID` (`Student_ID`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`B_Name`,`Number`),
  ADD KEY `Number` (`Number`);

--
-- Indexes for table `selectiontimes`
--
ALTER TABLE `selectiontimes`
  ADD PRIMARY KEY (`Student_ID`);

--
-- Indexes for table `studentrooms`
--
ALTER TABLE `studentrooms`
  ADD PRIMARY KEY (`Room_Number`),
  ADD KEY `Group_ID` (`Group_ID`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `administration`
--
ALTER TABLE `administration`
  ADD CONSTRAINT `administration_ibfk_1` FOREIGN KEY (`Faculty_ID`) REFERENCES `faculty` (`ID`);

--
-- Constraints for table `buildings`
--
ALTER TABLE `buildings`
  ADD CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`Manager`) REFERENCES `administration` (`Faculty_ID`);

--
-- Constraints for table `groupleaders`
--
ALTER TABLE `groupleaders`
  ADD CONSTRAINT `groupleaders_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `groupleaders_ibfk_2` FOREIGN KEY (`Group_ID`) REFERENCES `groups` (`ID`);

--
-- Constraints for table `groupmembers`
--
ALTER TABLE `groupmembers`
  ADD CONSTRAINT `groupmembers_ibfk_1` FOREIGN KEY (`GROUP_ID`) REFERENCES `groups` (`ID`),
  ADD CONSTRAINT `groupmembers_ibfk_2` FOREIGN KEY (`STUDENT_ID`) REFERENCES `students` (`ID`),
  ADD CONSTRAINT `groupmembers_ibfk_3` FOREIGN KEY (`Group_ID`) REFERENCES `groups` (`ID`),
  ADD CONSTRAINT `groupmembers_ibfk_4` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`ID`);

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`B_Name`) REFERENCES `buildings` (`Name`);

--
-- Constraints for table `selectiontimes`
--
ALTER TABLE `selectiontimes`
  ADD CONSTRAINT `selectiontimes_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `students` (`ID`);

--
-- Constraints for table `studentrooms`
--
ALTER TABLE `studentrooms`
  ADD CONSTRAINT `studentrooms_ibfk_1` FOREIGN KEY (`Room_Number`) REFERENCES `rooms` (`Number`),
  ADD CONSTRAINT `studentrooms_ibfk_2` FOREIGN KEY (`Group_ID`) REFERENCES `groups` (`ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
