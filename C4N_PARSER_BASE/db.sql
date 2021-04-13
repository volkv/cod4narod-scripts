CREATE TABLE `chat`
(
    `id`      int                             NOT NULL AUTO_INCREMENT,
    `date`    datetime                        NOT NULL,
    `guid`    bigint                          NOT NULL,
    `player`  varchar(50) CHARACTER SET utf8  NOT NULL,
    `message` varchar(255) CHARACTER SET utf8 NOT NULL,
    `server`  int                             NOT NULL,
    PRIMARY KEY (`id`),
    KEY       `server` (`server`),
    KEY       `guid` (`guid`),
    KEY       `date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=17582 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `chat_archive`
(
    `id`      int                             NOT NULL AUTO_INCREMENT,
    `date`    datetime                        NOT NULL,
    `guid`    bigint                          NOT NULL,
    `player`  varchar(50) CHARACTER SET utf8  NOT NULL,
    `message` varchar(255) CHARACTER SET utf8 NOT NULL,
    `server`  int                             NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4082316 DEFAULT CHARSET=latin1
CREATE TABLE `donations`
(
    `id`                int NOT NULL AUTO_INCREMENT,
    `notification_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `operation_id`      varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `amount`            float                                DEFAULT NULL,
    `withdraw_amount`   float                                DEFAULT NULL,
    `datetime`          datetime                             DEFAULT NULL,
    `sender`            varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `label`             varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `user`              varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY                 `datetime` (`datetime`)
) ENGINE=InnoDB AUTO_INCREMENT=1108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `maps_ctl`
(
    `id`  int                                 NOT NULL AUTO_INCREMENT,
    `map` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `map` (`map`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `metrics`
(
    `metric` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `value`  int                                                     NOT NULL DEFAULT '0',
    PRIMARY KEY (`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
CREATE TABLE `ny2017`
(
    `player` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
    `guid`   bigint                              NOT NULL,
    `kills`  int                                 NOT NULL DEFAULT '0',
    `knives` int                                 NOT NULL DEFAULT '0',
    `server` int                                 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `ny2017_leaders`
(
    `player` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `guid`   bigint                               NOT NULL,
    `days`   int                                  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `ss`
(
    `guid`   bigint   NOT NULL,
    `name`   varchar(50) COLLATE utf8_unicode_ci  DEFAULT NULL,
    `ip`     varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
    `path`   varchar(50) COLLATE utf8_unicode_ci  DEFAULT NULL,
    `date`   datetime NOT NULL,
    `server` int      NOT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT '0',
    `axon`   tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`guid`, `date`, `server`),
    KEY      `name` (`name`),
    KEY      `guid` (`guid`),
    KEY      `date` (`date`),
    KEY      `server` (`server`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `statistics`
(
    `time`    datetime NOT NULL,
    `server`  int      NOT NULL,
    `map`     int      NOT NULL,
    `players` int      NOT NULL,
    PRIMARY KEY (`time`, `server`) USING BTREE,
    KEY       `map` (`map`),
    CONSTRAINT `statistics_ibfk_1` FOREIGN KEY (`map`) REFERENCES `maps_ctl` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1
CREATE TABLE `statistics_players`
(
    `id`      int  NOT NULL AUTO_INCREMENT,
    `server`  int  NOT NULL,
    `date`    date NOT NULL,
    `players` int  NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `stat` (`server`,`date`)
) ENGINE=InnoDB AUTO_INCREMENT=11462 DEFAULT CHARSET=latin1
CREATE TABLE `stats`
(
    `s_player`        varchar(100) COLLATE utf8_unicode_ci NOT NULL,
    `s_kills`         int                                           DEFAULT '0',
    `s_kills_d`       int                                  NOT NULL DEFAULT '0',
    `s_skill`         decimal(6, 2)                        NOT NULL DEFAULT '1600.00',
    `s_kills_w`       int                                  NOT NULL DEFAULT '0',
    `s_kill_streak`   int                                  NOT NULL DEFAULT '0',
    `s_deaths`        int                                           DEFAULT '0',
    `s_deaths_w`      int                                  NOT NULL DEFAULT '0',
    `s_death_streak`  int                                  NOT NULL DEFAULT '0',
    `s_grenade`       int                                           DEFAULT '0',
    `s_grenade_w`     int                                  NOT NULL DEFAULT '0',
    `s_heads`         int                                           DEFAULT '0',
    `s_heads_w`       int                                  NOT NULL DEFAULT '0',
    `s_time`          datetime                                      DEFAULT CURRENT_TIMESTAMP,
    `s_lasttime`      datetime                                      DEFAULT CURRENT_TIMESTAMP,
    `s_city`          varchar(40) COLLATE utf8_unicode_ci  NOT NULL DEFAULT '',
    `s_guid`          bigint                               NOT NULL,
    `s_geo`           varchar(50) COLLATE utf8_unicode_ci  NOT NULL DEFAULT '',
    `s_suicids`       int                                           DEFAULT '0',
    `s_suicids_w`     int                                  NOT NULL DEFAULT '0',
    `s_melle`         int                                           DEFAULT '0',
    `s_melle_w`       int                                  NOT NULL DEFAULT '0',
    `s_ping`          int                                           DEFAULT '0',
    `s_ip`            varchar(100) COLLATE utf8_unicode_ci          DEFAULT NULL,
    `s_fps`           int                                           DEFAULT '0',
    `s_playedtime`    int                                  NOT NULL DEFAULT '0',
    `s_playedtime_w`  int                                  NOT NULL DEFAULT '0',
    `s_playedkills`   int                                  NOT NULL DEFAULT '0',
    `s_playedkills_w` int                                  NOT NULL DEFAULT '0',
    `s_playeddeaths`  int                                  NOT NULL DEFAULT '0',
    `s_server`        int                                  NOT NULL DEFAULT '98',
    PRIMARY KEY (`s_guid`, `s_server`) USING BTREE,
    KEY               `s_player` (`s_player`),
    KEY               `s_guid` (`s_guid`) USING BTREE,
    KEY               `s_kills` (`s_kills`),
    KEY               `s_server` (`s_server`),
    KEY               `s_lasttime` (`s_lasttime`),
    KEY               `s_ip` (`s_ip`),
    KEY               `s_skill` (`s_skill`),
    KEY               `s_deaths` (`s_deaths`),
    KEY               `s_kills_w` (`s_kills_w`),
    KEY               `s_deaths_w` (`s_deaths_w`),
    KEY               `s_time` (`s_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `stats2`
(
    `s_player`        varchar(100) COLLATE utf8_unicode_ci NOT NULL,
    `s_kills`         int                                           DEFAULT '0',
    `s_kills_d`       int                                  NOT NULL DEFAULT '0',
    `s_skill`         decimal(6, 2)                        NOT NULL DEFAULT '1600.00',
    `s_kills_w`       int                                  NOT NULL DEFAULT '0',
    `s_kill_streak`   int                                  NOT NULL DEFAULT '0',
    `s_deaths`        int                                           DEFAULT '0',
    `s_deaths_w`      int                                  NOT NULL DEFAULT '0',
    `s_death_streak`  int                                  NOT NULL DEFAULT '0',
    `s_grenade`       int                                           DEFAULT '0',
    `s_grenade_w`     int                                  NOT NULL DEFAULT '0',
    `s_heads`         int                                           DEFAULT '0',
    `s_heads_w`       int                                  NOT NULL DEFAULT '0',
    `s_time`          datetime                                      DEFAULT CURRENT_TIMESTAMP,
    `s_lasttime`      datetime                                      DEFAULT CURRENT_TIMESTAMP,
    `s_city`          varchar(40) COLLATE utf8_unicode_ci  NOT NULL DEFAULT '',
    `s_guid`          bigint                               NOT NULL,
    `s_geo`           varchar(50) COLLATE utf8_unicode_ci  NOT NULL DEFAULT '',
    `s_suicids`       int                                           DEFAULT '0',
    `s_suicids_w`     int                                  NOT NULL DEFAULT '0',
    `s_melle`         int                                           DEFAULT '0',
    `s_melle_w`       int                                  NOT NULL DEFAULT '0',
    `s_ping`          int                                           DEFAULT '0',
    `s_ip`            varchar(100) COLLATE utf8_unicode_ci          DEFAULT NULL,
    `s_fps`           int                                           DEFAULT '0',
    `s_playedtime`    int                                  NOT NULL DEFAULT '0',
    `s_playedtime_w`  int                                  NOT NULL DEFAULT '0',
    `s_playedkills`   int                                  NOT NULL DEFAULT '0',
    `s_playedkills_w` int                                  NOT NULL DEFAULT '0',
    `s_playeddeaths`  int                                  NOT NULL DEFAULT '0',
    `s_server`        int                                  NOT NULL DEFAULT '98',
    PRIMARY KEY (`s_guid`, `s_server`) USING BTREE,
    KEY               `s_player` (`s_player`),
    KEY               `s_guid` (`s_guid`) USING BTREE,
    KEY               `s_kills` (`s_kills`),
    KEY               `s_server` (`s_server`),
    KEY               `s_lasttime` (`s_lasttime`),
    KEY               `s_ip` (`s_ip`),
    KEY               `s_skill` (`s_skill`),
    KEY               `s_deaths` (`s_deaths`),
    KEY               `s_kills_w` (`s_kills_w`),
    KEY               `s_deaths_w` (`s_deaths_w`),
    KEY               `s_time` (`s_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
CREATE TABLE `vip`
(
    `guid`    bigint   NOT NULL,
    `name`    varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `days`    smallint NOT NULL                      DEFAULT '0',
    `admin`   tinyint(1) NOT NULL DEFAULT '0',
    `boss`    tinyint(1) DEFAULT '0',
    `date`    datetime NOT NULL                      DEFAULT CURRENT_TIMESTAMP,
    `cheated` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci