--
-- Table structure for table `death`
--

CREATE TABLE IF NOT EXISTS `death` (
  `id` int NOT NULL,
  `pod` text NOT NULL COMMENT 'Place of death',
  `coord` text NOT NULL COMMENT 'X, Y, Z POD',
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` text NOT NULL,
  `special` text NOT NULL,
  `name` text NOT NULL,
  `byondkey` text NOT NULL,
  `laname` text NOT NULL COMMENT 'Last attacker name',
  `lakey` text NOT NULL COMMENT 'Last attacker key',
  `gender` text NOT NULL,
  `bruteloss` int NOT NULL,
  `brainloss` int NOT NULL,
  `fireloss` int NOT NULL,
  `oxyloss` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_admin`
--

CREATE TABLE IF NOT EXISTS `erro_admin` (
  `id` int NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL DEFAULT 'Administrator',
  `level` int NOT NULL DEFAULT '0',
  `flags` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_admin_log`
--

CREATE TABLE IF NOT EXISTS `erro_admin_log` (
  `id` int NOT NULL,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `adminip` varchar(18) NOT NULL,
  `log` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_ban`
--

CREATE TABLE IF NOT EXISTS `erro_ban` (
  `id` int NOT NULL,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int NOT NULL,
  `rounds` int DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL DEFAULT '',
  `ip` varchar(32) NOT NULL DEFAULT '',
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL DEFAULT '',
  `a_ip` varchar(32) NOT NULL DEFAULT '',
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text,
  `unbanned` tinyint DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_feedback`
--

CREATE TABLE IF NOT EXISTS `erro_feedback` (
  `id` int NOT NULL,
  `time` datetime NOT NULL,
  `round_id` int NOT NULL,
  `var_name` varchar(32) NOT NULL,
  `var_value` int DEFAULT NULL,
  `details` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_player`
--

CREATE TABLE IF NOT EXISTS `erro_player` (
  `id` int NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_poll_option`
--

CREATE TABLE IF NOT EXISTS `erro_poll_option` (
  `id` int NOT NULL,
  `pollid` int NOT NULL,
  `text` varchar(255) NOT NULL,
  `percentagecalc` tinyint NOT NULL DEFAULT '1',
  `minval` int DEFAULT NULL,
  `maxval` int DEFAULT NULL,
  `descmin` varchar(32) DEFAULT NULL,
  `descmid` varchar(32) DEFAULT NULL,
  `descmax` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_poll_question`
--

CREATE TABLE IF NOT EXISTS `erro_poll_question` (
  `id` int NOT NULL,
  `polltype` varchar(16) NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `adminonly` tinyint DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_poll_textreply`
--

CREATE TABLE IF NOT EXISTS `erro_poll_textreply` (
  `id` int NOT NULL,
  `datetime` datetime NOT NULL,
  `pollid` int NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `replytext` text NOT NULL,
  `adminrank` varchar(32) NOT NULL DEFAULT 'Player'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_poll_vote`
--

CREATE TABLE IF NOT EXISTS `erro_poll_vote` (
  `id` int NOT NULL,
  `datetime` datetime NOT NULL,
  `pollid` int NOT NULL,
  `optionid` int NOT NULL,
  `ckey` varchar(255) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminrank` varchar(32) NOT NULL,
  `rating` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `erro_privacy`
--

CREATE TABLE IF NOT EXISTS `erro_privacy` (
  `id` int NOT NULL,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `option` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `library`
--

CREATE TABLE IF NOT EXISTS `library` (
  `id` int NOT NULL,
  `author` text NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `category` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `population`
--

CREATE TABLE IF NOT EXISTS `population` (
  `id` int NOT NULL,
  `playercount` int DEFAULT NULL,
  `admincount` int DEFAULT NULL,
  `time` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ranks`
--

CREATE TABLE IF NOT EXISTS `ranks` (
  `Rank` int NOT NULL COMMENT 'What Numeric Rank',
  `Desc` text NOT NULL COMMENT 'What is a person with this rank?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int NOT NULL,
  `ckey` text NOT NULL,
  `race` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `death`
--
ALTER TABLE `death`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_admin`
--
ALTER TABLE `erro_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_admin_log`
--
ALTER TABLE `erro_admin_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_ban`
--
ALTER TABLE `erro_ban`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_feedback`
--
ALTER TABLE `erro_feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_player`
--
ALTER TABLE `erro_player`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ckey` (`ckey`);

--
-- Indexes for table `erro_poll_option`
--
ALTER TABLE `erro_poll_option`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_poll_question`
--
ALTER TABLE `erro_poll_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_poll_textreply`
--
ALTER TABLE `erro_poll_textreply`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_poll_vote`
--
ALTER TABLE `erro_poll_vote`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erro_privacy`
--
ALTER TABLE `erro_privacy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `library`
--
ALTER TABLE `library`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `population`
--
ALTER TABLE `population`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ranks`
--
ALTER TABLE `ranks`
  ADD PRIMARY KEY (`Rank`);

--
-- Indexes for table `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `death`
--
ALTER TABLE `death`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_admin`
--
ALTER TABLE `erro_admin`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_admin_log`
--
ALTER TABLE `erro_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_ban`
--
ALTER TABLE `erro_ban`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_feedback`
--
ALTER TABLE `erro_feedback`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_player`
--
ALTER TABLE `erro_player`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_poll_option`
--
ALTER TABLE `erro_poll_option`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_poll_question`
--
ALTER TABLE `erro_poll_question`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_poll_textreply`
--
ALTER TABLE `erro_poll_textreply`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_poll_vote`
--
ALTER TABLE `erro_poll_vote`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erro_privacy`
--
ALTER TABLE `erro_privacy`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `library`
--
ALTER TABLE `library`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `population`
--
ALTER TABLE `population`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `whitelist`
--
ALTER TABLE `whitelist`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
