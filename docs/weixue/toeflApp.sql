-- phpMyAdmin SQL Dump
-- version 4.6.0
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 30, 2019 at 08:03 PM
-- Server version: 5.5.48
-- PHP Version: 5.6.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `toeflApp`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_assignment`
--

CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  `created_at` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `auth_item`
--

CREATE TABLE `auth_item` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `description` text,
  `rule_name` varchar(64) DEFAULT NULL,
  `data` text,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `auth_item_child`
--

CREATE TABLE `auth_item_child` (
  `parent` varchar(64) NOT NULL,
  `child` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `auth_rule`
--

CREATE TABLE `auth_rule` (
  `name` varchar(64) NOT NULL,
  `data` text,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  `route` varchar(256) DEFAULT NULL,
  `type` smallint(4) NOT NULL DEFAULT '0' COMMENT '后台菜单：0，前台菜单1',
  `level` smallint(4) NOT NULL DEFAULT '0' COMMENT '层级',
  `order` int(11) DEFAULT NULL,
  `data` blob
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbActivity`
--

CREATE TABLE `tbActivity` (
  `id` int(11) NOT NULL,
  `fdName` varchar(255) NOT NULL COMMENT '活动名称',
  `fdLink` varchar(255) NOT NULL COMMENT '活动链接',
  `fdStart` datetime NOT NULL COMMENT '开始时间',
  `fdEnd` datetime NOT NULL COMMENT '结束时间',
  `fdUserID` int(11) NOT NULL COMMENT '创建人ID',
  `fdStatus` int(2) NOT NULL DEFAULT '0' COMMENT '状态：0-关闭1-开启',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbActivityMap`
--

CREATE TABLE `tbActivityMap` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL COMMENT '资源内容examitem.entity.ID，对应tbEntity.id',
  `fdActivityID` int(11) NOT NULL COMMENT '活动ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbAdminLog`
--

CREATE TABLE `tbAdminLog` (
  `id` int(11) NOT NULL,
  `fdRoute` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `fdDescription` text CHARACTER SET utf8,
  `fdCreate` int(10) NOT NULL DEFAULT '0',
  `fdUserID` int(10) NOT NULL DEFAULT '0',
  `fdIP` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswer`
--

CREATE TABLE `tbAnswer` (
  `id` int(11) NOT NULL,
  `fdQuestionID` int(11) NOT NULL COMMENT '问题标识，对应tbQuestion.id',
  `fdText` text NOT NULL COMMENT '解答正文',
  `fdUserID` int(11) NOT NULL COMMENT '用户标识，对应service.tbUser.id',
  `fdCreate` datetime NOT NULL COMMENT '回答日期时间',
  `fdDisabled` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-正常, 1-屏蔽'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='问题解答';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerExam`
--

CREATE TABLE `tbAnswerExam` (
  `id` int(11) NOT NULL,
  `fdName` varchar(255) DEFAULT NULL COMMENT '报告名称',
  `fdUserID` int(11) NOT NULL COMMENT '对应tbUser.id',
  `fdExamID` int(11) NOT NULL COMMENT '试卷ID',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdStart` datetime DEFAULT NULL COMMENT '开始做试卷的时间',
  `fdEnd` datetime DEFAULT NULL COMMENT '介绍做试卷的时间',
  `fdUsed` int(11) NOT NULL DEFAULT '0' COMMENT '试卷已经使用的时间(单位是秒)',
  `fdScore` double DEFAULT NULL COMMENT '试卷总得分',
  `fdScoreRate` tinyint(4) DEFAULT '0' COMMENT '得分率 0-100',
  `fdRate` tinyint(4) DEFAULT '0' COMMENT '答题正确率，0最低，100最好',
  `fdStatus` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态  0：未交卷，1：交卷,2:删除记录',
  `fdType` int(11) DEFAULT '0' COMMENT '试卷类型，当前答题所在位置：0：作业，1：上课',
  `fdAppID` int(11) DEFAULT '0' COMMENT '应用ID',
  `fdMethod` tinyint(4) DEFAULT '0' COMMENT '答卷方式0：普通方式，1：拍卷，2：扫卷',
  `fdSelf` tinyint(4) DEFAULT '0' COMMENT '是否完成自评 0未完成 1完成',
  `fdSeriesID` int(11) DEFAULT NULL COMMENT '如果该答题是复习类型, 则需填对应的系列ID',
  `fdOrigin` int(2) NOT NULL DEFAULT '0' COMMENT '答卷来源，0普通，1作业',
  `fdAttribute` text COMMENT '答题额外的信息：目前主要是听力词汇的答题模式、音频速度、答题时间、顺序'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='回答试卷';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerExamItem`
--

CREATE TABLE `tbAnswerExamItem` (
  `id` int(11) NOT NULL,
  `fdAnswerExamID` int(11) NOT NULL,
  `fdExamID` int(13) NOT NULL COMMENT '试卷ID',
  `fdExamItemID` int(11) DEFAULT '0' COMMENT '专题ID',
  `fdScore` int(11) DEFAULT NULL COMMENT '本题最终得分',
  `fdOrder` int(11) DEFAULT NULL,
  `fdStatus` int(11) NOT NULL DEFAULT '0' COMMENT '状态. 0:未选, 1:已选',
  `fdType` int(11) NOT NULL DEFAULT '0' COMMENT '答题类型,0:默认类型; 1: 专题;2:专题复习'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回答试卷中的题目';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerExercise`
--

CREATE TABLE `tbAnswerExercise` (
  `id` int(11) NOT NULL,
  `fdAnswerExamID` int(11) NOT NULL COMMENT '关联的tb.AnswerExam.id,冗余的字段, 用于快速查询',
  `fdAnswerQuestionID` int(11) DEFAULT '0' COMMENT '答题ID 对应到tbAnswerQuestion.id',
  `fdExerciseItemID` int(11) NOT NULL,
  `fdRight` varchar(255) DEFAULT NULL COMMENT '客观题选项',
  `fdSelf` double DEFAULT NULL COMMENT '自评总得分',
  `fdTscore` double DEFAULT NULL COMMENT '教师评分',
  `fdScore` double DEFAULT NULL COMMENT '本题最终得分',
  `fdOrder` int(11) DEFAULT NULL,
  `fdVanalysis` tinyint(4) DEFAULT '0' COMMENT '是否察看答案解析',
  `fdVweike` tinyint(4) DEFAULT '0' COMMENT '是否查看了解析微课',
  `fdVidea` tinyint(4) DEFAULT '0' COMMENT '是否查看解析思路',
  `fdVideaweike` tinyint(4) DEFAULT '0' COMMENT '是否查看解题思路微课',
  `fdUsed` int(11) NOT NULL COMMENT '答题时间, 以秒为单位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回答试卷中的题目';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerGist`
--

CREATE TABLE `tbAnswerGist` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `fdFileID` int(11) UNSIGNED NOT NULL COMMENT '精听文件ID：音频ID',
  `fdSection` smallint(4) NOT NULL COMMENT '当前段落序号',
  `fdText` text COMMENT '段落概括内容',
  `fdAnalyse` text COMMENT '段落展开释义内容:json格式存储',
  `fdCreate` datetime NOT NULL COMMENT '创建日期',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='记录用户听力精听段落概括大意以及展开释义';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerMark`
--

CREATE TABLE `tbAnswerMark` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `fdExamItemID` int(11) UNSIGNED NOT NULL COMMENT '听力对应的tbExamItem.id',
  `fdValue` smallint(4) DEFAULT '0' COMMENT '标记:0-全文,非0代表具体的段落序号',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间',
  `fdData` mediumtext COMMENT '标记内容:包含html:存json数据',
  `fdStructure` text COMMENT '标记内容,附属信息',
  `fdStatus` smallint(4) NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户精听标记记录';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerMatch`
--

CREATE TABLE `tbAnswerMatch` (
  `id` int(11) NOT NULL,
  `fdAnswerExamID` int(11) NOT NULL,
  `fdAnswerQuestionID` int(11) DEFAULT '0' COMMENT '答题ID 对应到tbAnswerQuestion.id',
  `fdExerciseItemID` int(11) NOT NULL,
  `fdMatchItemID` int(11) NOT NULL COMMENT '对应tbMatchItem.id',
  `fdMatchingID` int(11) NOT NULL COMMENT '对应tbMatching.id',
  `fdOrder` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='回答试卷中的匹配题, 对应MatchItem';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerOptions`
--

CREATE TABLE `tbAnswerOptions` (
  `id` int(11) NOT NULL,
  `fdAnswerSubjective` int(11) NOT NULL COMMENT '对应到问答题subjectiveid',
  `fdOptionsID` int(11) NOT NULL COMMENT '采分点对应的ID',
  `fdScore` float NOT NULL COMMENT '命中该采分点得到的分数'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='保存试卷中题目的采分点的分情况';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerQuestion`
--

CREATE TABLE `tbAnswerQuestion` (
  `id` int(11) NOT NULL,
  `fdAnswerExamID` int(11) NOT NULL COMMENT '对应答卷ID，对应到tbAnswerExam.id',
  `fdAnswerExamItemID` int(11) NOT NULL COMMENT 'fdAnswerExamItemID ',
  `fdExerciseID` int(11) NOT NULL COMMENT '题目ID，对应到tbExercise.id',
  `fdScore` float DEFAULT '0' COMMENT '当前题目得分，如果题目有多道小题，应为多道小题题目得分之和',
  `fdSelf` float DEFAULT NULL COMMENT '学生自评分',
  `fdTscore` double DEFAULT NULL COMMENT '教师评分',
  `fdCreate` datetime NOT NULL,
  `fdUpdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fdStatus` tinyint(4) DEFAULT '0' COMMENT '作答状态 0：有做答，1：用户没作答',
  `fdRight` tinyint(4) DEFAULT '0' COMMENT '题目是否正确，0表示错误，1表示正确',
  `fdCount` int(11) DEFAULT '0',
  `fdUsed` int(11) NOT NULL COMMENT '答题时间, 以秒为单位',
  `fdMark` tinyint(4) DEFAULT NULL COMMENT '答题标记'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回答试题';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerQuestionGroup`
--

CREATE TABLE `tbAnswerQuestionGroup` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdAnswerExamID` int(11) UNSIGNED NOT NULL COMMENT '答卷记录ID',
  `fdExamItemD` int(11) UNSIGNED NOT NULL COMMENT '题目所在专题examItem.id',
  `fdExerciseID` text NOT NULL COMMENT '具体那句标记内容',
  `fdOrder` smallint(4) DEFAULT NULL COMMENT '分组序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力词汇答题分组';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerReport`
--

CREATE TABLE `tbAnswerReport` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) UNSIGNED DEFAULT NULL COMMENT '用户id',
  `fdDate` date DEFAULT NULL COMMENT '日期',
  `fdEntityType` int(11) UNSIGNED DEFAULT NULL COMMENT '类型：阅读，听力...',
  `fdExerciseType` int(11) UNSIGNED DEFAULT NULL COMMENT '题目类型',
  `fdCount` int(11) UNSIGNED DEFAULT '0' COMMENT '答题数量',
  `fdUsed` int(11) UNSIGNED DEFAULT '0' COMMENT '答题时长(秒)',
  `fdRight` int(11) UNSIGNED DEFAULT '0' COMMENT '正确率(%)',
  `fdRightCount` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '正确题数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户答题情况';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerSeries`
--

CREATE TABLE `tbAnswerSeries` (
  `id` int(11) NOT NULL,
  `fdExamItemID` int(11) DEFAULT '0' COMMENT '专题ID',
  `fdScore` double DEFAULT NULL COMMENT '本题最终得分',
  `fdOrder` int(11) DEFAULT NULL,
  `fdStatus` int(11) NOT NULL DEFAULT '0' COMMENT '状态. 0:未选, 1:已选'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回答试卷中的题目';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerSubjective`
--

CREATE TABLE `tbAnswerSubjective` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) DEFAULT NULL COMMENT '答题关联的Entity属性',
  `fdAnswerExerciseID` int(11) NOT NULL COMMENT 'tbAnswerExercise.id',
  `fdSubjectiveID` int(11) NOT NULL COMMENT 'tbSubjective.id',
  `fdText` text,
  `fdSelf` double DEFAULT NULL COMMENT '自评得分',
  `fdTscore` double DEFAULT NULL COMMENT '教师评分',
  `fdScore` double DEFAULT NULL COMMENT '分数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保存试卷中题目的主观题。';

-- --------------------------------------------------------

--
-- Table structure for table `tbAnswerTotalReport`
--

CREATE TABLE `tbAnswerTotalReport` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) UNSIGNED DEFAULT NULL COMMENT '用户id',
  `fdCount` int(11) UNSIGNED DEFAULT '0' COMMENT '答题数量',
  `fdUsed` int(11) UNSIGNED DEFAULT '0' COMMENT '答题时长(秒)',
  `fdRight` int(11) UNSIGNED DEFAULT '0' COMMENT '正确率(%)',
  `fdRightCount` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '正确题数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户答题情况' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `tbAppraise`
--

CREATE TABLE `tbAppraise` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL COMMENT '评价的对象',
  `fdUserID` int(11) NOT NULL,
  `fdType` tinyint(4) NOT NULL,
  `fdValue` tinyint(4) NOT NULL COMMENT '评价内容. 1-赞; 2-踩;',
  `fdCreate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbArea`
--

CREATE TABLE `tbArea` (
  `id` int(11) NOT NULL,
  `fdParentID` int(11) DEFAULT NULL COMMENT '父节点ID',
  `fdName` varchar(255) NOT NULL COMMENT '地区名称',
  `fdCode` int(11) DEFAULT NULL COMMENT '地区代码',
  `fdAcronym` varchar(64) DEFAULT NULL COMMENT '地区首字母',
  `fdPinyin` varchar(255) DEFAULT NULL COMMENT '地区全拼',
  `fdLeft` int(11) NOT NULL,
  `fdRight` int(11) NOT NULL,
  `fdLevel` int(11) NOT NULL COMMENT '地区所在节点层级',
  `fdOrder` int(11) NOT NULL DEFAULT '50' COMMENT '排序字段，默认为50'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='地区属性表';

-- --------------------------------------------------------

--
-- Table structure for table `tbAttributes`
--

CREATE TABLE `tbAttributes` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL,
  `fdValue` varchar(258) NOT NULL COMMENT '属性值',
  `fdType` tinyint(4) NOT NULL COMMENT '属性的类型'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='实体属性表';

-- --------------------------------------------------------

--
-- Table structure for table `tbBlob`
--

CREATE TABLE `tbBlob` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) DEFAULT NULL,
  `fdFileID` int(11) DEFAULT NULL,
  `fdValue` blob,
  `fdType` int(11) NOT NULL COMMENT '类型'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbCache`
--

CREATE TABLE `tbCache` (
  `id` char(128) NOT NULL,
  `expire` int(11) DEFAULT NULL COMMENT '过期时间：没有则不填',
  `data` blob COMMENT '缓存表：文件缓存的替代表'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbCarousel`
--

CREATE TABLE `tbCarousel` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdKey` varchar(50) DEFAULT NULL COMMENT '标识',
  `fdName` varchar(100) NOT NULL DEFAULT '' COMMENT '位置',
  `fdStatus` tinyint(1) UNSIGNED DEFAULT '1' COMMENT '状态：1正常；0禁用',
  `fdCloButton` tinyint(1) UNSIGNED DEFAULT '1' COMMENT '关闭按钮:1启用;0禁用',
  `fdPageRoute` varchar(100) DEFAULT NULL COMMENT '页面路由'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='幻灯片位置';

-- --------------------------------------------------------

--
-- Table structure for table `tbCarouselItem`
--

CREATE TABLE `tbCarouselItem` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdCarouselID` int(11) UNSIGNED DEFAULT NULL COMMENT '位置id',
  `fdUrl` varchar(255) DEFAULT NULL COMMENT '链接',
  `fdCaption` varchar(100) DEFAULT NULL COMMENT '标题',
  `fdStatus` tinyint(1) UNSIGNED DEFAULT '1' COMMENT '状态:1启用;0禁用',
  `fdOrder` tinyint(3) UNSIGNED DEFAULT '0' COMMENT '排序',
  `fdCreate` datetime DEFAULT NULL COMMENT '创建时间',
  `fdStart` datetime DEFAULT NULL COMMENT '开始时间',
  `fdEnd` datetime DEFAULT NULL COMMENT '结束时间',
  `fdImage` varchar(255) DEFAULT NULL COMMENT '图片路径',
  `fdDescription` varchar(255) DEFAULT NULL COMMENT '描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='幻灯片';

-- --------------------------------------------------------

--
-- Table structure for table `tbChannel`
--

CREATE TABLE `tbChannel` (
  `id` int(11) NOT NULL,
  `fdName` varchar(50) NOT NULL COMMENT '渠道名称',
  `fdCreate` datetime NOT NULL COMMENT '渠道的创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='渠道码';

-- --------------------------------------------------------

--
-- Table structure for table `tbChannelClass`
--

CREATE TABLE `tbChannelClass` (
  `id` int(11) NOT NULL,
  `fdChannelID` int(11) NOT NULL COMMENT '渠道ID',
  `fdType` int(11) NOT NULL COMMENT '课程类型',
  `fdClassID` int(11) NOT NULL COMMENT '班级ID',
  `fdNums` int(11) NOT NULL COMMENT '邀请码数量',
  `fdStartTime` datetime NOT NULL COMMENT '启用时间',
  `fdEndTime` datetime NOT NULL COMMENT '终止时间',
  `fdCreate` datetime NOT NULL COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='渠道班级';

-- --------------------------------------------------------

--
-- Table structure for table `tbChannelCode`
--

CREATE TABLE `tbChannelCode` (
  `id` int(11) NOT NULL,
  `fdChannelClassID` int(11) NOT NULL COMMENT '渠道-班级关系表id',
  `fdCode` char(9) NOT NULL COMMENT '邀请码',
  `fdStatus` int(11) NOT NULL DEFAULT '0' COMMENT '使用状态（0：未使用，1：已使用）',
  `fdCreate` datetime NOT NULL COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='邀请码';

-- --------------------------------------------------------

--
-- Table structure for table `tbChannelUser`
--

CREATE TABLE `tbChannelUser` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID',
  `fdChannelClassID` int(11) NOT NULL COMMENT 'channelclass表ID',
  `fdType` int(11) NOT NULL COMMENT '注册途径，0：渠道网址，1：渠道二维码，2：邀请码',
  `fdChannelCodeID` int(11) DEFAULT NULL COMMENT '渠道码ID（fdType为0时才有）',
  `fdScenario` int(11) DEFAULT '0' COMMENT '使用场景(0:注册，1：注册后绑定)',
  `fdCreate` datetime NOT NULL COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户渠道关系表';

-- --------------------------------------------------------

--
-- Table structure for table `tbClass`
--

CREATE TABLE `tbClass` (
  `id` int(11) NOT NULL,
  `fdName` varchar(50) DEFAULT NULL COMMENT '班级名称',
  `fdClassify` tinyint(4) NOT NULL DEFAULT '1' COMMENT '班级分类，  0-小组类型，不作区分 1-资源班级  2-教务班级',
  `fdValidityPeriod` smallint(4) NOT NULL DEFAULT '0' COMMENT '班级有效期;180-半年,365- 一年,545- 一年半,730- 两年,910- 两年半,1095- 三年',
  `fdType` tinyint(4) DEFAULT NULL COMMENT '类型，\r\n            1-班级\r\n            2-小组\r\n',
  `fdYear` year(4) DEFAULT NULL COMMENT '对应年份',
  `fdParentID` int(11) DEFAULT '0',
  `fdMaster` int(11) DEFAULT NULL COMMENT '班主任，对应tbUser.id',
  `fdText` text COMMENT '班级语录',
  `fdDescription` varchar(255) DEFAULT NULL COMMENT '班级简介',
  `fdPortrait` int(11) DEFAULT NULL COMMENT '班级头像，对应tbFile.id\r\n            ',
  `fdEntityID` int(11) DEFAULT NULL COMMENT '内容信息，对应tbEntity.id，用于关联直接与班级有关系的文件 ，如班级属性',
  `fdCreate` datetime DEFAULT NULL,
  `fdStatus` tinyint(4) DEFAULT '0' COMMENT '0:正常,1:关闭',
  `fdStart` datetime DEFAULT NULL COMMENT '开班时间',
  `fdEnd` datetime DEFAULT NULL COMMENT '班级结课时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='班级表';

-- --------------------------------------------------------

--
-- Table structure for table `tbClassMap`
--

CREATE TABLE `tbClassMap` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID，对应tbUser.id，用户包括学生、教师',
  `fdClassID` int(11) NOT NULL DEFAULT '0' COMMENT '班级ID，对应tbClass.id',
  `fdStatus` tinyint(4) NOT NULL COMMENT '状态，             0-默认             1-已加入             2-申请加入，待审核             3-被邀请加入，待审核             4-申请加入被拒绝             5-拒绝加入，6-已退出''',
  `fdCreate` datetime NOT NULL,
  `fdApprove` datetime DEFAULT NULL COMMENT '确认时间',
  `fdTeacher` tinyint(4) DEFAULT '0' COMMENT '是否为班主任 0：不是 1：是',
  `fdOperator` int(11) NOT NULL DEFAULT '0' COMMENT '操作人',
  `fdMark` varchar(100) DEFAULT NULL COMMENT '审核意见'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='学生/教师与班级的关系表';

-- --------------------------------------------------------

--
-- Table structure for table `tbClassResource`
--

CREATE TABLE `tbClassResource` (
  `id` int(11) NOT NULL,
  `fdClassID` int(11) NOT NULL COMMENT '班级ID，对应tbClass.id',
  `fdResourceGroupID` int(11) NOT NULL COMMENT '资源ID，对应tbResourceGroup.id',
  `fdDescription` varchar(255) DEFAULT NULL COMMENT '分组描述',
  `fdCreate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='班级资源的关系表';

-- --------------------------------------------------------

--
-- Table structure for table `tbCoinRecord`
--

CREATE TABLE `tbCoinRecord` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdInfo` varchar(255) NOT NULL COMMENT '获得金币描述：今日签到或者验证邮箱等',
  `fdNumber` int(11) DEFAULT '0' COMMENT '本次记录金币数量：包含消耗以及得到的记录，消耗为负值',
  `fdStatus` smallint(4) DEFAULT '0' COMMENT '发放状态：0-未完成，1-完成',
  `fdCreate` datetime NOT NULL COMMENT '当前日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户金币记录表';

-- --------------------------------------------------------

--
-- Table structure for table `tbComment`
--

CREATE TABLE `tbComment` (
  `id` int(11) NOT NULL,
  `fdParentID` int(11) NOT NULL COMMENT '上级评论标识，支持评论别人的评论',
  `fdUserID` int(11) NOT NULL COMMENT '用户标识，对应需要注册的情况',
  `fdReplyUserID` int(11) NOT NULL DEFAULT '0' COMMENT '被回复的用户ID',
  `fdTerminalID` int(11) NOT NULL COMMENT '对应tbTerminal.id，适合不需要注册的情况',
  `fdEntityID` int(11) DEFAULT NULL COMMENT 'entity.id',
  `fdFileID` int(11) DEFAULT NULL COMMENT '文件ID,对应content.tbFile.id\r\n            对直播内容进行反馈评价的时候，可以仍不存在tbFile记录，需要在人工切片之后再根据fdTimeStop进行fdFileID计算。',
  `fdTimestop` int(11) DEFAULT NULL COMMENT '观看到哪一秒的时候作出的反馈？如果是直播，指系统时间。',
  `fdTitle` varchar(128) DEFAULT NULL COMMENT '评论的标题',
  `fdText` text COMMENT '评论文字',
  `fdCreate` datetime DEFAULT NULL COMMENT '评论创建日期。如果一条评论被更新，这个日期反应更新日期',
  `fdApproverID` int(11) DEFAULT NULL COMMENT '审核者ID，对应tbOperator.id\r\n            如果为-1,表示改评论已被自动审核\r\n            如果为0,表示改评论尚未被审核',
  `fdApprove` datetime DEFAULT NULL COMMENT '审核时间',
  `fdType` int(11) NOT NULL COMMENT '0-普通评论\r\n            1-印象\r\n            2-支持\r\n            3-反对\r\n            4-晒单',
  `fdOrder` int(11) DEFAULT NULL COMMENT '排序依据，升序。',
  `fdStatus` int(11) DEFAULT NULL COMMENT '默认状态：正常-0；删除或者屏蔽为-1；置顶 - 2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户对实体的评论';

-- --------------------------------------------------------

--
-- Table structure for table `tbCommentMap`
--

CREATE TABLE `tbCommentMap` (
  `fdType` smallint(4) NOT NULL COMMENT '类型:支持 - 0，反对 - 1',
  `fdUserID` int(11) NOT NULL COMMENT '当前用户ID，user.id',
  `fdCommentID` int(11) NOT NULL COMMENT '评论ID，comment.id',
  `fdCreate` datetime NOT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对评论操作的记录，如果取消操作则删除记录';

-- --------------------------------------------------------

--
-- Table structure for table `tbCourse`
--

CREATE TABLE `tbCourse` (
  `id` int(11) NOT NULL COMMENT '课程id',
  `fdName` char(64) NOT NULL COMMENT '课程名称',
  `fdUserID` int(11) NOT NULL COMMENT '课程创建人id',
  `fdTeacher` int(11) NOT NULL COMMENT '默认讲师,对应user.id; ',
  `fdMembers` int(11) NOT NULL DEFAULT '0' COMMENT '修课人数',
  `fdViews` int(11) NOT NULL DEFAULT '0' COMMENT '点击量',
  `fdFee` decimal(7,2) NOT NULL DEFAULT '0.00' COMMENT '费用',
  `fdEntityID` int(11) DEFAULT NULL,
  `fdTagID` int(11) NOT NULL DEFAULT '0' COMMENT '课程默认分类',
  `fdFace` char(255) NOT NULL DEFAULT '' COMMENT '课程缩略图存放位置',
  `fdIntro` text NOT NULL COMMENT '课程简介',
  `fdCreate` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `fdStatus` int(11) NOT NULL DEFAULT '0' COMMENT '状态.   4:未审核',
  `fdRateScore` decimal(3,1) NOT NULL DEFAULT '0.0' COMMENT '平均得分',
  `fdRateNum` int(11) NOT NULL DEFAULT '0' COMMENT '评分人次',
  `fdStudents` varchar(1024) NOT NULL DEFAULT '' COMMENT '目标学员',
  `fdSubTitle` char(255) NOT NULL DEFAULT '' COMMENT '副标题',
  `fdTop` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否推荐',
  `fdValid` timestamp NULL DEFAULT NULL COMMENT '有效期,默认到期时间',
  `fdEmail` varchar(64) DEFAULT NULL COMMENT '课程联系邮箱',
  `fdPhone` varchar(25) DEFAULT NULL COMMENT '课程联系电话',
  `fdClose` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `fdResult` varchar(256) DEFAULT NULL COMMENT '拒绝理由',
  `fdChecked` int(11) DEFAULT '0' COMMENT '是否已审核. 0:未审核. 1:已审核; 2:审核不通过'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='课程表';

-- --------------------------------------------------------

--
-- Table structure for table `tbEmail`
--

CREATE TABLE `tbEmail` (
  `fdUserID` int(11) DEFAULT NULL COMMENT '对应tbUser.id',
  `fdEmail` varchar(64) DEFAULT NULL COMMENT '电子邮件地址',
  `fdCode` varchar(8) DEFAULT NULL COMMENT '验证码，邮件验证需要md5加密生成一个链接',
  `fdSent` datetime DEFAULT NULL COMMENT 'fdCode生成的时间',
  `fdVerified` datetime DEFAULT NULL COMMENT '验证时间，0表示未验证',
  `fdDefault` tinyint(4) NOT NULL COMMENT '缺省的电子邮箱地址\r\n            0-普通\r\n            1-缺省'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='电子邮件地址表，一个人可以拥有多个电子邮件地址';

-- --------------------------------------------------------

--
-- Table structure for table `tbEntity`
--

CREATE TABLE `tbEntity` (
  `id` int(11) NOT NULL COMMENT 'id',
  `fdType` int(11) NOT NULL COMMENT '实体类型'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='实体';

-- --------------------------------------------------------

--
-- Table structure for table `tbExam`
--

CREATE TABLE `tbExam` (
  `id` int(11) NOT NULL,
  `fdName` varchar(255) NOT NULL COMMENT '试卷名称',
  `fdEntityID` int(11) NOT NULL COMMENT '实体标识，对应entity.id',
  `fdExamTypeID` int(11) NOT NULL COMMENT '试卷类型，对应tbExamType.id',
  `fdTotal` int(11) NOT NULL COMMENT '试卷总分',
  `fdGrade` int(11) NOT NULL COMMENT '及格分数线',
  `fdSpend` int(11) DEFAULT NULL COMMENT '试卷最大多少分钟完成',
  `fdCreate` datetime NOT NULL COMMENT '记录创建时间',
  `fdApproverID` int(11) NOT NULL COMMENT '审核人标识，对应tbOperator.id',
  `fdApprove` datetime DEFAULT NULL COMMENT '审核时间',
  `fdStatus` int(11) DEFAULT NULL COMMENT '审核状态，0-悬而未决，1-审核通过，2-审核不通过',
  `fdAlias` int(11) DEFAULT NULL COMMENT '题目题型、仅在题型练习试卷用于记录题型，其他为空'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='试卷';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamination`
--

CREATE TABLE `tbExamination` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL,
  `fdTime` datetime NOT NULL COMMENT '考试时间',
  `fdType` tinyint(4) NOT NULL COMMENT '考试类型, 1-托福',
  `fdTotal` int(11) NOT NULL COMMENT '总分',
  `fdReading` int(11) NOT NULL,
  `fdWriting` int(11) NOT NULL,
  `fdListening` int(11) NOT NULL,
  `fdSpeaking` int(11) NOT NULL COMMENT '口语',
  `fdCreate` datetime NOT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='真实考试的历史成绩';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamItem`
--

CREATE TABLE `tbExamItem` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) DEFAULT NULL,
  `fdExamID` int(11) DEFAULT NULL,
  `fdName` varchar(255) DEFAULT NULL COMMENT '大题名称',
  `fdTitle` varchar(255) DEFAULT NULL COMMENT '大题/专题的文章题目',
  `fdText` text COMMENT '大题说明文本',
  `fdTypeID` int(11) DEFAULT NULL COMMENT '大题题型，如选择题，填空题。对应ExerciseType.id. 听力题说明对应资源:tbFile.entityID==tbExamItem.entityID and entity.type=1)',
  `fdOrder` int(11) NOT NULL DEFAULT '0',
  `fdStatus` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='试卷大题项';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamItemMap`
--

CREATE TABLE `tbExamItemMap` (
  `fdExerciseID` int(11) NOT NULL,
  `fdExamItemID` int(11) NOT NULL,
  `fdScore` double NOT NULL,
  `fdOrder` int(11) DEFAULT '0' COMMENT '题目排序',
  `id` int(11) NOT NULL,
  `fdExamID` int(11) DEFAULT NULL COMMENT '对应所在试卷ID',
  `fdStatus` tinyint(4) DEFAULT '0' COMMENT '题目在试卷中的状态0表示正常可用，1表示被替换的题目'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='大题和试题的映射关系';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamPlan`
--

CREATE TABLE `tbExamPlan` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL,
  `fdType` tinyint(4) NOT NULL COMMENT '考试类型',
  `fdPlan` datetime NOT NULL COMMENT '计划的考试时间',
  `fdTotal` int(11) NOT NULL,
  `fdReading` int(11) NOT NULL,
  `fdWriting` int(11) NOT NULL,
  `fdListening` int(11) NOT NULL,
  `fdSpeaking` int(11) NOT NULL COMMENT '口语',
  `fdHold` tinyint(4) NOT NULL COMMENT '时间待定, 0-确定, 1-待定',
  `fdCreate` datetime NOT NULL COMMENT '记录创建时间',
  `fdArea` tinyint(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '考试区域:1-大陆；2-海外'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='考试计划及目标';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamSchedule`
--

CREATE TABLE `tbExamSchedule` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdClassID` int(11) NOT NULL COMMENT '班级ID：tbClassID.id',
  `fdDate` date NOT NULL COMMENT '考试日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='考试排期以及班级挂钩';

-- --------------------------------------------------------

--
-- Table structure for table `tbExamType`
--

CREATE TABLE `tbExamType` (
  `id` int(11) NOT NULL,
  `fdName` varchar(32) NOT NULL COMMENT '类型名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试卷类型，比如真题等';

-- --------------------------------------------------------

--
-- Table structure for table `tbExercise`
--

CREATE TABLE `tbExercise` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL COMMENT '实体标识，对应entity.id; 题目对应的图片:file.entityID=tbExercise.fdEntityID and entity.type=EXERCISE_PICTURE; 题目对应的语音:file.entityID=exercise.entityID and entity.type=EXERCISE_SOUND; ',
  `fdExerciseTypeID` int(11) NOT NULL COMMENT '题目类型，对应tbExerciseType.id',
  `fdScore` double DEFAULT NULL,
  `fdText` text COMMENT '题干',
  `fdAnswer` text COMMENT '题目解析',
  `fdCreate` datetime NOT NULL COMMENT '记录创建时间',
  `fdApproverID` int(11) NOT NULL COMMENT '审核人标识，对应tbOperator.id',
  `fdApprove` datetime DEFAULT NULL COMMENT '审核时间',
  `fdStatus` int(11) DEFAULT NULL COMMENT '审核状态，0-悬而未决，1-审核通过，2-审核不通过',
  `fdAlias` mediumint(9) DEFAULT NULL,
  `fdDraft` mediumint(9) NOT NULL DEFAULT '0',
  `fdAttributes` text COMMENT '题目基本文本属性json数据保存'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='练习题';

-- --------------------------------------------------------

--
-- Table structure for table `tbExerciseItem`
--

CREATE TABLE `tbExerciseItem` (
  `id` int(11) NOT NULL,
  `fdExerciseID` int(11) NOT NULL COMMENT '练习题标识，对应tbExercise.id',
  `fdScore` double DEFAULT NULL COMMENT '小题分数',
  `fdType` tinyint(4) DEFAULT '0' COMMENT '综合题中定义小题类型,1:单选,2:双选,3:三选, 10:拖曳,11:插入',
  `fdQuestion` text COMMENT '小题题干',
  `fdEntityID` int(11) NOT NULL COMMENT '实体标识，对应entity.id; 题目对应的语音:file.entityID=exercise.entityID and entity.type=EXERCISE_ITEM_SOUND; 题目对应的图片:file.entityID=exerciseItem.entityID and entity.type=EXERCISE_ITEM_PICTURE; ',
  `fdAnalysis` text COMMENT '小题解析',
  `fdAnalysisVideo` varchar(64) DEFAULT '' COMMENT '小题解析:视频文件，保利威视视频ID',
  `fdAnalysisVideoName` varchar(128) DEFAULT '' COMMENT '小题解析:视频文件,文件名',
  `fdIdea` text COMMENT '答题思路',
  `fdOrder` tinyint(4) DEFAULT NULL COMMENT '小题排序',
  `fdAttributes` text COMMENT '附加属性,保存已序列化的对象. 如文本滚动至指定区域:{scroll:{start,end}},滚动至段落:{paragraph:{1,2,3...需要标识的段落}}; 题目(如听力)准备/回答时间:{time:{prepare:30,answer:30}}',
  `fdAnswer` text COMMENT '参考答案:客观题{o:{0,1,2}},并由此计算正确选项个数;客观题包含拖曳题和插入题; 主观题{s:{text for answer here}},听力(类似判断题){o:{0,0,1}}'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='题目的问题项';

-- --------------------------------------------------------

--
-- Table structure for table `tbExerciseType`
--

CREATE TABLE `tbExerciseType` (
  `id` int(11) NOT NULL,
  `fdName` varchar(32) NOT NULL COMMENT '类型名称',
  `fdTypeID` int(11) NOT NULL COMMENT '习题的类型：1：选择，2：问答，0：都有'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='习题类型，比如选择题，填空题等';

-- --------------------------------------------------------

--
-- Table structure for table `tbFavorite`
--

CREATE TABLE `tbFavorite` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户标识，对应tbUser.id',
  `fdType` tinyint(4) NOT NULL COMMENT '收藏的type 1：题目 2：真题, ... ',
  `fdValue` int(11) NOT NULL COMMENT '收藏对应属性的值',
  `fdEntityType` tinyint(4) NOT NULL DEFAULT '0' COMMENT '实体类型：tbEntity.fdType',
  `fdTagID` int(11) NOT NULL DEFAULT '0' COMMENT '数据来源：数据节点ID，tbTag.id;数据来源',
  `fdFileID` int(11) DEFAULT '0' COMMENT '听力文件File.id',
  `fdEntityID` int(11) DEFAULT '0' COMMENT '实体ID，对应的tbEntity.id',
  `fdCreate` datetime NOT NULL COMMENT '收藏时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收藏夹';

-- --------------------------------------------------------

--
-- Table structure for table `tbFeedback`
--

CREATE TABLE `tbFeedback` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID',
  `fdApplicationID` int(4) NOT NULL COMMENT '应用ID',
  `fdCate` int(4) NOT NULL COMMENT '反馈来源、分类：错误、以及反馈',
  `fdType` int(4) NOT NULL COMMENT '问题类型：反馈bug、建议等',
  `fdText` text NOT NULL COMMENT '意见内容',
  `fdValue` int(11) DEFAULT '0' COMMENT '如果是题目错误反馈，值的内容就是题目tbExercise.ID；其他为空默认0',
  `fdStatus` int(4) NOT NULL COMMENT '跟进情况：待处理、处理中、已经解决等',
  `fdUrl` varchar(100) DEFAULT NULL COMMENT '评论时所在的页面地址url',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime DEFAULT NULL COMMENT '处理时间',
  `fdHandlerID` int(11) UNSIGNED DEFAULT '0' COMMENT '后台操作人ID',
  `fdRemark` varchar(255) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='整站用户错误、反馈意见';

-- --------------------------------------------------------

--
-- Table structure for table `tbFile`
--

CREATE TABLE `tbFile` (
  `id` int(11) NOT NULL COMMENT 'id',
  `fdEntityID` int(11) DEFAULT NULL,
  `fdName` varchar(255) DEFAULT NULL,
  `fdEnglish` varchar(255) DEFAULT NULL,
  `fdOrder` int(11) DEFAULT NULL COMMENT '文件在tbEntity内的排序，小的排在前面',
  `fdURL` varchar(255) DEFAULT NULL COMMENT '文件的下载网址，形如xx/xxx.xxx，等等.',
  `fdCache` varchar(255) DEFAULT NULL,
  `fdM3u8` varchar(255) DEFAULT NULL COMMENT '视频切片url',
  `fdRetry` int(11) DEFAULT '0' COMMENT '尝试上传的次数，100表示成功',
  `fdTransStatus` tinyint(4) DEFAULT '0' COMMENT '转码状态 0：悬而未决 1：转码成功 2：转码失败',
  `fdSize` bigint(20) DEFAULT NULL COMMENT '文件大小,字节数',
  `fdEncrypted` tinyint(4) DEFAULT NULL COMMENT '是否加密',
  `fdTypeID` int(11) DEFAULT NULL COMMENT '类型ID',
  `fdCatelog` int(11) NOT NULL COMMENT '文件分类.',
  `fdCreate` datetime DEFAULT NULL,
  `fdUpdated` timestamp NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '记录的最近一次更新时间',
  `fdInterval` int(11) DEFAULT NULL COMMENT '记录当前视频缩略图获取间隔',
  `fdMD5` varchar(32) DEFAULT NULL,
  `fdMime` int(11) DEFAULT '0' COMMENT '文件后缀名类型',
  `fdSeconds` int(11) DEFAULT '0' COMMENT '以秒为单位的时间长度，用于动态生成m3u8'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文件表';

-- --------------------------------------------------------

--
-- Table structure for table `tbGlossary`
--

CREATE TABLE `tbGlossary` (
  `id` int(11) NOT NULL COMMENT '逻辑ID',
  `fdWord` varchar(255) NOT NULL DEFAULT '' COMMENT '单词',
  `fdUserID` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID：tbUserID.id',
  `fdDelStatus` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除：0-正常,1-删除',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='生词本';

-- --------------------------------------------------------

--
-- Table structure for table `tbGlossaryOrigin`
--

CREATE TABLE `tbGlossaryOrigin` (
  `id` int(11) NOT NULL COMMENT '逻辑ID',
  `fdGloID` int(11) NOT NULL COMMENT '单词ID：tbGlossary.id',
  `fdType` smallint(4) NOT NULL COMMENT '类型(ex:10-阅读)',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='生词本来源';

-- --------------------------------------------------------

--
-- Table structure for table `tbGrowthRank`
--

CREATE TABLE `tbGrowthRank` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdName` varchar(255) NOT NULL COMMENT '等级名称：LV 1、LV 2',
  `fdStartValue` int(11) DEFAULT '0' COMMENT '等级开始量',
  `fdEndValue` int(11) DEFAULT '0' COMMENT '等级结束量',
  `fdPrivilege` varchar(255) DEFAULT NULL COMMENT '等级对应的特权：id用逗号分隔'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='成长值等级';

-- --------------------------------------------------------

--
-- Table structure for table `tbListenGist`
--

CREATE TABLE `tbListenGist` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdFileID` int(11) UNSIGNED NOT NULL COMMENT '精听文件ID：音频ID',
  `fdSection` smallint(4) NOT NULL COMMENT '当前段落序号',
  `fdText` text COMMENT '段落概括内容',
  `fdAnalyse` text COMMENT '段落展开释义内容:json格式存储'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力精听段落概括大意以及展开释义';

-- --------------------------------------------------------

--
-- Table structure for table `tbListening`
--

CREATE TABLE `tbListening` (
  `id` int(11) NOT NULL,
  `fdFileID` int(11) NOT NULL COMMENT '对应的音频内容附件ID，tbFile.id',
  `fdText` text NOT NULL COMMENT '英文文本',
  `fdChinese` text NOT NULL COMMENT '中文翻译',
  `fdStart` int(11) NOT NULL COMMENT '句子开始时间：内容为秒*100，such:1.25 * 100的结果为125',
  `fdEnd` int(11) NOT NULL COMMENT '句子结束时间',
  `fdSection` int(11) NOT NULL COMMENT '段落排序',
  `fdSentence` int(11) NOT NULL COMMENT '句子排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力材料表';

-- --------------------------------------------------------

--
-- Table structure for table `tbListenMark`
--

CREATE TABLE `tbListenMark` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdListeningID` int(11) UNSIGNED NOT NULL COMMENT '精听句子ID',
  `fdHtml` text COMMENT '当前正确答案的标记内容'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力精听标记正确答案内容';

-- --------------------------------------------------------

--
-- Table structure for table `tbLove`
--

CREATE TABLE `tbLove` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户标识，对应tbUser.id',
  `fdType` tinyint(4) NOT NULL COMMENT '收藏的type 1：段落 2：句子, ... ',
  `fdValue` int(11) NOT NULL COMMENT '收藏对应属性的值',
  `fdCreate` datetime NOT NULL COMMENT '收藏时间',
  `fdExerciseID` int(11) NOT NULL,
  `fdFileID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力收藏夹';

-- --------------------------------------------------------

--
-- Table structure for table `tbMatching`
--

CREATE TABLE `tbMatching` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL,
  `fdMatchItemID` int(11) DEFAULT NULL COMMENT '所属MacthItem, 用于判断对错; 若为空则该项不是正确答案',
  `fdExerciseItemID` int(11) NOT NULL COMMENT '关联的ExerciseItem, 用于查看题目对应的选项',
  `fdText` text,
  `fdRight` tinyint(4) DEFAULT NULL COMMENT '是否为正确答案'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='匹配题小题';

-- --------------------------------------------------------

--
-- Table structure for table `tbMatchItem`
--

CREATE TABLE `tbMatchItem` (
  `id` int(11) NOT NULL,
  `fdExerciseItemID` int(11) NOT NULL,
  `fdText` text,
  `fdAttributes` text COMMENT '附加属性,保存已序列化的对象. 如文本滚动至指定区域:{scroll:{start,end}},滚动至段落:{paragraph:{1,2,3...需要标识的段落}}; 题目(如听力)准备/回答时'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='匹配题';

-- --------------------------------------------------------

--
-- Table structure for table `tbMenu`
--

CREATE TABLE `tbMenu` (
  `id` bigint(20) NOT NULL,
  `fdRoot` int(11) DEFAULT NULL,
  `fdName` varchar(60) NOT NULL,
  `fdLeft` int(11) NOT NULL,
  `fdRight` int(11) NOT NULL,
  `fdLvl` smallint(5) NOT NULL,
  `fdUrl` varchar(100) DEFAULT NULL COMMENT '路由访问地址（包含模块名）称',
  `fdStatus` smallint(5) DEFAULT '0',
  `fdOrder` int(11) NOT NULL DEFAULT '99',
  `icon` varchar(255) DEFAULT NULL,
  `icon_type` smallint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `selected` tinyint(1) NOT NULL DEFAULT '0',
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `readonly` tinyint(1) NOT NULL DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `collapsed` tinyint(1) NOT NULL DEFAULT '0',
  `movable_u` tinyint(1) NOT NULL DEFAULT '1',
  `movable_d` tinyint(1) NOT NULL DEFAULT '1',
  `movable_l` tinyint(1) NOT NULL DEFAULT '1',
  `movable_r` tinyint(1) NOT NULL DEFAULT '1',
  `removable` tinyint(1) NOT NULL DEFAULT '1',
  `removable_all` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tbmessage`
--

CREATE TABLE `tbmessage` (
  `id` int(11) NOT NULL,
  `fdFromUserID` int(11) NOT NULL COMMENT '发送者',
  `fdToUserID` int(11) NOT NULL COMMENT '接收者',
  `fdDataID` int(11) NOT NULL COMMENT '消息内容ID',
  `fdRead` smallint(1) NOT NULL DEFAULT '0' COMMENT '是否已读,1-已读;0-未读'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='消息发送-接收对象表';

-- --------------------------------------------------------

--
-- Table structure for table `tbMessageCategory`
--

CREATE TABLE `tbMessageCategory` (
  `id` int(11) NOT NULL,
  `fdName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '消息分类名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='消息分类表';

-- --------------------------------------------------------

--
-- Table structure for table `tbMessageData`
--

CREATE TABLE `tbMessageData` (
  `id` int(11) NOT NULL,
  `fdContent` text COLLATE utf8_unicode_ci COMMENT '消息内容',
  `fdGroup` text CHARACTER SET utf8 COMMENT '用户id集合，appID:[班级id]',
  `fdCreatedTime` int(10) NOT NULL COMMENT '创建时间',
  `fdCategoryID` int(11) UNSIGNED DEFAULT NULL COMMENT '类型ID',
  `fdLink` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '外链地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='消息内容表';

-- --------------------------------------------------------

--
-- Table structure for table `tbNotepad`
--

CREATE TABLE `tbNotepad` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdContent` varchar(255) NOT NULL COMMENT '记事本文本',
  `fdOrder` smallint(4) DEFAULT '0' COMMENT '排序',
  `fdCreate` datetime NOT NULL COMMENT '创建日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='记事本、备忘录';

-- --------------------------------------------------------

--
-- Table structure for table `tbNotify`
--

CREATE TABLE `tbNotify` (
  `id` int(11) NOT NULL,
  `fdFromUserID` int(11) NOT NULL COMMENT '发送者',
  `fdToUserID` int(11) NOT NULL COMMENT '接收者',
  `fdCategoryID` int(11) DEFAULT NULL COMMENT '通知分类ID',
  `fdExtra` text COLLATE utf8_unicode_ci COMMENT '附加信息',
  `fdCreatedTime` int(10) NOT NULL COMMENT '创建时间',
  `fdRead` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读,1-已读;0-未读',
  `fdLink` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '外链地址',
  `fdApplicationID` tinyint(3) UNSIGNED DEFAULT '0' COMMENT '应用id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='通知明细：如评论、反馈后系统产生的通知';

-- --------------------------------------------------------

--
-- Table structure for table `tbNotifyCategory`
--

CREATE TABLE `tbNotifyCategory` (
  `id` int(11) NOT NULL,
  `fdName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '类型名称',
  `fdTitle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '通知标题模板',
  `fdContent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '通知内容模板',
  `fdSign` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '类型标识',
  `fdDisplay` tinyint(1) UNSIGNED DEFAULT '1' COMMENT '是否显示,1-显示;0-隐藏',
  `fdSystem` tinyint(1) UNSIGNED DEFAULT '0' COMMENT '是否系统分类,1-是;0-否'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='通知分类表';

-- --------------------------------------------------------

--
-- Table structure for table `tbObject`
--

CREATE TABLE `tbObject` (
  `id` int(11) NOT NULL,
  `fdExerciseItemID` int(11) NOT NULL,
  `fdText` text,
  `fdTranslation` text COMMENT '译文',
  `fdRight` tinyint(4) NOT NULL COMMENT '正确选项标志, 0-错误选项, 1-正确选项'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='客观题候选答案';

-- --------------------------------------------------------

--
-- Table structure for table `tbPhone`
--

CREATE TABLE `tbPhone` (
  `fdUserID` int(11) NOT NULL,
  `fdPhone` varchar(32) NOT NULL,
  `fdCode` varchar(8) DEFAULT NULL COMMENT '验证码，通过短信下发',
  `fdSent` datetime DEFAULT NULL COMMENT 'fdCode生成并发放的时间',
  `fdVerified` datetime DEFAULT NULL COMMENT '短信验证时间，0表示未验证',
  `fdDefault` tinyint(4) NOT NULL COMMENT '缺省电话号码\r\n            0-普通\r\n            1-缺省'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='电话号码表，一个用户可以拥有多个电话号码';

-- --------------------------------------------------------

--
-- Table structure for table `tbPlan`
--

CREATE TABLE `tbPlan` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID：tbUserID.id',
  `fdMode` smallint(4) DEFAULT '0' COMMENT '计划方式：0-系统计划，1-自定义计划',
  `fdType` int(11) NOT NULL COMMENT '计划类型：0-完成练习，1-做题时长，2-单套正确率',
  `fdExamType` int(11) NOT NULL COMMENT '计划题型：10-模考，11-阅读，12-听力，13-口语， 14-写作，103-词汇',
  `fdTmp` tinyint(4) DEFAULT '0' COMMENT '模考冗余：12-听;13-说；11-读; 14-写',
  `fdNum` smallint(4) NOT NULL COMMENT '数量：如：阅读2篇',
  `fdStatus` smallint(4) DEFAULT '0' COMMENT '启用状态：0-启用，1-禁用',
  `fdCreate` datetime DEFAULT NULL COMMENT '创建日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='系统计划管理：具体的计划列表';

-- --------------------------------------------------------

--
-- Table structure for table `tbPush`
--

CREATE TABLE `tbPush` (
  `id` int(11) NOT NULL,
  `fdTerminalID` int(11) NOT NULL COMMENT '终端标识，对应tbTerminal.id',
  `fdSenter` int(11) NOT NULL COMMENT '用户标识，对应tbUser.id',
  `fdSenterType` int(4) NOT NULL COMMENT '用户身份',
  `fdTemplateID` int(11) DEFAULT NULL COMMENT '模板标识，对应tbTemplate.id',
  `fdText` text COMMENT '推送的消息文本，content是这个消息的附件',
  `fdRead` datetime DEFAULT NULL COMMENT '读取时间，如果为NULL或0，标识未读',
  `fdDate` datetime DEFAULT NULL COMMENT '消息被发送出去的时间',
  `fdType` int(11) NOT NULL COMMENT '0-普通消息, 1-系统消息, 2-积分消息, 3-支付消息',
  `fdReceiver` int(11) NOT NULL,
  `fdReceiveType` int(4) NOT NULL COMMENT '用户身份',
  `fdTarget` int(11) NOT NULL COMMENT '消息对象的ID,对应entity.id',
  `fdStatus` int(11) NOT NULL DEFAULT '0' COMMENT '0-未读,1-已读,2-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息推送表. 该表只用于系统消息推送, 不作为具体内容表. 评论相关使用tbComment';

-- --------------------------------------------------------

--
-- Table structure for table `tbReadGist`
--

CREATE TABLE `tbReadGist` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdFileID` int(11) UNSIGNED NOT NULL COMMENT '精听文件ID：音频ID',
  `fdSection` smallint(4) NOT NULL COMMENT '当前段落序号',
  `fdText` text COMMENT '段落概括内容',
  `fdAnalyse` text COMMENT '段落展开释义内容:json格式存储'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='听力精听段落概括大意以及展开释义';

-- --------------------------------------------------------

--
-- Table structure for table `tbReadMark`
--

CREATE TABLE `tbReadMark` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdReadingID` int(11) UNSIGNED NOT NULL COMMENT '精读句子ID',
  `fdHtml` text COMMENT '当前正确答案的标记内容',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='阅读精读标记正确答案内容';

-- --------------------------------------------------------

--
-- Table structure for table `tbReadStructure`
--

CREATE TABLE `tbReadStructure` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdExamItemID` int(11) DEFAULT NULL COMMENT 'tbExamItem.id',
  `fdContent` text COMMENT '标记内容,附属信息',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='阅读精读标记附属信息';

-- --------------------------------------------------------

--
-- Table structure for table `tbResourceGroup`
--

CREATE TABLE `tbResourceGroup` (
  `id` int(11) NOT NULL,
  `fdName` varchar(100) NOT NULL COMMENT '分组名称',
  `fdSubject` int(11) NOT NULL COMMENT '科目，tbTag.id',
  `fdType` int(11) NOT NULL COMMENT '资源分组类型，公共分组-1，私有分组-2',
  `fdCate` smallint(4) NOT NULL COMMENT '组分类：类TPO-1，专题-2',
  `fdCreate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='资源组表';

-- --------------------------------------------------------

--
-- Table structure for table `tbResourceMap`
--

CREATE TABLE `tbResourceMap` (
  `id` int(11) NOT NULL,
  `fdResourceGroupID` int(11) NOT NULL COMMENT '资源组ID，对应tbResourceGroup.id',
  `fdEntityID` int(11) NOT NULL COMMENT '资源内容examitem.entity.ID，对应tbEntity.id',
  `fdCheck` smallint(4) NOT NULL DEFAULT '0' COMMENT '查看解析状态：0-可以查看，1-不能看 解析'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='资源组表内容列表';

-- --------------------------------------------------------

--
-- Table structure for table `tbSchedule`
--

CREATE TABLE `tbSchedule` (
  `fdTime` datetime DEFAULT NULL COMMENT '预定播出时间，例如2011-05-31 12:00:00',
  `fdChannelID` int(11) DEFAULT NULL COMMENT '频道ID，对应的是"直播频道“栏目下的内容(tbContent.id)',
  `fdName` varchar(64) DEFAULT NULL COMMENT '抓取回来的节目名称。当新节目推出，还没有在tbColumn中创建相应记录时，这个字段会起作用。',
  `fdColumnID` int(11) DEFAULT NULL COMMENT '对应”按频道分“栏目下的子栏目ID，这将用于直播时判断当前正在播放的节目属于哪一档，以便调出”同档节目“',
  `fdContentID` int(11) NOT NULL COMMENT '根据tbSchedule自动生成的tbContent点播记录ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbSession`
--

CREATE TABLE `tbSession` (
  `fdTerminalID` int(11) NOT NULL COMMENT '对应tbTerminal.id',
  `fdUserID` int(11) NOT NULL COMMENT '用户标识,关联至tbUser.id',
  `fdOperatorID` int(11) NOT NULL COMMENT '操作员标识，对应tbOperator.id',
  `fdApplicationID` int(11) DEFAULT NULL COMMENT '对应tbApplication.id',
  `fdSession` varchar(64) DEFAULT NULL COMMENT '会话ID，标记唯一会话',
  `fdActive` datetime DEFAULT NULL COMMENT '最近一次活跃时间',
  `fdCreate` datetime DEFAULT NULL COMMENT '第一次使用本应用的时间',
  `fdStatus` int(11) NOT NULL COMMENT '状态,\r\n            0-未登录\r\n            1-已登录',
  `fdIP` varchar(15) DEFAULT NULL COMMENT 'IP地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会话表，一个terminal可能同时运行N个app，他们应拥有不同的session';

-- --------------------------------------------------------

--
-- Table structure for table `tbSign`
--

CREATE TABLE `tbSign` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdLast` datetime NOT NULL COMMENT '最近一次打卡日期',
  `fdNumber` int(11) DEFAULT '0' COMMENT '连续签到次数',
  `fdCount` int(11) DEFAULT '0' COMMENT '历史签到总次数'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户签到打卡表';

-- --------------------------------------------------------

--
-- Table structure for table `tbSignRecord`
--

CREATE TABLE `tbSignRecord` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdCreate` datetime NOT NULL COMMENT '打卡日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户签到打卡记录表';

-- --------------------------------------------------------

--
-- Table structure for table `tbSubject`
--

CREATE TABLE `tbSubject` (
  `id` int(11) NOT NULL,
  `fdName` varchar(50) DEFAULT NULL COMMENT '学科名称',
  `fdParent` int(11) NOT NULL DEFAULT '0' COMMENT '上一级id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbSubjective`
--

CREATE TABLE `tbSubjective` (
  `id` int(11) NOT NULL,
  `fdExerciseItemID` int(11) NOT NULL,
  `fdText` text COMMENT '主观题参考答案',
  `fdScore` double DEFAULT NULL,
  `fdRate` int(11) DEFAULT '0' COMMENT '分数所占比例，目前用于填空题'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='主观题候选答案';

-- --------------------------------------------------------

--
-- Table structure for table `tbSystemLog`
--

CREATE TABLE `tbSystemLog` (
  `id` bigint(20) NOT NULL,
  `level` int(11) DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `log_time` double DEFAULT NULL,
  `prefix` text CHARACTER SET utf8,
  `message` text CHARACTER SET utf8
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbTag`
--

CREATE TABLE `tbTag` (
  `id` bigint(20) NOT NULL,
  `fdRoot` int(11) DEFAULT NULL,
  `fdName` varchar(60) NOT NULL,
  `fdContent` varchar(255) DEFAULT NULL COMMENT '标签注释内容',
  `fdLeft` int(11) NOT NULL,
  `fdRight` int(11) NOT NULL,
  `fdLevel` smallint(5) NOT NULL DEFAULT '0',
  `fdLvl` smallint(5) NOT NULL,
  `fdType` smallint(5) NOT NULL DEFAULT '0',
  `fdStatus` smallint(5) DEFAULT '0',
  `fdOrder` int(11) NOT NULL DEFAULT '99',
  `icon` varchar(255) DEFAULT NULL,
  `icon_type` smallint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `selected` tinyint(1) NOT NULL DEFAULT '0',
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `readonly` tinyint(1) NOT NULL DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `collapsed` tinyint(1) NOT NULL DEFAULT '0',
  `movable_u` tinyint(1) NOT NULL DEFAULT '1',
  `movable_d` tinyint(1) NOT NULL DEFAULT '1',
  `movable_l` tinyint(1) NOT NULL DEFAULT '1',
  `movable_r` tinyint(1) NOT NULL DEFAULT '1',
  `removable` tinyint(1) NOT NULL DEFAULT '1',
  `removable_all` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbTagEntity`
--

CREATE TABLE `tbTagEntity` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) NOT NULL COMMENT '对应的tbEntity.id',
  `fdTagID` int(11) NOT NULL COMMENT '对应的tbTag.id',
  `fdType` int(11) NOT NULL COMMENT '类型',
  `fdOrder` int(11) NOT NULL DEFAULT '0' COMMENT '用于排列的顺序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbTagExam`
--

CREATE TABLE `tbTagExam` (
  `id` int(11) NOT NULL,
  `fdTagID` int(11) DEFAULT NULL COMMENT '分类ID，对应tbTag.id ',
  `fdExamID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='试卷分类表';

-- --------------------------------------------------------

--
-- Table structure for table `tbTagExamItem`
--

CREATE TABLE `tbTagExamItem` (
  `id` int(11) NOT NULL,
  `fdExamItemID` int(11) NOT NULL,
  `fdTagID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='大题标签表';

-- --------------------------------------------------------

--
-- Table structure for table `tbTagExercise`
--

CREATE TABLE `tbTagExercise` (
  `id` int(11) NOT NULL,
  `fdTagID` int(11) DEFAULT NULL COMMENT '知识点ID，对应tbTag.id',
  `fdExerciseID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='知识点/小节诊断习题表';

-- --------------------------------------------------------

--
-- Table structure for table `tbTagOption`
--

CREATE TABLE `tbTagOption` (
  `id` int(11) NOT NULL,
  `fdType` int(11) NOT NULL COMMENT '选项类型: 1:选择题; 2:匹配题',
  `fdTagID` int(11) NOT NULL COMMENT '对应的标签',
  `fdValue` int(11) NOT NULL COMMENT '对应的tbObject.id/tbMatching.id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='选项标签';

-- --------------------------------------------------------

--
-- Table structure for table `tbTask`
--

CREATE TABLE `tbTask` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdKey` char(128) NOT NULL COMMENT '任务标示：英文，必须唯一',
  `fdType` int(11) NOT NULL COMMENT '任务类型：0-每日任务，1-新手任务，2 - 奖励任务',
  `fdRule` varchar(255) NOT NULL COMMENT '完成任务的规则',
  `fdGrowthValue` smallint(4) DEFAULT '0' COMMENT '完成任务获得的成长值数量',
  `fdCoin` smallint(4) DEFAULT '0' COMMENT '完成任务获得的金币数量',
  `fdStatus` smallint(4) DEFAULT '0' COMMENT '启用状态：0-启用，1-禁用',
  `fdRedirect` varchar(255) NOT NULL COMMENT '跳转页面',
  `fdCreate` datetime DEFAULT NULL COMMENT '创建日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='系统任务管理：具体的任务列表';

-- --------------------------------------------------------

--
-- Table structure for table `tbTaskRecord`
--

CREATE TABLE `tbTaskRecord` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdKey` char(128) NOT NULL COMMENT '任务标示：来自tbTask.fdKey',
  `fdEx` int(11) NOT NULL DEFAULT '0' COMMENT '关联属性，取决fdKey:TASK_DONE_EXERCISE=>对应tbExercise.id',
  `fdCreate` datetime DEFAULT NULL COMMENT '创建日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户完成任务记录，只记录首次任务以及奖励任务';

-- --------------------------------------------------------

--
-- Table structure for table `tbTerminal`
--

CREATE TABLE `tbTerminal` (
  `id` int(11) NOT NULL,
  `fdTypeID` int(11) NOT NULL COMMENT '1-正式用户\r\n            2-友好用户\r\n            3-测试用户',
  `fdMAC` varchar(128) NOT NULL,
  `fdConfig` blob COMMENT '用户的配置文件',
  `fdCreate` datetime NOT NULL,
  `fdSession` varchar(64) DEFAULT NULL,
  `fdExpired` datetime DEFAULT NULL,
  `fdUA` varchar(192) DEFAULT NULL COMMENT '记录终端User Agent参数',
  `fdToken` binary(32) DEFAULT NULL COMMENT 'Apple push notification service 所需的device token，由终端在vsapi_profile接口提供'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='终端用户表开通终端的操作创建本表记录';

-- --------------------------------------------------------

--
-- Table structure for table `tbText`
--

CREATE TABLE `tbText` (
  `id` int(11) NOT NULL,
  `fdEntityID` int(11) DEFAULT NULL,
  `fdFileID` int(11) DEFAULT NULL,
  `fdValue` text,
  `fdType` tinyint(4) NOT NULL DEFAULT '0' COMMENT '文本类型'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbThirdAuth`
--

CREATE TABLE `tbThirdAuth` (
  `fdUserID` int(11) NOT NULL COMMENT '对应user.id',
  `fdTypeID` int(11) NOT NULL COMMENT '第三方ID, 1-微信; 2-微博; 3-QQ,...',
  `fdToken` char(255) NOT NULL COMMENT '第三方access_token(授权码)，访问第三方资源的凭证\r\n            形如：e329092942f228d232c40952da668505',
  `fdLogin` char(64) DEFAULT NULL COMMENT '登录账号, 若有',
  `fdName` char(64) DEFAULT NULL COMMENT '昵称',
  `fdOpenID` char(64) DEFAULT NULL COMMENT '授权码，访问第三方资源的凭证\r\n            形如：e329092942f228d232c40952da668505',
  `fdOpenKey` char(64) DEFAULT NULL COMMENT '与openid对应的用户key，是验证openid身份的验证密钥\r\n            形如：BCE1BEF8F0AEA68FBB426ED811DDD766',
  `fdUID` int(11) DEFAULT NULL COMMENT '用户的唯一编号，例如QQ号、新浪用户编号，等等',
  `fdCreated` int(11) NOT NULL DEFAULT '0' COMMENT '加入时间',
  `fdExpire` int(11) NOT NULL DEFAULT '0' COMMENT '过期时间,单位为秒,默认为0:不过期',
  `fdAttributes` char(255) DEFAULT NULL COMMENT '其它附加属性'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='第三方授权登录表';

-- --------------------------------------------------------

--
-- Table structure for table `tbUser`
--

CREATE TABLE `tbUser` (
  `id` int(11) NOT NULL COMMENT '用户id',
  `fdLogin` varchar(128) NOT NULL COMMENT '用户名,若用户使用邮箱/手机注册,则邮箱/手机号码为默认用户名',
  `fdNickname` varchar(128) NOT NULL COMMENT '用户名',
  `fdPassword` char(225) NOT NULL COMMENT '密码密文',
  `fdSalt` char(225) NOT NULL COMMENT '与明文密码一起生成的随机数',
  `fdLast` datetime NOT NULL COMMENT '最近的一次访问时间',
  `fdType` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型,0:学员; 1:教师; ',
  `fdEntityId` int(11) NOT NULL DEFAULT '0' COMMENT 'Entity对象Id',
  `fdOrigin` int(2) NOT NULL DEFAULT '1' COMMENT '注册来源1PC，2后台，3小程序',
  `fdStatus` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户状态，creted，verifying,ok,blocked'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户表,用于验证';

-- --------------------------------------------------------

--
-- Table structure for table `tbUserGrowth`
--

CREATE TABLE `tbUserGrowth` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdValue` int(11) DEFAULT '0' COMMENT '成长值数量',
  `fdGrowthRank` int(11) DEFAULT '0' COMMENT '成长值数量'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户成长值';

-- --------------------------------------------------------

--
-- Table structure for table `tbUserGrowthRecord`
--

CREATE TABLE `tbUserGrowthRecord` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdInfo` varchar(255) NOT NULL COMMENT '获得成长值描述：今日签到或者验证邮箱等',
  `fdNumber` int(11) DEFAULT '0' COMMENT '成长值数量',
  `fdStatus` smallint(4) DEFAULT '0' COMMENT '发放状态：0-未完成，1-完成',
  `fdCreate` datetime NOT NULL COMMENT '当前日期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户成长值记录表';

-- --------------------------------------------------------

--
-- Table structure for table `tbUserInfo`
--

CREATE TABLE `tbUserInfo` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL,
  `fdUsername` char(64) NOT NULL COMMENT '用户名, 可用邮箱/手机替换',
  `fdName` char(64) NOT NULL COMMENT '姓名',
  `fdAdmin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否系统管理员',
  `fdCreated` datetime NOT NULL COMMENT '加入时间',
  `fdFace` char(255) NOT NULL DEFAULT '' COMMENT '个人默认头像,多个头像:file表',
  `fdIntro` text COMMENT '详细介绍',
  `fdVoteupNum` int(11) NOT NULL DEFAULT '0' COMMENT '赞成数',
  `fdSex` char(8) NOT NULL DEFAULT '' COMMENT '性别',
  `fdAge` int(2) NOT NULL DEFAULT '0' COMMENT '年龄',
  `fdNotify` tinyint(1) NOT NULL DEFAULT '0' COMMENT '接收邮件等通知的设置;0:不接收',
  `fdTitle` varchar(20) DEFAULT NULL COMMENT '职称/头衔',
  `fdAreaID` int(11) DEFAULT NULL COMMENT '所在地区',
  `fdQQ` varchar(50) DEFAULT NULL COMMENT '用户qq号',
  `fdWechat` varchar(50) DEFAULT NULL COMMENT '用户微信号',
  `fdIP` varchar(15) DEFAULT NULL COMMENT '用户注册IP地址',
  `fdOpenid` varchar(50) DEFAULT NULL COMMENT '用户微信openid',
  `fdUnionID` varchar(50) NOT NULL DEFAULT '0' COMMENT '用户微信UnionID',
  `fdCoin` int(11) DEFAULT '0' COMMENT '用户金币数量'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户信息表';

-- --------------------------------------------------------

--
-- Table structure for table `tbUserPlan`
--

CREATE TABLE `tbUserPlan` (
  `id` int(11) UNSIGNED NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID：tbUserID.id',
  `fdPlanID` int(11) NOT NULL COMMENT '计划ID',
  `fdStatus` smallint(4) DEFAULT '0' COMMENT '完成状态：0-未完成，1-完成',
  `fdCreate` datetime NOT NULL COMMENT '创建日期',
  `fdStart` datetime DEFAULT NULL COMMENT '开始时间',
  `fdEnd` datetime DEFAULT NULL COMMENT '结束时间',
  `fdFinish` datetime DEFAULT NULL COMMENT '完成时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户计划';

-- --------------------------------------------------------

--
-- Table structure for table `tbUserWechat`
--

CREATE TABLE `tbUserWechat` (
  `id` int(11) NOT NULL,
  `fdUserID` int(11) NOT NULL COMMENT '用户ID',
  `fdOpenid` varchar(50) NOT NULL COMMENT '用户微信openid',
  `fdAppID` int(2) NOT NULL COMMENT '应用ID，31托福 32GRE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbWrong`
--

CREATE TABLE `tbWrong` (
  `id` int(11) NOT NULL,
  `fdApplicationID` int(11) DEFAULT NULL COMMENT '对应到tbApplication.id',
  `fdTargetID` int(11) DEFAULT NULL COMMENT '对应的目标ID，仅在考试通关有效',
  `fdUserID` int(11) DEFAULT NULL COMMENT 'service.tbUser.id',
  `fdExerciseID` int(11) DEFAULT NULL COMMENT 'tbExercise.id',
  `fdContinue` int(11) DEFAULT '0' COMMENT '持续做对次数',
  `fdStatus` tinyint(4) DEFAULT '0' COMMENT '错题本状态 0：错题 1：已攻克 2：移除',
  `fdCreate` datetime DEFAULT NULL,
  `fdUpdate` datetime DEFAULT NULL,
  `fdNote` text COMMENT '错题心得'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户错题本';

-- --------------------------------------------------------

--
-- Table structure for table `tbWrongRecord`
--

CREATE TABLE `tbWrongRecord` (
  `id` int(11) NOT NULL,
  `fdWrongID` int(11) NOT NULL COMMENT '错题本错题ID，对应tbWrong.id',
  `fdApplicationID` int(11) DEFAULT '0' COMMENT '当前做错题目所在的终端',
  `fdAnswerQuestionID` int(11) NOT NULL COMMENT '答题ID',
  `fdSceneID` int(11) DEFAULT NULL COMMENT '错题所在场景',
  `fdValue` int(11) DEFAULT NULL COMMENT '场景对应的ID',
  `fdRight` tinyint(4) DEFAULT '0' COMMENT '答题结果 0代表错误 1代表正确',
  `fdCreate` datetime DEFAULT NULL COMMENT '答题时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='错题本答题记录';

-- --------------------------------------------------------

--
-- Table structure for table `tbWrongReview`
--

CREATE TABLE `tbWrongReview` (
  `id` int(11) NOT NULL,
  `fdWrongID` int(11) NOT NULL COMMENT '错题记录ID',
  `fdAnswerQuestionID` int(11) NOT NULL COMMENT '答题ID'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='错题本类似题答题记录';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbActivity`
--
ALTER TABLE `tbActivity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdName` (`fdName`) USING BTREE;

--
-- Indexes for table `tbActivityMap`
--
ALTER TABLE `tbActivityMap`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdEntityID` (`fdEntityID`) USING BTREE,
  ADD KEY `fdActivityID` (`fdActivityID`) USING BTREE;

--
-- Indexes for table `tbAdminLog`
--
ALTER TABLE `tbAdminLog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswer`
--
ALTER TABLE `tbAnswer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdQuestionID` (`fdQuestionID`),
  ADD KEY `fdUserID` (`fdUserID`);

--
-- Indexes for table `tbAnswerExam`
--
ALTER TABLE `tbAnswerExam`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdUserID_2` (`fdUserID`),
  ADD KEY `fdExamID` (`fdExamID`),
  ADD KEY `fdAppID` (`fdAppID`);

--
-- Indexes for table `tbAnswerExamItem`
--
ALTER TABLE `tbAnswerExamItem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdAnswerExamID` (`fdAnswerExamID`),
  ADD KEY `fdAnswerExamID_2` (`fdAnswerExamID`);

--
-- Indexes for table `tbAnswerExercise`
--
ALTER TABLE `tbAnswerExercise`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdAnswerExamID` (`fdAnswerExamID`),
  ADD KEY `fdAnswerExamID_2` (`fdAnswerExamID`),
  ADD KEY `fdExerciseItemID` (`fdExerciseItemID`),
  ADD KEY `idx_item_right` (`fdExerciseItemID`,`fdRight`);

--
-- Indexes for table `tbAnswerGist`
--
ALTER TABLE `tbAnswerGist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerMark`
--
ALTER TABLE `tbAnswerMark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerMatch`
--
ALTER TABLE `tbAnswerMatch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerOptions`
--
ALTER TABLE `tbAnswerOptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Reference_120` (`fdOptionsID`),
  ADD KEY `fdOptionsID` (`fdOptionsID`),
  ADD KEY `fdAnswerSubjective` (`fdAnswerSubjective`);

--
-- Indexes for table `tbAnswerQuestion`
--
ALTER TABLE `tbAnswerQuestion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdAnswerExamID` (`fdAnswerExamID`),
  ADD KEY `fdExerciseID` (`fdExerciseID`),
  ADD KEY `fdAnswerExamItemID` (`fdAnswerExamItemID`),
  ADD KEY `fdRight` (`fdRight`);

--
-- Indexes for table `tbAnswerQuestionGroup`
--
ALTER TABLE `tbAnswerQuestionGroup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerReport`
--
ALTER TABLE `tbAnswerReport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerSeries`
--
ALTER TABLE `tbAnswerSeries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAnswerSubjective`
--
ALTER TABLE `tbAnswerSubjective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdAnswerExerciseID` (`fdAnswerExerciseID`),
  ADD KEY `fdSubjectiveID` (`fdSubjectiveID`);

--
-- Indexes for table `tbAnswerTotalReport`
--
ALTER TABLE `tbAnswerTotalReport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAppraise`
--
ALTER TABLE `tbAppraise`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbAttributes`
--
ALTER TABLE `tbAttributes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbBlob`
--
ALTER TABLE `tbBlob`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Blog_entity` (`fdEntityID`),
  ADD KEY `FK_Reference_48` (`fdFileID`);

--
-- Indexes for table `tbCache`
--
ALTER TABLE `tbCache`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbCarousel`
--
ALTER TABLE `tbCarousel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbCarouselItem`
--
ALTER TABLE `tbCarouselItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbChannel`
--
ALTER TABLE `tbChannel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbChannelClass`
--
ALTER TABLE `tbChannelClass`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbChannelCode`
--
ALTER TABLE `tbChannelCode`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbChannelUser`
--
ALTER TABLE `tbChannelUser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbClass`
--
ALTER TABLE `tbClass`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbClassMap`
--
ALTER TABLE `tbClassMap`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdClassID` (`fdClassID`),
  ADD KEY `fdUserID` (`fdUserID`);

--
-- Indexes for table `tbClassResource`
--
ALTER TABLE `tbClassResource`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbCoinRecord`
--
ALTER TABLE `tbCoinRecord`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbComment`
--
ALTER TABLE `tbComment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdParentID` (`fdParentID`),
  ADD KEY `fdUserID` (`fdUserID`),
  ADD KEY `fdTerminalID` (`fdTerminalID`),
  ADD KEY `fdEntityID` (`fdEntityID`),
  ADD KEY `fdFileID` (`fdFileID`),
  ADD KEY `fdApproverID` (`fdApproverID`);

--
-- Indexes for table `tbCommentMap`
--
ALTER TABLE `tbCommentMap`
  ADD KEY `fdCommentID` (`fdCommentID`);

--
-- Indexes for table `tbCourse`
--
ALTER TABLE `tbCourse`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbEmail`
--
ALTER TABLE `tbEmail`
  ADD KEY `fdUserID` (`fdUserID`),
  ADD KEY `fdEmail` (`fdEmail`);

--
-- Indexes for table `tbEntity`
--
ALTER TABLE `tbEntity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExam`
--
ALTER TABLE `tbExam`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdEntityID` (`fdEntityID`),
  ADD KEY `fdExamTypeID` (`fdExamTypeID`);

--
-- Indexes for table `tbExamination`
--
ALTER TABLE `tbExamination`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExamItem`
--
ALTER TABLE `tbExamItem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdEntityID` (`fdEntityID`),
  ADD KEY `fdExamID` (`fdExamID`);

--
-- Indexes for table `tbExamItemMap`
--
ALTER TABLE `tbExamItemMap`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdExerciseID` (`fdExerciseID`),
  ADD KEY `fdExamItemID` (`fdExamItemID`);

--
-- Indexes for table `tbExamPlan`
--
ALTER TABLE `tbExamPlan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExamSchedule`
--
ALTER TABLE `tbExamSchedule`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExamType`
--
ALTER TABLE `tbExamType`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExercise`
--
ALTER TABLE `tbExercise`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExerciseItem`
--
ALTER TABLE `tbExerciseItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbExerciseType`
--
ALTER TABLE `tbExerciseType`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbFavorite`
--
ALTER TABLE `tbFavorite`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbFeedback`
--
ALTER TABLE `tbFeedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbFile`
--
ALTER TABLE `tbFile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbGlossary`
--
ALTER TABLE `tbGlossary`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user word` (`fdWord`,`fdUserID`);

--
-- Indexes for table `tbGlossaryOrigin`
--
ALTER TABLE `tbGlossaryOrigin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbGrowthRank`
--
ALTER TABLE `tbGrowthRank`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbListenGist`
--
ALTER TABLE `tbListenGist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbListening`
--
ALTER TABLE `tbListening`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbListenMark`
--
ALTER TABLE `tbListenMark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbLove`
--
ALTER TABLE `tbLove`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbMatching`
--
ALTER TABLE `tbMatching`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbMatchItem`
--
ALTER TABLE `tbMatchItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbMenu`
--
ALTER TABLE `tbMenu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tree_NK1` (`fdRoot`),
  ADD KEY `tree_NK2` (`fdLeft`),
  ADD KEY `tree_NK3` (`fdRight`),
  ADD KEY `tree_NK4` (`fdLvl`),
  ADD KEY `tree_NK5` (`active`);

--
-- Indexes for table `tbmessage`
--
ALTER TABLE `tbmessage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbMessageCategory`
--
ALTER TABLE `tbMessageCategory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fdName` (`fdName`);

--
-- Indexes for table `tbMessageData`
--
ALTER TABLE `tbMessageData`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbNotepad`
--
ALTER TABLE `tbNotepad`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbNotify`
--
ALTER TABLE `tbNotify`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notify_from_uid_index` (`fdFromUserID`),
  ADD KEY `notify_to_uid_index` (`fdToUserID`),
  ADD KEY `notify_category_id_index` (`fdCategoryID`);

--
-- Indexes for table `tbNotifyCategory`
--
ALTER TABLE `tbNotifyCategory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sign` (`fdSign`),
  ADD UNIQUE KEY `fdName` (`fdName`);

--
-- Indexes for table `tbObject`
--
ALTER TABLE `tbObject`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Reference_1` (`fdExerciseItemID`);

--
-- Indexes for table `tbPlan`
--
ALTER TABLE `tbPlan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbPush`
--
ALTER TABLE `tbPush`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbReadGist`
--
ALTER TABLE `tbReadGist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbReadMark`
--
ALTER TABLE `tbReadMark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbReadStructure`
--
ALTER TABLE `tbReadStructure`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbResourceGroup`
--
ALTER TABLE `tbResourceGroup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbResourceMap`
--
ALTER TABLE `tbResourceMap`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbSign`
--
ALTER TABLE `tbSign`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbSignRecord`
--
ALTER TABLE `tbSignRecord`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbSubject`
--
ALTER TABLE `tbSubject`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbSubjective`
--
ALTER TABLE `tbSubjective`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Reference_9` (`fdExerciseItemID`),
  ADD KEY `subjective_rate` (`fdRate`),
  ADD KEY `subjective_score` (`fdScore`);

--
-- Indexes for table `tbSystemLog`
--
ALTER TABLE `tbSystemLog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbTag`
--
ALTER TABLE `tbTag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tree_NK1` (`fdRoot`),
  ADD KEY `tree_NK2` (`fdLeft`),
  ADD KEY `tree_NK3` (`fdRight`),
  ADD KEY `tree_NK4` (`fdLvl`),
  ADD KEY `tree_NK5` (`active`);

--
-- Indexes for table `tbTagEntity`
--
ALTER TABLE `tbTagEntity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdEntityID` (`fdEntityID`);

--
-- Indexes for table `tbTagExam`
--
ALTER TABLE `tbTagExam`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_ExamID` (`fdExamID`),
  ADD KEY `FK_TagID` (`fdTagID`);

--
-- Indexes for table `tbTagExamItem`
--
ALTER TABLE `tbTagExamItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbTagExercise`
--
ALTER TABLE `tbTagExercise`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_ExerciseID` (`fdExerciseID`),
  ADD KEY `FK_TagID` (`fdTagID`);

--
-- Indexes for table `tbTagOption`
--
ALTER TABLE `tbTagOption`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbTask`
--
ALTER TABLE `tbTask`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbTaskRecord`
--
ALTER TABLE `tbTaskRecord`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbTerminal`
--
ALTER TABLE `tbTerminal`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbText`
--
ALTER TABLE `tbText`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Text_Entity` (`fdEntityID`),
  ADD KEY `FK_Reference_47` (`fdFileID`);

--
-- Indexes for table `tbUser`
--
ALTER TABLE `tbUser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbUserGrowth`
--
ALTER TABLE `tbUserGrowth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbUserGrowthRecord`
--
ALTER TABLE `tbUserGrowthRecord`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbUserInfo`
--
ALTER TABLE `tbUserInfo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdUserID` (`fdUserID`);

--
-- Indexes for table `tbUserPlan`
--
ALTER TABLE `tbUserPlan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbUserWechat`
--
ALTER TABLE `tbUserWechat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbWrong`
--
ALTER TABLE `tbWrong`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Reference_80` (`fdExerciseID`);

--
-- Indexes for table `tbWrongRecord`
--
ALTER TABLE `tbWrongRecord`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fdWrongID` (`fdWrongID`);

--
-- Indexes for table `tbWrongReview`
--
ALTER TABLE `tbWrongReview`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbActivity`
--
ALTER TABLE `tbActivity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `tbActivityMap`
--
ALTER TABLE `tbActivityMap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50188;
--
-- AUTO_INCREMENT for table `tbAdminLog`
--
ALTER TABLE `tbAdminLog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37844;
--
-- AUTO_INCREMENT for table `tbAnswer`
--
ALTER TABLE `tbAnswer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbAnswerExam`
--
ALTER TABLE `tbAnswerExam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109483;
--
-- AUTO_INCREMENT for table `tbAnswerExamItem`
--
ALTER TABLE `tbAnswerExamItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173368;
--
-- AUTO_INCREMENT for table `tbAnswerExercise`
--
ALTER TABLE `tbAnswerExercise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1985164;
--
-- AUTO_INCREMENT for table `tbAnswerGist`
--
ALTER TABLE `tbAnswerGist`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `tbAnswerMark`
--
ALTER TABLE `tbAnswerMark`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;
--
-- AUTO_INCREMENT for table `tbAnswerMatch`
--
ALTER TABLE `tbAnswerMatch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4331;
--
-- AUTO_INCREMENT for table `tbAnswerOptions`
--
ALTER TABLE `tbAnswerOptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbAnswerQuestion`
--
ALTER TABLE `tbAnswerQuestion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1986146;
--
-- AUTO_INCREMENT for table `tbAnswerQuestionGroup`
--
ALTER TABLE `tbAnswerQuestionGroup`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7479;
--
-- AUTO_INCREMENT for table `tbAnswerReport`
--
ALTER TABLE `tbAnswerReport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
--
-- AUTO_INCREMENT for table `tbAnswerSeries`
--
ALTER TABLE `tbAnswerSeries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbAnswerSubjective`
--
ALTER TABLE `tbAnswerSubjective`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11591;
--
-- AUTO_INCREMENT for table `tbAnswerTotalReport`
--
ALTER TABLE `tbAnswerTotalReport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbAppraise`
--
ALTER TABLE `tbAppraise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbAttributes`
--
ALTER TABLE `tbAttributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4748;
--
-- AUTO_INCREMENT for table `tbBlob`
--
ALTER TABLE `tbBlob`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9215;
--
-- AUTO_INCREMENT for table `tbCarousel`
--
ALTER TABLE `tbCarousel`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;
--
-- AUTO_INCREMENT for table `tbCarouselItem`
--
ALTER TABLE `tbCarouselItem`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `tbChannel`
--
ALTER TABLE `tbChannel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `tbChannelClass`
--
ALTER TABLE `tbChannelClass`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `tbChannelCode`
--
ALTER TABLE `tbChannelCode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7873;
--
-- AUTO_INCREMENT for table `tbChannelUser`
--
ALTER TABLE `tbChannelUser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `tbClass`
--
ALTER TABLE `tbClass`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;
--
-- AUTO_INCREMENT for table `tbClassMap`
--
ALTER TABLE `tbClassMap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11593;
--
-- AUTO_INCREMENT for table `tbClassResource`
--
ALTER TABLE `tbClassResource`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=397;
--
-- AUTO_INCREMENT for table `tbCoinRecord`
--
ALTER TABLE `tbCoinRecord`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
--
-- AUTO_INCREMENT for table `tbComment`
--
ALTER TABLE `tbComment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=375;
--
-- AUTO_INCREMENT for table `tbCourse`
--
ALTER TABLE `tbCourse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '课程id';
--
-- AUTO_INCREMENT for table `tbEntity`
--
ALTER TABLE `tbEntity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=36455;
--
-- AUTO_INCREMENT for table `tbExam`
--
ALTER TABLE `tbExam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2829;
--
-- AUTO_INCREMENT for table `tbExamination`
--
ALTER TABLE `tbExamination`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `tbExamItem`
--
ALTER TABLE `tbExamItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4773;
--
-- AUTO_INCREMENT for table `tbExamItemMap`
--
ALTER TABLE `tbExamItemMap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78635;
--
-- AUTO_INCREMENT for table `tbExamPlan`
--
ALTER TABLE `tbExamPlan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `tbExamSchedule`
--
ALTER TABLE `tbExamSchedule`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;
--
-- AUTO_INCREMENT for table `tbExamType`
--
ALTER TABLE `tbExamType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbExercise`
--
ALTER TABLE `tbExercise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9469;
--
-- AUTO_INCREMENT for table `tbExerciseItem`
--
ALTER TABLE `tbExerciseItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9462;
--
-- AUTO_INCREMENT for table `tbExerciseType`
--
ALTER TABLE `tbExerciseType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbFavorite`
--
ALTER TABLE `tbFavorite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4171;
--
-- AUTO_INCREMENT for table `tbFeedback`
--
ALTER TABLE `tbFeedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=178;
--
-- AUTO_INCREMENT for table `tbFile`
--
ALTER TABLE `tbFile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=9797;
--
-- AUTO_INCREMENT for table `tbGlossary`
--
ALTER TABLE `tbGlossary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID', AUTO_INCREMENT=2186;
--
-- AUTO_INCREMENT for table `tbGlossaryOrigin`
--
ALTER TABLE `tbGlossaryOrigin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID', AUTO_INCREMENT=2358;
--
-- AUTO_INCREMENT for table `tbGrowthRank`
--
ALTER TABLE `tbGrowthRank`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `tbListenGist`
--
ALTER TABLE `tbListenGist`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbListening`
--
ALTER TABLE `tbListening`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13434;
--
-- AUTO_INCREMENT for table `tbListenMark`
--
ALTER TABLE `tbListenMark`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `tbLove`
--
ALTER TABLE `tbLove`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbMatching`
--
ALTER TABLE `tbMatching`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;
--
-- AUTO_INCREMENT for table `tbMatchItem`
--
ALTER TABLE `tbMatchItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;
--
-- AUTO_INCREMENT for table `tbMenu`
--
ALTER TABLE `tbMenu`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;
--
-- AUTO_INCREMENT for table `tbmessage`
--
ALTER TABLE `tbmessage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbMessageCategory`
--
ALTER TABLE `tbMessageCategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `tbMessageData`
--
ALTER TABLE `tbMessageData`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbNotepad`
--
ALTER TABLE `tbNotepad`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=235;
--
-- AUTO_INCREMENT for table `tbNotify`
--
ALTER TABLE `tbNotify`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2403;
--
-- AUTO_INCREMENT for table `tbNotifyCategory`
--
ALTER TABLE `tbNotifyCategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `tbObject`
--
ALTER TABLE `tbObject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52942;
--
-- AUTO_INCREMENT for table `tbPlan`
--
ALTER TABLE `tbPlan`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `tbPush`
--
ALTER TABLE `tbPush`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbReadGist`
--
ALTER TABLE `tbReadGist`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbReadMark`
--
ALTER TABLE `tbReadMark`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbReadStructure`
--
ALTER TABLE `tbReadStructure`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbResourceGroup`
--
ALTER TABLE `tbResourceGroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
--
-- AUTO_INCREMENT for table `tbResourceMap`
--
ALTER TABLE `tbResourceMap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90874;
--
-- AUTO_INCREMENT for table `tbSign`
--
ALTER TABLE `tbSign`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `tbSignRecord`
--
ALTER TABLE `tbSignRecord`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;
--
-- AUTO_INCREMENT for table `tbSubject`
--
ALTER TABLE `tbSubject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbSubjective`
--
ALTER TABLE `tbSubjective`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=546;
--
-- AUTO_INCREMENT for table `tbSystemLog`
--
ALTER TABLE `tbSystemLog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306366;
--
-- AUTO_INCREMENT for table `tbTag`
--
ALTER TABLE `tbTag`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=703;
--
-- AUTO_INCREMENT for table `tbTagEntity`
--
ALTER TABLE `tbTagEntity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92783;
--
-- AUTO_INCREMENT for table `tbTagExam`
--
ALTER TABLE `tbTagExam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1840;
--
-- AUTO_INCREMENT for table `tbTagExamItem`
--
ALTER TABLE `tbTagExamItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbTagExercise`
--
ALTER TABLE `tbTagExercise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;
--
-- AUTO_INCREMENT for table `tbTagOption`
--
ALTER TABLE `tbTagOption`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=497;
--
-- AUTO_INCREMENT for table `tbTask`
--
ALTER TABLE `tbTask`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `tbTaskRecord`
--
ALTER TABLE `tbTaskRecord`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1927;
--
-- AUTO_INCREMENT for table `tbTerminal`
--
ALTER TABLE `tbTerminal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbText`
--
ALTER TABLE `tbText`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbUser`
--
ALTER TABLE `tbUser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id', AUTO_INCREMENT=5345;
--
-- AUTO_INCREMENT for table `tbUserGrowth`
--
ALTER TABLE `tbUserGrowth`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;
--
-- AUTO_INCREMENT for table `tbUserGrowthRecord`
--
ALTER TABLE `tbUserGrowthRecord`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2389;
--
-- AUTO_INCREMENT for table `tbUserInfo`
--
ALTER TABLE `tbUserInfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5345;
--
-- AUTO_INCREMENT for table `tbUserPlan`
--
ALTER TABLE `tbUserPlan`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;
--
-- AUTO_INCREMENT for table `tbUserWechat`
--
ALTER TABLE `tbUserWechat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1647;
--
-- AUTO_INCREMENT for table `tbWrong`
--
ALTER TABLE `tbWrong`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=222891;
--
-- AUTO_INCREMENT for table `tbWrongRecord`
--
ALTER TABLE `tbWrongRecord`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241923;
--
-- AUTO_INCREMENT for table `tbWrongReview`
--
ALTER TABLE `tbWrongReview`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
