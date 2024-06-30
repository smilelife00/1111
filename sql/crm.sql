-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2024-04-19 15:03:58
-- 服务器版本： 5.6.50-log
-- PHP 版本： 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `hell`
--

-- --------------------------------------------------------

--
-- 表的结构 `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL COMMENT '会员ID',
  `member_name` varchar(255) DEFAULT NULL COMMENT '会员名称',
  `member_phone` varchar(255) DEFAULT NULL COMMENT '手机号',
  `bed_id` int(11) NOT NULL COMMENT '床位ID',
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `project_name` varchar(11) NOT NULL COMMENT '项目名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` enum('待确认','已确认','已取消','已完成') DEFAULT '待确认' COMMENT '状态',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID',
  `clerk_id` int(11) DEFAULT NULL COMMENT '营业员ID',
  `finish_data` text COMMENT '完成时间',
  `special_req` varchar(255) DEFAULT '无' COMMENT '特殊要求'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `beauty_beds`
--

CREATE TABLE `beauty_beds` (
  `bed_id` int(11) NOT NULL COMMENT '床位ID',
  `bed_name` varchar(255) NOT NULL COMMENT '床位名称',
  `status` enum('可用','不可用') DEFAULT '可用' COMMENT '状态',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `beauty_projects`
--

CREATE TABLE `beauty_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL COMMENT '项目名称',
  `times` int(11) NOT NULL COMMENT '套餐次数',
  `datetime` text COMMENT '创建时间',
  `remark` text COMMENT '备注',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID',
  `single_price` decimal(10,2) DEFAULT '0.00' COMMENT '单次价格',
  `card_price` decimal(10,2) DEFAULT '0.00' COMMENT '套餐价格',
  `duration` int(11) NOT NULL DEFAULT '0' COMMENT '项目时长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `business_hours`
--

CREATE TABLE `business_hours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` enum('星期一','星期二','星期三','星期四','星期五','星期六','星期日') NOT NULL COMMENT '周几',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `clerks`
--

CREATE TABLE `clerks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COMMENT '营业员名称',
  `is_deleted` int(11) DEFAULT '0' COMMENT '是否删除',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID',
  `phone` text COMMENT '手机号',
  `openid` varchar(255) DEFAULT NULL COMMENT 'OpenID',
  `isboss` int(11) NOT NULL DEFAULT '0' COMMENT '店老板',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` bigint(255) NOT NULL COMMENT '商品条码',
  `product_name` varchar(255) NOT NULL COMMENT '商品名称',
  `change_quantity` int(11) NOT NULL COMMENT '变动数量',
  `transaction_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '变动时间',
  `reason` varchar(255) NOT NULL COMMENT '变动原因',
  `creator_id` int(11) DEFAULT NULL COMMENT '门店ID',
  `new_inventory` int(11) DEFAULT NULL COMMENT '数量平衡',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存变动流水表';

-- --------------------------------------------------------

--
-- 表的结构 `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `phone` text NOT NULL,
  `register_date` text NOT NULL,
  `last_consume_date` text,
  `birthday` date DEFAULT NULL,
  `balance` float DEFAULT '0',
  `remark` text,
  `creator_id` int(11) DEFAULT NULL,
  `membership_level` enum('普通卡','银卡','金卡','钻卡','至尊卡') DEFAULT '普通卡',
  `total_recharge_amount` decimal(10,2) DEFAULT '0.00',
  `membership_level_last_updated` datetime DEFAULT NULL,
  `unionid` varchar(255) DEFAULT NULL,
  `wx_openid` varchar(255) DEFAULT NULL COMMENT '微信ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `membership_discounts`
--

CREATE TABLE `membership_discounts` (
  `membership_level` enum('普通卡','银卡','金卡','钻卡','至尊卡') NOT NULL,
  `discount` float DEFAULT NULL,
  `creator_id` int(11) NOT NULL,
  `member_day_discount` float DEFAULT NULL COMMENT '会员日折扣',
  `birthday_discount` float DEFAULT NULL COMMENT '生日折扣',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `membership_level_rules`
--

CREATE TABLE `membership_level_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `membership_level` varchar(255) NOT NULL,
  `upgrade_amount` decimal(10,2) NOT NULL,
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `member_beauty_projects`
--

CREATE TABLE `member_beauty_projects` (
  `member_id` int(11) DEFAULT NULL,
  `beauty_project_id` int(11) DEFAULT NULL,
  `sessions` int(11) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `member_birthday_rules`
--

CREATE TABLE `member_birthday_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day_of_month` int(2) NOT NULL COMMENT '会员日',
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `member_links`
--

CREATE TABLE `member_links` (
  `unionid` varchar(255) NOT NULL,
  `wx_openid` varchar(255) NOT NULL COMMENT '微信ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 触发器 `member_links`
--
DELIMITER $$
CREATE TRIGGER `after_member_link_insert` AFTER INSERT ON `member_links` FOR EACH ROW BEGIN
    IF EXISTS(SELECT 1 FROM members WHERE unionid = NEW.unionid) THEN
        UPDATE members SET wx_openid = NEW.wx_openid WHERE unionid = NEW.unionid;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_member_link_update` AFTER UPDATE ON `member_links` FOR EACH ROW BEGIN
    IF EXISTS(SELECT 1 FROM members WHERE unionid = OLD.unionid) THEN
        UPDATE members SET wx_openid = NEW.wx_openid WHERE unionid = OLD.unionid;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `product_info`
--

CREATE TABLE `product_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` bigint(255) NOT NULL COMMENT '条码',
  `product_name` varchar(255) NOT NULL COMMENT '商品名称',
  `retail_price` decimal(10,2) NOT NULL COMMENT '零售价',
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `product_inventory`
--

CREATE TABLE `product_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(255) NOT NULL COMMENT '商品条码',
  `product_name` varchar(255) NOT NULL COMMENT '商品名称',
  `inventory_quantity` int(11) NOT NULL DEFAULT '0' COMMENT '库存数量',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `creator_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品库存表';

-- --------------------------------------------------------

--
-- 表的结构 `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL COMMENT '会员ID',
  `amount` float DEFAULT NULL COMMENT '金额',
  `transaction_date` text COMMENT '发生日期',
  `remark` text COMMENT '备注',
  `project` text COMMENT '项目/商品',
  `balance` float DEFAULT NULL COMMENT '余额',
  `clerk_id` int(11) DEFAULT NULL COMMENT '营业员ID',
  `reversed` tinyint(1) DEFAULT '0' COMMENT '是否冲账',
  `membership_level` varchar(255) DEFAULT NULL COMMENT '会员等级',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `pay_method` varchar(255) DEFAULT NULL COMMENT '支付方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `storename` varchar(255) DEFAULT NULL COMMENT '门店名称',
  `password_hash` varchar(255) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '经度',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转储表的索引
--
-- 转存表中的数据 `users`
--

INSERT INTO `users` (`id`, `username`, `storename`, `password_hash`, `salt`, `latitude`, `longitude`) VALUES
(1, 'admin', '测试账户', 'e582aa82fdd4df5d2a425920f7f51022c5c0151d32dc693f943a832ca0e683cb', 'random_salt', 23, 113),

--
-- 表的索引 `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `bed_id` (`bed_id`),
  ADD KEY `project_id` (`project_id`);

--
-- 表的索引 `beauty_beds`
--
ALTER TABLE `beauty_beds`
  ADD PRIMARY KEY (`bed_id`);

--
-- 表的索引 `beauty_projects`
--
ALTER TABLE `beauty_projects`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `business_hours`
--
ALTER TABLE `business_hours`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `clerks`
--
ALTER TABLE `clerks`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `membership_discounts`
--
ALTER TABLE `membership_discounts`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `membership_level_rules`
--
ALTER TABLE `membership_level_rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `membership_level` (`membership_level`,`creator_id`);

--
-- 表的索引 `member_beauty_projects`
--
ALTER TABLE `member_beauty_projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `beauty_project_id` (`beauty_project_id`);

--
-- 表的索引 `member_birthday_rules`
--
ALTER TABLE `member_birthday_rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `creator_id` (`creator_id`);

--
-- 表的索引 `member_links`
--
ALTER TABLE `member_links`
  ADD UNIQUE KEY `unionid` (`unionid`);

--
-- 表的索引 `product_info`
--
ALTER TABLE `product_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode_creator_unique` (`barcode`,`creator_id`),
  ADD KEY `creator_id` (`creator_id`);

--
-- 表的索引 `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode_creator_unique` (`barcode`,`creator_id`);

--
-- 表的索引 `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_transactions_members` (`member_id`);

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `beauty_beds`
--
ALTER TABLE `beauty_beds`
  MODIFY `bed_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '床位ID';

--
-- 使用表AUTO_INCREMENT `beauty_projects`
--
ALTER TABLE `beauty_projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `business_hours`
--
ALTER TABLE `business_hours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `clerks`
--
ALTER TABLE `clerks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `membership_discounts`
--
ALTER TABLE `membership_discounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `membership_level_rules`
--
ALTER TABLE `membership_level_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `member_beauty_projects`
--
ALTER TABLE `member_beauty_projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `member_birthday_rules`
--
ALTER TABLE `member_birthday_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `product_info`
--
ALTER TABLE `product_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `product_inventory`
--
ALTER TABLE `product_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 限制导出的表
--

--
-- 限制表 `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`bed_id`) REFERENCES `beauty_beds` (`bed_id`),
  ADD CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `beauty_projects` (`id`);

--
-- 限制表 `member_beauty_projects`
--
ALTER TABLE `member_beauty_projects`
  ADD CONSTRAINT `member_beauty_projects_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `member_beauty_projects_ibfk_2` FOREIGN KEY (`beauty_project_id`) REFERENCES `beauty_projects` (`id`);

--
-- 限制表 `member_birthday_rules`
--
ALTER TABLE `member_birthday_rules`
  ADD CONSTRAINT `member_birthday_rules_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`);

--
-- 限制表 `product_info`
--
ALTER TABLE `product_info`
  ADD CONSTRAINT `product_info_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_members` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
