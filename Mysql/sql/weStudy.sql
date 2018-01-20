DROP TABLE IF EXISTS `tbVolume`;
CREATE TABLE `tbVolume`(
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
  `fdEntityID` INT(11) NOT NULL COMMENT '实体标识，对应entity.id',
  `fdType` INT(4) NOT NULL COMMENT '资源卷类型(ex:10-阅读)',
  `fdTitle` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '标题',
  `fdLecturer` INT(11) NOT NULL COMMENT '主讲师：对应tbUser.id',
  `fdPrice` decimal(12,2) DEFAULT 0 COMMENT '价格',
  `fdIntro` TEXT NOT NULL COMMENT '资源卷简介',
  `fdOrder` INT(11) DEFAULT 0 COMMENT '排序',
  `fdViews` INT(11) NOT NULL DEFAULT 0 COMMENT '浏览量',
  `fdChargeStatus` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否收费：0-免费；1-收费',
  `fdRecomStatus` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否推荐：0-不推荐；1-推荐',
  `fdStatus` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否禁用：0-不禁用',
  `fdCreate` DATETIME NOT NULL COMMENT '创建时间',
  `fdUpdate` DATETIME NOT NULL COMMENT '修改时间',
	KEY (`fdEntityID`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源卷';


DROP TABLE IF EXISTS `tbVolumeChapter`;
CREATE TABLE `tbVolumeChapter` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
  `fdEntityID` INT(11) NOT NULL COMMENT '实体标识，对应entity.id',
  `fdVolumeID` INT(11) DEFAULT NULL COMMENT '资源卷ID：对应tbVolume.id',
  `fdTitle` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '章-标题',
  `fdCreate` DATETIME NOT NULL COMMENT '创建时间',
  `fdUpdate` DATETIME NOT NULL COMMENT '修改时间',
	KEY (`fdVolumeID`),
	KEY (`fdEntityID`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源卷-章';

DROP TABLE IF EXISTS `tbVolumeChapterItem`;
CREATE TABLE `tbVolumeChapterItem` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
  `fdEntityID` INT(11) NOT NULL COMMENT '实体标识，对应entity.id',
  `fdVolumeID` INT(11) DEFAULT NULL COMMENT '资源卷ID：对应tbVolume.id',
  `fdVolumeChapterID` int(11) DEFAULT NULL COMMENT '资源卷章ID:对应tbVolumeChapter.id',
  `fdTitle` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '节-标题',
  `fdType` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '关联类型：0：视频ID:对应tbPolyvVideo.id',
  `fdSourceID` INT(11) NOT NULL COMMENT '根据fdType，资源唯一ID',
  `fdCreate` DATETIME NOT NULL COMMENT '创建时间',
  `fdUpdate` DATETIME NOT NULL COMMENT '修改时间',
	KEY (`fdVolumeID`),
	KEY (`fdVolumeChapterID`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源卷-节';

DROP TABLE IF EXISTS `tbPolyvVideo`;
CREATE TABLE `tbPolyvVideo` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
	`fdTitle` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '视频标题',
	`fdVid` VARCHAR(64) NOT NULL COMMENT '视频唯一标识',
	`fdDuration` SMALLINT(64) DEFAULT 0 NOT NULL COMMENT '视频时长：单位/秒',
  `fdStatus` TINYINT(1) DEFAULT 0 COMMENT '视频状态：60/61已发布；10等待编码；20正在编码；50等待审核；51审核不通过；-1已删除',
  `fdSize` INT(11) DEFAULT 0 NOT NULL COMMENT '文件大小,字节数',
  `fdCateID` INT(11) DEFAULT NULL COMMENT 'Polyv分类ID',
  `fdFirstImg` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '首张图',
  `fdUpload` DATETIME NOT NULL COMMENT '上传时间',
  `fdCreate` DATETIME NOT NULL COMMENT '创建时间',
  `fdUpdate` DATETIME NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保利威视点播视频信息';

DROP TABLE IF EXISTS `tbVolumeRecord`;
CREATE TABLE `tbVolumeRecord`(
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
	`fdVolumeID` INT(11) DEFAULT NULL COMMENT '资源卷ID：对应tbVolume.id',
	`fdUserID` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID：tbUserID.id',
  `fdSchedule` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '学习进度:0~100(单位/%)',
  `fdCreate` DATETIME NOT NULL COMMENT '创建时间',
  `fdUpdate` DATETIME NOT NULL COMMENT '修改时间',
	KEY (`fdVolumeID`),
	PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT '资源卷学习统计';

DROP TABLE IF EXISTS `tbVolumeChaIteRecord`;
CREATE TABLE `tbVolumeChaIteRecord`(
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '逻辑ID',
	`fdVolumeID` INT(11) DEFAULT NULL COMMENT '资源卷ID：对应tbVolume.id',
	`fdVolumeChapterID` INT(11) DEFAULT NULL COMMENT '资源卷章ID:对应tbVolumeChapter.id',
	`fdVolumeChapterItemID` INT(11) DEFAULT NULL COMMENT '资源卷章节ID:对应tbVolumeChapterItem.id',
	`fdDuration` SMALLINT(64) DEFAULT 0 NOT NULL COMMENT '观看视频时长：单位/秒',
  `fdUserID` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID：tbUserID.id',
  `fdCreate` datetime NOT NULL COMMENT '创建时间',
  `fdUpdate` datetime NOT NULL COMMENT '修改时间',
	KEY (`fdVolumeID`),
	KEY (`fdVolumeChapterID`),
	KEY (`fdVolumeChapterItemID`),
	PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT '资源卷-章-节学习统计';









