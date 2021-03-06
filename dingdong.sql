/*
 Navicat Premium Data Transfer

 Source Server         : 47.101.198.230_3306
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : 47.101.198.230:3306
 Source Schema         : dingdong

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 25/09/2019 19:56:23
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '后台管理用户id',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `introduction` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '介绍',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '头像',
  `roles` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '权限',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '123', 'I am a super administrator', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 'admin', '2019-05-07 15:20:43', '2019-05-07 15:23:34');
INSERT INTO `admin` VALUES (2, 'editor', '123', 'I am a editor', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 'editor', '2019-05-08 23:01:03', '2019-05-08 23:01:31');
INSERT INTO `admin` VALUES (3, 'czx', '123', '\r\nMy name is czx', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 'normal', '2019-05-10 20:02:59', '2019-05-10 20:04:20');

-- ----------------------------
-- Table structure for admin_building
-- ----------------------------
DROP TABLE IF EXISTS `admin_building`;
CREATE TABLE `admin_building`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'admin_buidling关联表',
  `admin_id` int(11) NOT NULL COMMENT '后台用户id',
  `building_id` int(11) NOT NULL COMMENT 'building_id',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of admin_building
-- ----------------------------
INSERT INTO `admin_building` VALUES (1, 2, 3, '2019-05-10 20:04:50', '2019-05-10 20:04:50');
INSERT INTO `admin_building` VALUES (2, 3, 1, '2019-05-10 20:05:07', '2019-05-10 20:05:07');
INSERT INTO `admin_building` VALUES (3, 3, 2, '2019-05-10 20:05:22', '2019-05-10 20:05:22');
INSERT INTO `admin_building` VALUES (4, 3, 4, '2019-05-10 20:05:41', '2019-05-10 20:05:41');
INSERT INTO `admin_building` VALUES (8, 2, 13, '2019-05-11 18:16:07', '2019-05-12 14:42:25');
INSERT INTO `admin_building` VALUES (12, 1, 17, '2019-05-11 18:37:36', '2019-05-11 18:37:36');
INSERT INTO `admin_building` VALUES (18, 3, 23, '2019-05-12 00:42:14', '2019-05-12 00:42:14');
INSERT INTO `admin_building` VALUES (19, 1, 24, '2019-05-12 17:42:34', '2019-05-12 17:42:34');
INSERT INTO `admin_building` VALUES (20, 1, 25, '2019-05-12 20:57:55', '2019-05-12 20:57:55');
INSERT INTO `admin_building` VALUES (21, 1, 26, '2019-05-12 21:37:53', '2019-05-12 21:37:53');

-- ----------------------------
-- Table structure for building
-- ----------------------------
DROP TABLE IF EXISTS `building`;
CREATE TABLE `building`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址',
  `citycode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市代码',
  `city_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所在县市名称',
  `eq_num` int(11) DEFAULT 0 COMMENT '所在地设备数量',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '经度',
  `priority` int(11) DEFAULT 1 COMMENT '热度，1最小',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '具体地址，如东和公寓5幢，图书馆A座，以整个建筑物为单位' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of building
-- ----------------------------
INSERT INTO `building` VALUES (1, '东和公寓5栋', '0571', '杭州市', 9, '30.217871', '120.03187', 2, '2019-04-07 13:50:11', '2019-05-12 15:22:30');
INSERT INTO `building` VALUES (2, '浙江科技学院东图书馆', '0571', '杭州市', 17, '30.22784629566467', '120.03305590799634', 1, '2019-04-07 15:16:06', '2019-05-12 14:55:43');
INSERT INTO `building` VALUES (3, '义乌火车站', '0579', '金华市', 6, '29.384094708973084', '120.04983892590838', 1, '2019-04-07 15:17:23', '2019-05-12 14:55:30');
INSERT INTO `building` VALUES (4, '杭州城西银泰', '0571', '杭州市', 1, '30.30596669357389', '120.11517426724171', 3, '2019-04-12 11:21:52', '2019-05-12 14:55:24');
INSERT INTO `building` VALUES (13, 'editor_building', '888_666', 'editor_free', 4, '120.01123123', '33.66613', 99999, '2019-05-11 18:16:07', '2019-05-12 14:54:54');
INSERT INTO `building` VALUES (17, 'admin的豪华庄园', '007', '杭州市', 5, '34.00001', '120.33333', 99, '2019-05-11 18:37:36', '2019-05-12 14:55:02');
INSERT INTO `building` VALUES (23, '桃花山庄', '0571', '杭州市', 3, '1231.123124', '123.412412', 4, '2019-05-12 00:42:14', '2019-05-15 22:25:55');
INSERT INTO `building` VALUES (24, '洛阳市building', '0379', '洛阳市', 6, '30.123', '123.12312', 3, '2019-05-12 17:42:34', '2019-05-15 23:09:23');
INSERT INTO `building` VALUES (25, '陆家嘴158号', '021', '上海市', 4, '34.000', '123.000', 0, '2019-05-12 20:57:55', '2019-05-15 23:06:36');
INSERT INTO `building` VALUES (26, '外滩--中国银行', '021', '上海市', 0, '30.0000333', '120.3333', 0, '2019-05-12 21:37:53', '2019-05-15 23:06:22');

-- ----------------------------
-- Table structure for building_follow
-- ----------------------------
DROP TABLE IF EXISTS `building_follow`;
CREATE TABLE `building_follow`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'building_follow表的自增主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user的手机号',
  `building_id` int(11) NOT NULL COMMENT 'building的id',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of building_follow
-- ----------------------------
INSERT INTO `building_follow` VALUES (39, 166, '15868133375', 1, '2019-05-12 16:51:48', '2019-05-12 16:51:48');
INSERT INTO `building_follow` VALUES (42, 166, '15868133375', 3, '2019-05-12 18:49:18', '2019-05-12 18:49:18');
INSERT INTO `building_follow` VALUES (43, 136, '15868133375', 1, '2019-05-12 18:49:47', '2019-05-12 18:49:47');
INSERT INTO `building_follow` VALUES (45, 166, '15868133375', 2, '2019-05-12 18:50:50', '2019-05-12 18:50:50');
INSERT INTO `building_follow` VALUES (51, 166, '15868133375', 25, '2019-05-12 21:08:03', '2019-05-12 21:08:03');
INSERT INTO `building_follow` VALUES (53, 166, '15868133375', 26, '2019-05-14 13:52:59', '2019-05-14 13:52:59');
INSERT INTO `building_follow` VALUES (54, 166, '15868133375', 24, '2019-05-14 18:59:08', '2019-05-14 18:59:08');
INSERT INTO `building_follow` VALUES (55, 166, '15868133375', 23, '2019-05-15 22:33:16', '2019-05-15 22:33:16');
INSERT INTO `building_follow` VALUES (56, 166, '15868133375', 4, '2019-05-15 22:33:43', '2019-05-15 22:33:43');

-- ----------------------------
-- Table structure for city
-- ----------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE `city`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '城市id',
  `citycode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市代码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市名称',
  `province` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '所在省名称',
  `priority` int(11) DEFAULT 1 COMMENT '热度，1最小',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of city
-- ----------------------------
INSERT INTO `city` VALUES (1, '0571', '杭州市', '浙江省', 350, '2019-04-07 15:14:53', '2019-05-12 18:48:17');
INSERT INTO `city` VALUES (2, '0579', '金华市', '浙江省', 3, '2019-04-07 15:15:20', '2019-05-12 18:48:36');
INSERT INTO `city` VALUES (46, '021', '上海市', '上海市', 50, '2019-05-15 23:06:07', '2019-05-15 23:08:28');
INSERT INTO `city` VALUES (47, '0379', '洛阳市', '河南省', 30, '2019-05-15 23:08:15', '2019-05-15 23:08:22');

-- ----------------------------
-- Table structure for equipment
-- ----------------------------
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备名称',
  `storey_id` int(11) NOT NULL COMMENT '楼层id',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备所在地址',
  `condition` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '1' COMMENT '状态（1为正常，0为维护中）',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '经度',
  `priority` int(11) DEFAULT 999 COMMENT '优先级，同一楼层比较时使用，1为最大',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of equipment
-- ----------------------------
INSERT INTO `equipment` VALUES (1, '1', 1, NULL, '1', NULL, NULL, 1, '2019-04-07 15:37:06', '2019-04-11 21:54:13');
INSERT INTO `equipment` VALUES (2, '2', 1, NULL, '1', NULL, NULL, 2, '2019-04-07 15:37:06', '2019-04-11 21:54:14');
INSERT INTO `equipment` VALUES (3, '3', 1, NULL, '1', NULL, NULL, 3, '2019-04-07 15:37:06', '2019-04-11 21:54:18');
INSERT INTO `equipment` VALUES (4, '1', 2, NULL, '1', NULL, NULL, 2, '2019-04-07 15:37:06', '2019-04-11 21:54:35');
INSERT INTO `equipment` VALUES (5, '1', 4, '留和路318号', '1', NULL, NULL, 1, '2019-04-09 19:37:57', '2019-04-12 11:36:22');
INSERT INTO `equipment` VALUES (6, '1', 3, '留和路318号', '1', NULL, NULL, 1, '2019-04-09 19:38:09', '2019-04-12 11:36:23');
INSERT INTO `equipment` VALUES (7, '2', 4, '留和路318号', '1', NULL, NULL, 2, '2019-04-09 19:38:31', '2019-04-12 11:36:24');
INSERT INTO `equipment` VALUES (8, '3', 4, '留和路318号', '1', NULL, NULL, 3, '2019-04-09 19:38:48', '2019-04-12 11:36:25');
INSERT INTO `equipment` VALUES (9, '4', 4, '留和路318号', '1', NULL, NULL, 4, '2019-04-12 11:21:05', '2019-04-12 11:36:28');
INSERT INTO `equipment` VALUES (10, '1', 5, '拱墅区萍水街丰潭路380号', '1', NULL, NULL, 1, '2019-04-12 11:32:22', '2019-04-12 11:32:22');
INSERT INTO `equipment` VALUES (11, '1', 7, '留和路318号', '1', NULL, NULL, 1, '2019-04-12 11:35:29', '2019-04-12 11:50:05');
INSERT INTO `equipment` VALUES (12, '2', 7, '留和路318号', '1', NULL, NULL, 2, '2019-04-12 11:35:30', '2019-04-12 11:50:06');
INSERT INTO `equipment` VALUES (13, '3', 7, '留和路318号', '1', NULL, NULL, 3, '2019-04-12 11:35:31', '2019-04-12 11:50:07');
INSERT INTO `equipment` VALUES (14, '4', 7, '留和路318号', '1', NULL, NULL, 4, '2019-04-12 11:35:33', '2019-04-12 11:50:12');
INSERT INTO `equipment` VALUES (15, '1', 6, NULL, '1', NULL, NULL, 1, '2019-04-12 11:50:16', '2019-04-12 11:51:07');
INSERT INTO `equipment` VALUES (16, '1', 8, NULL, '1', NULL, NULL, 1, '2019-04-12 11:50:23', '2019-04-12 11:51:09');
INSERT INTO `equipment` VALUES (17, '2', 8, NULL, '1', NULL, NULL, 2, '2019-04-12 11:50:24', '2019-04-12 11:51:10');
INSERT INTO `equipment` VALUES (18, '3', 8, NULL, '1', NULL, NULL, 3, '2019-04-12 11:50:26', '2019-04-12 11:51:13');
INSERT INTO `equipment` VALUES (19, '4', 8, NULL, '1', NULL, NULL, 4, '2019-04-12 11:51:27', '2019-04-12 11:51:46');
INSERT INTO `equipment` VALUES (20, '5', 8, NULL, '1', NULL, NULL, 5, '2019-04-12 11:51:28', '2019-04-12 11:51:48');
INSERT INTO `equipment` VALUES (21, '6', 8, NULL, '1', NULL, NULL, 6, '2019-04-12 11:51:29', '2019-04-12 11:51:49');
INSERT INTO `equipment` VALUES (22, '7', 8, NULL, '1', NULL, NULL, 7, '2019-04-12 11:51:32', '2019-04-12 11:51:51');
INSERT INTO `equipment` VALUES (23, '1', 9, NULL, '1', NULL, NULL, 1, '2019-04-19 22:14:03', '2019-04-19 22:14:37');
INSERT INTO `equipment` VALUES (24, '2', 9, NULL, '1', NULL, NULL, 2, '2019-04-19 22:14:05', '2019-04-19 22:14:38');
INSERT INTO `equipment` VALUES (25, '3', 9, NULL, '1', NULL, NULL, 3, '2019-04-19 22:14:06', '2019-04-19 22:14:40');
INSERT INTO `equipment` VALUES (26, '4', 9, NULL, '1', NULL, NULL, 4, '2019-04-19 22:14:07', '2019-04-19 22:14:41');
INSERT INTO `equipment` VALUES (27, '5', 10, NULL, '1', NULL, NULL, 1, '2019-04-19 22:14:09', '2019-04-19 22:14:43');
INSERT INTO `equipment` VALUES (28, '6', 10, NULL, '1', NULL, NULL, 2, '2019-04-19 22:14:13', '2019-04-19 22:18:26');
INSERT INTO `equipment` VALUES (29, '1', 11, NULL, '1', NULL, NULL, 1, '2019-04-29 14:33:08', '2019-04-29 14:33:27');
INSERT INTO `equipment` VALUES (30, '2', 11, NULL, '1', NULL, NULL, 2, '2019-04-29 14:33:10', '2019-05-12 16:50:48');
INSERT INTO `equipment` VALUES (31, '3', 12, NULL, '1', NULL, NULL, 3, '2019-04-29 14:33:12', '2019-04-29 14:33:55');
INSERT INTO `equipment` VALUES (32, '1', 12, NULL, '1', NULL, NULL, 1, '2019-04-29 14:33:35', '2019-04-29 14:34:04');
INSERT INTO `equipment` VALUES (33, '2', 12, NULL, '1', NULL, NULL, 2, '2019-04-29 14:33:40', '2019-04-29 14:34:06');
INSERT INTO `equipment` VALUES (34, '1', 17, NULL, '1', NULL, NULL, 1, '2019-05-12 14:20:27', '2019-05-12 14:20:27');
INSERT INTO `equipment` VALUES (35, '2', 17, NULL, '0', NULL, NULL, 2, '2019-05-12 14:24:44', '2019-05-12 14:24:44');
INSERT INTO `equipment` VALUES (36, '3', 17, NULL, '1', NULL, NULL, 3, '2019-05-12 14:28:36', '2019-05-12 14:28:36');
INSERT INTO `equipment` VALUES (38, '1', 20, NULL, '1', NULL, NULL, 1, '2019-05-12 14:36:39', '2019-05-12 14:36:39');
INSERT INTO `equipment` VALUES (39, '2', 20, NULL, '1', NULL, NULL, 2, '2019-05-12 14:36:54', '2019-05-12 14:36:54');
INSERT INTO `equipment` VALUES (40, '1', 21, NULL, '1', NULL, NULL, 1, '2019-05-12 14:37:08', '2019-05-12 14:37:25');
INSERT INTO `equipment` VALUES (41, '2', 21, NULL, '1', NULL, NULL, 2, '2019-05-12 14:37:22', '2019-05-12 14:37:22');
INSERT INTO `equipment` VALUES (42, '3', 20, NULL, '1', NULL, NULL, 3, '2019-05-12 14:45:51', '2019-05-12 14:45:51');
INSERT INTO `equipment` VALUES (43, '1', 22, NULL, '1', NULL, NULL, 1, '2019-05-12 14:53:50', '2019-05-12 14:53:50');
INSERT INTO `equipment` VALUES (44, '2', 22, NULL, '1', NULL, NULL, 2, '2019-05-12 14:53:57', '2019-05-12 14:53:57');
INSERT INTO `equipment` VALUES (45, '3', 22, NULL, '1', NULL, NULL, 3, '2019-05-12 14:54:03', '2019-05-12 14:54:03');
INSERT INTO `equipment` VALUES (46, '4', 22, NULL, '1', NULL, NULL, 4, '2019-05-12 14:54:10', '2019-05-12 14:54:10');
INSERT INTO `equipment` VALUES (49, '1', 26, NULL, '1', NULL, NULL, 1, '2019-05-12 17:45:11', '2019-05-12 17:45:11');
INSERT INTO `equipment` VALUES (50, '1633--007', 27, NULL, '0', NULL, NULL, 1, '2019-05-12 21:00:10', '2019-05-15 22:56:57');
INSERT INTO `equipment` VALUES (52, '3', 27, NULL, '1', NULL, NULL, 3, '2019-05-12 21:05:08', '2019-05-12 21:30:17');
INSERT INTO `equipment` VALUES (54, '1222', 28, NULL, '1', NULL, NULL, 1, '2019-05-12 21:33:35', '2019-05-12 21:33:43');
INSERT INTO `equipment` VALUES (55, '78', 26, NULL, '0', NULL, NULL, 999, '2019-05-13 00:25:34', '2019-05-16 01:49:31');
INSERT INTO `equipment` VALUES (56, '79', 26, NULL, '0', NULL, NULL, 999, '2019-05-13 00:25:53', '2019-05-16 00:49:17');
INSERT INTO `equipment` VALUES (63, '2', 26, NULL, '1', NULL, NULL, 2, '2019-05-14 12:12:18', '2019-05-14 12:12:18');
INSERT INTO `equipment` VALUES (64, '3', 26, NULL, '1', NULL, NULL, 3, '2019-05-14 12:12:55', '2019-05-14 12:12:55');
INSERT INTO `equipment` VALUES (65, '1', 27, NULL, '1', NULL, NULL, 1, '2019-05-14 14:03:43', '2019-05-14 14:03:43');
INSERT INTO `equipment` VALUES (66, '2', 27, NULL, '1', NULL, NULL, 2, '2019-05-14 14:10:09', '2019-05-14 14:10:09');
INSERT INTO `equipment` VALUES (67, '4', 26, NULL, '1', NULL, NULL, 1000, '2019-05-15 16:47:57', '2019-05-16 00:11:42');
INSERT INTO `equipment` VALUES (68, '4', 27, NULL, '0', NULL, NULL, 4, '2019-05-15 22:47:55', '2019-05-15 22:56:24');
INSERT INTO `equipment` VALUES (69, '5', 27, NULL, '1', NULL, NULL, 999, '2019-05-15 23:12:57', '2019-05-15 23:12:57');
INSERT INTO `equipment` VALUES (72, '6', 27, NULL, '1', NULL, NULL, 999, '2019-05-15 23:13:55', '2019-05-15 23:13:55');
INSERT INTO `equipment` VALUES (73, '7', 27, NULL, '1', NULL, NULL, 999, '2019-05-15 23:13:58', '2019-05-15 23:13:58');
INSERT INTO `equipment` VALUES (74, '8', 27, NULL, '1', NULL, NULL, 999, '2019-05-15 23:14:04', '2019-05-15 23:14:04');
INSERT INTO `equipment` VALUES (75, '9', 27, NULL, '0', NULL, NULL, 999, '2019-05-15 23:14:07', '2019-05-16 15:14:14');
INSERT INTO `equipment` VALUES (76, '5', 26, NULL, '1', NULL, NULL, 999, '2019-05-16 00:55:13', '2019-05-16 00:55:13');

-- ----------------------------
-- Table structure for equipment_status
-- ----------------------------
DROP TABLE IF EXISTS `equipment_status`;
CREATE TABLE `equipment_status`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备状态表',
  `start_time` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态开始时间',
  `end_time` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态结束时间',
  `eq_id` int(11) NOT NULL COMMENT '设备id',
  `eq_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备名称',
  `status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '使用情况（1为使用中， 0 为空闲,  2为维护中）',
  `storey_id` int(11) DEFAULT NULL COMMENT 'storey_id',
  `building_id` int(11) DEFAULT NULL COMMENT 'building_id',
  `citycode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'citycode',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_building_id`(`building_id`) USING BTREE,
  INDEX `index_storey_id`(`storey_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151647 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备状态记录表，记录设备几时几分到几时几分的状态' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for storey
-- ----------------------------
DROP TABLE IF EXISTS `storey`;
CREATE TABLE `storey`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '楼层表id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '楼层名称',
  `building_id` int(11) NOT NULL COMMENT '所在建筑id',
  `floor` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '楼层，如“F1”（地上一层）,“B1”（地下一层）',
  `gender` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '性别类型，默认为公用（0），男（1），女（2）',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '经度',
  `eq_num` int(11) DEFAULT 0 COMMENT '所在楼层设备数量',
  `priority` int(11) DEFAULT 999 COMMENT '优先级，同一楼层比较时使用，1为最大',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '楼层，如图书馆A座的2楼' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of storey
-- ----------------------------
INSERT INTO `storey` VALUES (1, '3层【听雨阁】', 1, 'F3', '0', '30.217871', '120.03187', 3, 4, '2019-04-07 15:33:04', '2019-05-12 15:25:44');
INSERT INTO `storey` VALUES (2, '2层【美人鱼】', 1, 'F2', '0', '30.217871', '120.03187', 1, 1, '2019-04-07 15:33:34', '2019-04-29 16:11:07');
INSERT INTO `storey` VALUES (3, '5层【闻天轩】', 2, 'F5', '0', '30.22784629566467', '120.03305590799634', 1, 5, '2019-04-07 15:34:17', '2019-05-12 14:50:48');
INSERT INTO `storey` VALUES (4, '4层【望月楼】', 2, 'F4', '0', '30.22784629566467', '120.03305590799634', 4, 4, '2019-04-09 19:36:42', '2019-05-15 19:47:28');
INSERT INTO `storey` VALUES (5, '2层【南】', 4, 'F2', '0', '30.30596669357389', '120.11517426724171', 1, 3, '2019-04-12 11:30:26', '2019-05-12 14:50:05');
INSERT INTO `storey` VALUES (6, '3层【赤壁之战】', 2, 'F3', '0', '30.22784629566467', '120.03305590799634', 1, 3, '2019-04-12 11:33:41', '2019-05-12 14:49:29');
INSERT INTO `storey` VALUES (7, '1层【交易大厅】', 2, 'F1', '0', '30.22784629566467', '120.03305590799634', 4, 1, '2019-04-12 11:34:53', '2019-05-12 14:49:13');
INSERT INTO `storey` VALUES (8, '2层【技术中心】', 2, 'F2', '0', '30.22784629566467', '120.03305590799634', 7, 2, '2019-04-12 11:35:19', '2019-05-12 14:48:03');
INSERT INTO `storey` VALUES (9, '4号候车厅【南侧】', 3, 'F2', '0', '29.384094708973085', '120.04983892590838', 4, 1, '2019-04-19 22:13:20', '2019-05-12 14:48:42');
INSERT INTO `storey` VALUES (10, '2号候车厅【东边】', 3, 'F1', '0', '29.384094708973085', '120.04983892590838', 2, 2, '2019-04-19 22:13:24', '2019-05-12 14:47:35');
INSERT INTO `storey` VALUES (11, '2层【男】', 1, 'F2', '1', '30.217871', '120.03187', 2, 2, '2019-04-29 14:18:56', '2019-05-12 16:51:33');
INSERT INTO `storey` VALUES (12, '2层【女】', 1, 'F2', '2', '30.217871', '120.03187', 3, 3, '2019-04-29 14:31:53', '2019-05-12 14:51:48');
INSERT INTO `storey` VALUES (17, '山庄1号', 23, 'F2', '2', '34.1123', '120.451234', 3, 0, '2019-05-12 00:44:30', '2019-05-12 14:47:12');
INSERT INTO `storey` VALUES (20, '豪华庄园A座', 17, 'F1', '0', '34.0000', '120.0000', 3, 1, '2019-05-12 14:35:10', '2019-05-12 14:45:59');
INSERT INTO `storey` VALUES (21, '豪华庄园B座', 17, 'F2', '2', '34.00001', '120.0034', 2, 3, '2019-05-12 14:35:47', '2019-05-12 14:44:33');
INSERT INTO `storey` VALUES (22, 'editor1号', 13, 'F3', '1', '34.000', '120.4444', 4, 1, '2019-05-12 14:53:23', '2019-05-12 14:54:24');
INSERT INTO `storey` VALUES (26, '洛阳市storey', 24, 'F2', '1', '30.0000', '120.000', 6, 0, '2019-05-12 17:44:51', '2019-05-15 23:09:52');
INSERT INTO `storey` VALUES (27, '007房', 25, 'F1', '0', '32.00000', '120.0000', 5, 0, '2019-05-12 20:59:40', '2019-05-12 20:59:40');
INSERT INTO `storey` VALUES (28, '008房', 25, 'F3', '2', '34.0003', '120.0003', 1, 5, '2019-05-12 21:33:07', '2019-05-12 21:39:56');

-- ----------------------------
-- Table structure for storey_occupancy_rate
-- ----------------------------
DROP TABLE IF EXISTS `storey_occupancy_rate`;
CREATE TABLE `storey_occupancy_rate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '占有率表id',
  `building_id` int(11) NOT NULL COMMENT 'buildingId',
  `storey_id` int(11) NOT NULL COMMENT 'storeyId',
  `total_eq_num` int(11) DEFAULT NULL COMMENT '总共的设备数量',
  `use_eq_num` int(11) DEFAULT NULL COMMENT '占用中的设备数量',
  `free_eq_num` int(11) DEFAULT NULL COMMENT '空闲的设备数量',
  `abnormal_eq_num` int(11) DEFAULT 0 COMMENT '不正常的设备数量',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_building_id`(`building_id`) USING BTREE,
  INDEX `index_storey_id`(`storey_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 303171 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '占有率表，统计building下的storey的占有率' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for storey_use_count
-- ----------------------------
DROP TABLE IF EXISTS `storey_use_count`;
CREATE TABLE `storey_use_count`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `start_time` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '时间点，如果是00:00:00,代表这条数据记录的时间段是00:00:00~01:00:00',
  `building_id` int(11) NOT NULL COMMENT 'building_id',
  `storey_id` int(11) NOT NULL COMMENT 'storey_id',
  `storey_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '洗手间名称',
  `use_count` int(11) DEFAULT NULL COMMENT '数量，该时间点内该storey使用的人数',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_building_id`(`building_id`) USING BTREE,
  INDEX `index_start_time`(`start_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10141 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of storey_use_count
-- ----------------------------
INSERT INTO `storey_use_count` VALUES (4747, '2019-05-16 00:00:00', 1, 1, '3层【听雨阁】', 29, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4748, '2019-05-16 00:00:00', 1, 2, '2层【美人鱼】', 10, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4749, '2019-05-16 00:00:00', 2, 3, '5层【闻天轩】', 9, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4750, '2019-05-16 00:00:00', 2, 4, '4层【望月楼】', 40, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4751, '2019-05-16 00:00:00', 4, 5, '2层【南】', 11, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4752, '2019-05-16 00:00:00', 2, 6, '3层【赤壁之战】', 7, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4753, '2019-05-16 00:00:00', 2, 7, '1层【交易大厅】', 44, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4754, '2019-05-16 00:00:00', 2, 8, '2层【技术中心】', 72, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4755, '2019-05-16 00:00:00', 3, 9, '4号候车厅【南侧】', 47, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4756, '2019-05-16 00:00:00', 3, 10, '2号候车厅【东边】', 19, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4757, '2019-05-16 00:00:00', 1, 11, '2层【男】', 22, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4758, '2019-05-16 00:00:00', 1, 12, '2层【女】', 31, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4759, '2019-05-16 00:00:00', 23, 17, '山庄1号', 31, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4760, '2019-05-16 00:00:00', 17, 20, '豪华庄园A座', 31, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4761, '2019-05-16 00:00:00', 17, 21, '豪华庄园B座', 18, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4762, '2019-05-16 00:00:00', 13, 22, 'editor1号', 42, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4763, '2019-05-16 00:00:00', 24, 26, '洛阳市storey', 65, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4764, '2019-05-16 00:00:00', 25, 27, '007房', 99, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (4765, '2019-05-16 00:00:00', 25, 28, '008房', 11, '2019-05-16 01:03:00', '2019-05-16 01:03:00');
INSERT INTO `storey_use_count` VALUES (5013, '2019-05-16 01:00:00', 1, 1, '3层【听雨阁】', 57, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5014, '2019-05-16 01:00:00', 1, 2, '2层【美人鱼】', 22, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5015, '2019-05-16 01:00:00', 2, 3, '5层【闻天轩】', 19, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5016, '2019-05-16 01:00:00', 2, 4, '4层【望月楼】', 75, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5017, '2019-05-16 01:00:00', 4, 5, '2层【南】', 19, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5018, '2019-05-16 01:00:00', 2, 6, '3层【赤壁之战】', 19, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5019, '2019-05-16 01:00:00', 2, 7, '1层【交易大厅】', 73, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5020, '2019-05-16 01:00:00', 2, 8, '2层【技术中心】', 130, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5021, '2019-05-16 01:00:00', 3, 9, '4号候车厅【南侧】', 73, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5022, '2019-05-16 01:00:00', 3, 10, '2号候车厅【东边】', 37, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5023, '2019-05-16 01:00:00', 1, 11, '2层【男】', 39, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5024, '2019-05-16 01:00:00', 1, 12, '2层【女】', 58, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5025, '2019-05-16 01:00:00', 23, 17, '山庄1号', 59, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5026, '2019-05-16 01:00:00', 17, 20, '豪华庄园A座', 60, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5027, '2019-05-16 01:00:00', 17, 21, '豪华庄园B座', 35, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5028, '2019-05-16 01:00:00', 13, 22, 'editor1号', 79, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5029, '2019-05-16 01:00:00', 24, 26, '洛阳市storey', 130, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5030, '2019-05-16 01:00:00', 25, 27, '007房', 182, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5031, '2019-05-16 01:00:00', 25, 28, '008房', 21, '2019-05-16 02:03:00', '2019-05-16 02:03:00');
INSERT INTO `storey_use_count` VALUES (5411, '2019-05-16 02:00:00', 1, 1, '3层【听雨阁】', 95, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5412, '2019-05-16 02:00:00', 1, 2, '2层【美人鱼】', 34, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5413, '2019-05-16 02:00:00', 2, 3, '5层【闻天轩】', 32, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5414, '2019-05-16 02:00:00', 2, 4, '4层【望月楼】', 118, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5415, '2019-05-16 02:00:00', 4, 5, '2层【南】', 31, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5416, '2019-05-16 02:00:00', 2, 6, '3层【赤壁之战】', 32, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5417, '2019-05-16 02:00:00', 2, 7, '1层【交易大厅】', 116, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5418, '2019-05-16 02:00:00', 2, 8, '2层【技术中心】', 207, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5419, '2019-05-16 02:00:00', 3, 9, '4号候车厅【南侧】', 118, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5420, '2019-05-16 02:00:00', 3, 10, '2号候车厅【东边】', 57, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5421, '2019-05-16 02:00:00', 1, 11, '2层【男】', 56, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5422, '2019-05-16 02:00:00', 1, 12, '2层【女】', 90, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5423, '2019-05-16 02:00:00', 23, 17, '山庄1号', 93, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5424, '2019-05-16 02:00:00', 17, 20, '豪华庄园A座', 87, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5425, '2019-05-16 02:00:00', 17, 21, '豪华庄园B座', 63, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5426, '2019-05-16 02:00:00', 13, 22, 'editor1号', 119, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5427, '2019-05-16 02:00:00', 24, 26, '洛阳市storey', 207, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5428, '2019-05-16 02:00:00', 25, 27, '007房', 295, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5429, '2019-05-16 02:00:00', 25, 28, '008房', 30, '2019-05-16 03:03:00', '2019-05-16 03:03:00');
INSERT INTO `storey_use_count` VALUES (5810, '2019-05-16 03:00:00', 1, 1, '3层【听雨阁】', 86, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5811, '2019-05-16 03:00:00', 1, 2, '2层【美人鱼】', 30, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5812, '2019-05-16 03:00:00', 2, 3, '5层【闻天轩】', 30, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5813, '2019-05-16 03:00:00', 2, 4, '4层【望月楼】', 121, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5814, '2019-05-16 03:00:00', 4, 5, '2层【南】', 29, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5815, '2019-05-16 03:00:00', 2, 6, '3层【赤壁之战】', 30, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5816, '2019-05-16 03:00:00', 2, 7, '1层【交易大厅】', 121, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5817, '2019-05-16 03:00:00', 2, 8, '2层【技术中心】', 222, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5818, '2019-05-16 03:00:00', 3, 9, '4号候车厅【南侧】', 123, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5819, '2019-05-16 03:00:00', 3, 10, '2号候车厅【东边】', 61, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5820, '2019-05-16 03:00:00', 1, 11, '2层【男】', 60, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5821, '2019-05-16 03:00:00', 1, 12, '2层【女】', 95, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5822, '2019-05-16 03:00:00', 23, 17, '山庄1号', 92, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5823, '2019-05-16 03:00:00', 17, 20, '豪华庄园A座', 98, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5824, '2019-05-16 03:00:00', 17, 21, '豪华庄园B座', 64, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5825, '2019-05-16 03:00:00', 13, 22, 'editor1号', 124, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5826, '2019-05-16 03:00:00', 24, 26, '洛阳市storey', 210, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5827, '2019-05-16 03:00:00', 25, 27, '007房', 303, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (5828, '2019-05-16 03:00:00', 25, 28, '008房', 30, '2019-05-16 04:03:00', '2019-05-16 04:03:00');
INSERT INTO `storey_use_count` VALUES (6209, '2019-05-16 04:00:00', 1, 1, '3层【听雨阁】', 97, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6210, '2019-05-16 04:00:00', 1, 2, '2层【美人鱼】', 34, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6211, '2019-05-16 04:00:00', 2, 3, '5层【闻天轩】', 31, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6212, '2019-05-16 04:00:00', 2, 4, '4层【望月楼】', 122, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6213, '2019-05-16 04:00:00', 4, 5, '2层【南】', 31, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6214, '2019-05-16 04:00:00', 2, 6, '3层【赤壁之战】', 32, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6215, '2019-05-16 04:00:00', 2, 7, '1层【交易大厅】', 121, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6216, '2019-05-16 04:00:00', 2, 8, '2层【技术中心】', 218, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6217, '2019-05-16 04:00:00', 3, 9, '4号候车厅【南侧】', 126, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6218, '2019-05-16 04:00:00', 3, 10, '2号候车厅【东边】', 54, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6219, '2019-05-16 04:00:00', 1, 11, '2层【男】', 64, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6220, '2019-05-16 04:00:00', 1, 12, '2层【女】', 89, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6221, '2019-05-16 04:00:00', 23, 17, '山庄1号', 95, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6222, '2019-05-16 04:00:00', 17, 20, '豪华庄园A座', 93, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6223, '2019-05-16 04:00:00', 17, 21, '豪华庄园B座', 68, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6224, '2019-05-16 04:00:00', 13, 22, 'editor1号', 119, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6225, '2019-05-16 04:00:00', 24, 26, '洛阳市storey', 221, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6226, '2019-05-16 04:00:00', 25, 27, '007房', 314, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6227, '2019-05-16 04:00:00', 25, 28, '008房', 28, '2019-05-16 05:03:00', '2019-05-16 05:03:00');
INSERT INTO `storey_use_count` VALUES (6608, '2019-05-16 05:00:00', 1, 1, '3层【听雨阁】', 95, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6609, '2019-05-16 05:00:00', 1, 2, '2层【美人鱼】', 33, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6610, '2019-05-16 05:00:00', 2, 3, '5层【闻天轩】', 32, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6611, '2019-05-16 05:00:00', 2, 4, '4层【望月楼】', 119, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6612, '2019-05-16 05:00:00', 4, 5, '2层【南】', 32, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6613, '2019-05-16 05:00:00', 2, 6, '3层【赤壁之战】', 30, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6614, '2019-05-16 05:00:00', 2, 7, '1层【交易大厅】', 118, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6615, '2019-05-16 05:00:00', 2, 8, '2层【技术中心】', 217, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6616, '2019-05-16 05:00:00', 3, 9, '4号候车厅【南侧】', 124, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6617, '2019-05-16 05:00:00', 3, 10, '2号候车厅【东边】', 61, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6618, '2019-05-16 05:00:00', 1, 11, '2层【男】', 62, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6619, '2019-05-16 05:00:00', 1, 12, '2层【女】', 89, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6620, '2019-05-16 05:00:00', 23, 17, '山庄1号', 87, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6621, '2019-05-16 05:00:00', 17, 20, '豪华庄园A座', 94, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6622, '2019-05-16 05:00:00', 17, 21, '豪华庄园B座', 59, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6623, '2019-05-16 05:00:00', 13, 22, 'editor1号', 119, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6624, '2019-05-16 05:00:00', 24, 26, '洛阳市storey', 213, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6625, '2019-05-16 05:00:00', 25, 27, '007房', 303, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (6626, '2019-05-16 05:00:00', 25, 28, '008房', 32, '2019-05-16 06:03:00', '2019-05-16 06:03:00');
INSERT INTO `storey_use_count` VALUES (7007, '2019-05-16 06:00:00', 1, 1, '3层【听雨阁】', 90, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7008, '2019-05-16 06:00:00', 1, 2, '2层【美人鱼】', 32, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7009, '2019-05-16 06:00:00', 2, 3, '5层【闻天轩】', 26, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7010, '2019-05-16 06:00:00', 2, 4, '4层【望月楼】', 124, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7011, '2019-05-16 06:00:00', 4, 5, '2层【南】', 31, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7012, '2019-05-16 06:00:00', 2, 6, '3层【赤壁之战】', 28, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7013, '2019-05-16 06:00:00', 2, 7, '1层【交易大厅】', 123, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7014, '2019-05-16 06:00:00', 2, 8, '2层【技术中心】', 215, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7015, '2019-05-16 06:00:00', 3, 9, '4号候车厅【南侧】', 121, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7016, '2019-05-16 06:00:00', 3, 10, '2号候车厅【东边】', 59, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7017, '2019-05-16 06:00:00', 1, 11, '2层【男】', 63, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7018, '2019-05-16 06:00:00', 1, 12, '2层【女】', 95, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7019, '2019-05-16 06:00:00', 23, 17, '山庄1号', 92, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7020, '2019-05-16 06:00:00', 17, 20, '豪华庄园A座', 91, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7021, '2019-05-16 06:00:00', 17, 21, '豪华庄园B座', 61, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7022, '2019-05-16 06:00:00', 13, 22, 'editor1号', 123, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7023, '2019-05-16 06:00:00', 24, 26, '洛阳市storey', 220, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7024, '2019-05-16 06:00:00', 25, 27, '007房', 307, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7025, '2019-05-16 06:00:00', 25, 28, '008房', 30, '2019-05-16 07:03:00', '2019-05-16 07:03:00');
INSERT INTO `storey_use_count` VALUES (7406, '2019-05-16 07:00:00', 1, 1, '3层【听雨阁】', 87, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7407, '2019-05-16 07:00:00', 1, 2, '2层【美人鱼】', 30, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7408, '2019-05-16 07:00:00', 2, 3, '5层【闻天轩】', 30, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7409, '2019-05-16 07:00:00', 2, 4, '4层【望月楼】', 122, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7410, '2019-05-16 07:00:00', 4, 5, '2层【南】', 34, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7411, '2019-05-16 07:00:00', 2, 6, '3层【赤壁之战】', 30, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7412, '2019-05-16 07:00:00', 2, 7, '1层【交易大厅】', 122, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7413, '2019-05-16 07:00:00', 2, 8, '2层【技术中心】', 202, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7414, '2019-05-16 07:00:00', 3, 9, '4号候车厅【南侧】', 118, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7415, '2019-05-16 07:00:00', 3, 10, '2号候车厅【东边】', 60, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7416, '2019-05-16 07:00:00', 1, 11, '2层【男】', 66, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7417, '2019-05-16 07:00:00', 1, 12, '2层【女】', 92, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7418, '2019-05-16 07:00:00', 23, 17, '山庄1号', 94, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7419, '2019-05-16 07:00:00', 17, 20, '豪华庄园A座', 89, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7420, '2019-05-16 07:00:00', 17, 21, '豪华庄园B座', 61, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7421, '2019-05-16 07:00:00', 13, 22, 'editor1号', 125, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7422, '2019-05-16 07:00:00', 24, 26, '洛阳市storey', 215, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7423, '2019-05-16 07:00:00', 25, 27, '007房', 307, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7424, '2019-05-16 07:00:00', 25, 28, '008房', 31, '2019-05-16 08:03:00', '2019-05-16 08:03:00');
INSERT INTO `storey_use_count` VALUES (7805, '2019-05-16 08:00:00', 1, 1, '3层【听雨阁】', 88, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7806, '2019-05-16 08:00:00', 1, 2, '2层【美人鱼】', 28, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7807, '2019-05-16 08:00:00', 2, 3, '5层【闻天轩】', 32, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7808, '2019-05-16 08:00:00', 2, 4, '4层【望月楼】', 120, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7809, '2019-05-16 08:00:00', 4, 5, '2层【南】', 32, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7810, '2019-05-16 08:00:00', 2, 6, '3层【赤壁之战】', 29, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7811, '2019-05-16 08:00:00', 2, 7, '1层【交易大厅】', 123, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7812, '2019-05-16 08:00:00', 2, 8, '2层【技术中心】', 216, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7813, '2019-05-16 08:00:00', 3, 9, '4号候车厅【南侧】', 119, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7814, '2019-05-16 08:00:00', 3, 10, '2号候车厅【东边】', 57, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7815, '2019-05-16 08:00:00', 1, 11, '2层【男】', 60, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7816, '2019-05-16 08:00:00', 1, 12, '2层【女】', 88, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7817, '2019-05-16 08:00:00', 23, 17, '山庄1号', 88, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7818, '2019-05-16 08:00:00', 17, 20, '豪华庄园A座', 92, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7819, '2019-05-16 08:00:00', 17, 21, '豪华庄园B座', 59, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7820, '2019-05-16 08:00:00', 13, 22, 'editor1号', 124, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7821, '2019-05-16 08:00:00', 24, 26, '洛阳市storey', 203, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7822, '2019-05-16 08:00:00', 25, 27, '007房', 303, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (7823, '2019-05-16 08:00:00', 25, 28, '008房', 34, '2019-05-16 09:03:00', '2019-05-16 09:03:00');
INSERT INTO `storey_use_count` VALUES (8204, '2019-05-16 09:00:00', 1, 1, '3层【听雨阁】', 92, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8205, '2019-05-16 09:00:00', 1, 2, '2层【美人鱼】', 30, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8206, '2019-05-16 09:00:00', 2, 3, '5层【闻天轩】', 30, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8207, '2019-05-16 09:00:00', 2, 4, '4层【望月楼】', 128, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8208, '2019-05-16 09:00:00', 4, 5, '2层【南】', 33, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8209, '2019-05-16 09:00:00', 2, 6, '3层【赤壁之战】', 29, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8210, '2019-05-16 09:00:00', 2, 7, '1层【交易大厅】', 116, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8211, '2019-05-16 09:00:00', 2, 8, '2层【技术中心】', 214, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8212, '2019-05-16 09:00:00', 3, 9, '4号候车厅【南侧】', 117, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8213, '2019-05-16 09:00:00', 3, 10, '2号候车厅【东边】', 62, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8214, '2019-05-16 09:00:00', 1, 11, '2层【男】', 62, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8215, '2019-05-16 09:00:00', 1, 12, '2层【女】', 86, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8216, '2019-05-16 09:00:00', 23, 17, '山庄1号', 95, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8217, '2019-05-16 09:00:00', 17, 20, '豪华庄园A座', 92, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8218, '2019-05-16 09:00:00', 17, 21, '豪华庄园B座', 56, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8219, '2019-05-16 09:00:00', 13, 22, 'editor1号', 119, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8220, '2019-05-16 09:00:00', 24, 26, '洛阳市storey', 215, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8221, '2019-05-16 09:00:00', 25, 27, '007房', 297, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8222, '2019-05-16 09:00:00', 25, 28, '008房', 29, '2019-05-16 10:03:00', '2019-05-16 10:03:00');
INSERT INTO `storey_use_count` VALUES (8603, '2019-05-16 10:00:00', 1, 1, '3层【听雨阁】', 92, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8604, '2019-05-16 10:00:00', 1, 2, '2层【美人鱼】', 32, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8605, '2019-05-16 10:00:00', 2, 3, '5层【闻天轩】', 28, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8606, '2019-05-16 10:00:00', 2, 4, '4层【望月楼】', 122, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8607, '2019-05-16 10:00:00', 4, 5, '2层【南】', 31, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8608, '2019-05-16 10:00:00', 2, 6, '3层【赤壁之战】', 33, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8609, '2019-05-16 10:00:00', 2, 7, '1层【交易大厅】', 121, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8610, '2019-05-16 10:00:00', 2, 8, '2层【技术中心】', 216, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8611, '2019-05-16 10:00:00', 3, 9, '4号候车厅【南侧】', 120, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8612, '2019-05-16 10:00:00', 3, 10, '2号候车厅【东边】', 62, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8613, '2019-05-16 10:00:00', 1, 11, '2层【男】', 61, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8614, '2019-05-16 10:00:00', 1, 12, '2层【女】', 90, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8615, '2019-05-16 10:00:00', 23, 17, '山庄1号', 95, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8616, '2019-05-16 10:00:00', 17, 20, '豪华庄园A座', 97, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8617, '2019-05-16 10:00:00', 17, 21, '豪华庄园B座', 65, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8618, '2019-05-16 10:00:00', 13, 22, 'editor1号', 128, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8619, '2019-05-16 10:00:00', 24, 26, '洛阳市storey', 207, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8620, '2019-05-16 10:00:00', 25, 27, '007房', 310, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (8621, '2019-05-16 10:00:00', 25, 28, '008房', 30, '2019-05-16 11:03:00', '2019-05-16 11:03:00');
INSERT INTO `storey_use_count` VALUES (9002, '2019-05-16 11:00:00', 1, 1, '3层【听雨阁】', 94, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9003, '2019-05-16 11:00:00', 1, 2, '2层【美人鱼】', 30, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9004, '2019-05-16 11:00:00', 2, 3, '5层【闻天轩】', 30, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9005, '2019-05-16 11:00:00', 2, 4, '4层【望月楼】', 121, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9006, '2019-05-16 11:00:00', 4, 5, '2层【南】', 33, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9007, '2019-05-16 11:00:00', 2, 6, '3层【赤壁之战】', 32, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9008, '2019-05-16 11:00:00', 2, 7, '1层【交易大厅】', 122, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9009, '2019-05-16 11:00:00', 2, 8, '2层【技术中心】', 214, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9010, '2019-05-16 11:00:00', 3, 9, '4号候车厅【南侧】', 125, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9011, '2019-05-16 11:00:00', 3, 10, '2号候车厅【东边】', 59, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9012, '2019-05-16 11:00:00', 1, 11, '2层【男】', 65, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9013, '2019-05-16 11:00:00', 1, 12, '2层【女】', 92, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9014, '2019-05-16 11:00:00', 23, 17, '山庄1号', 88, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9015, '2019-05-16 11:00:00', 17, 20, '豪华庄园A座', 97, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9016, '2019-05-16 11:00:00', 17, 21, '豪华庄园B座', 59, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9017, '2019-05-16 11:00:00', 13, 22, 'editor1号', 125, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9018, '2019-05-16 11:00:00', 24, 26, '洛阳市storey', 213, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9019, '2019-05-16 11:00:00', 25, 27, '007房', 308, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9020, '2019-05-16 11:00:00', 25, 28, '008房', 35, '2019-05-16 12:03:00', '2019-05-16 12:03:00');
INSERT INTO `storey_use_count` VALUES (9401, '2019-05-16 12:00:00', 1, 1, '3层【听雨阁】', 92, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9402, '2019-05-16 12:00:00', 1, 2, '2层【美人鱼】', 28, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9403, '2019-05-16 12:00:00', 2, 3, '5层【闻天轩】', 31, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9404, '2019-05-16 12:00:00', 2, 4, '4层【望月楼】', 125, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9405, '2019-05-16 12:00:00', 4, 5, '2层【南】', 33, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9406, '2019-05-16 12:00:00', 2, 6, '3层【赤壁之战】', 32, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9407, '2019-05-16 12:00:00', 2, 7, '1层【交易大厅】', 123, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9408, '2019-05-16 12:00:00', 2, 8, '2层【技术中心】', 218, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9409, '2019-05-16 12:00:00', 3, 9, '4号候车厅【南侧】', 123, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9410, '2019-05-16 12:00:00', 3, 10, '2号候车厅【东边】', 62, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9411, '2019-05-16 12:00:00', 1, 11, '2层【男】', 60, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9412, '2019-05-16 12:00:00', 1, 12, '2层【女】', 94, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9413, '2019-05-16 12:00:00', 23, 17, '山庄1号', 85, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9414, '2019-05-16 12:00:00', 17, 20, '豪华庄园A座', 91, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9415, '2019-05-16 12:00:00', 17, 21, '豪华庄园B座', 66, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9416, '2019-05-16 12:00:00', 13, 22, 'editor1号', 114, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9417, '2019-05-16 12:00:00', 24, 26, '洛阳市storey', 215, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9418, '2019-05-16 12:00:00', 25, 27, '007房', 293, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9419, '2019-05-16 12:00:00', 25, 28, '008房', 26, '2019-05-16 13:03:00', '2019-05-16 13:03:00');
INSERT INTO `storey_use_count` VALUES (9553, '2019-05-16 13:00:00', 1, 1, '3层【听雨阁】', 35, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9554, '2019-05-16 13:00:00', 1, 2, '2层【美人鱼】', 14, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9555, '2019-05-16 13:00:00', 2, 3, '5层【闻天轩】', 12, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9556, '2019-05-16 13:00:00', 2, 4, '4层【望月楼】', 45, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9557, '2019-05-16 13:00:00', 4, 5, '2层【南】', 12, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9558, '2019-05-16 13:00:00', 2, 6, '3层【赤壁之战】', 13, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9559, '2019-05-16 13:00:00', 2, 7, '1层【交易大厅】', 47, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9560, '2019-05-16 13:00:00', 2, 8, '2层【技术中心】', 79, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9561, '2019-05-16 13:00:00', 3, 9, '4号候车厅【南侧】', 48, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9562, '2019-05-16 13:00:00', 3, 10, '2号候车厅【东边】', 24, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9563, '2019-05-16 13:00:00', 1, 11, '2层【男】', 22, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9564, '2019-05-16 13:00:00', 1, 12, '2层【女】', 35, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9565, '2019-05-16 13:00:00', 23, 17, '山庄1号', 36, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9566, '2019-05-16 13:00:00', 17, 20, '豪华庄园A座', 37, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9567, '2019-05-16 13:00:00', 17, 21, '豪华庄园B座', 26, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9568, '2019-05-16 13:00:00', 13, 22, 'editor1号', 47, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9569, '2019-05-16 13:00:00', 24, 26, '洛阳市storey', 75, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9570, '2019-05-16 13:00:00', 25, 27, '007房', 116, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9571, '2019-05-16 13:00:00', 25, 28, '008房', 11, '2019-05-16 14:12:00', '2019-05-16 14:12:00');
INSERT INTO `storey_use_count` VALUES (9761, '2019-05-16 14:00:00', 1, 1, '3层【听雨阁】', 34, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9762, '2019-05-16 14:00:00', 1, 2, '2层【美人鱼】', 11, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9763, '2019-05-16 14:00:00', 2, 3, '5层【闻天轩】', 9, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9764, '2019-05-16 14:00:00', 2, 4, '4层【望月楼】', 44, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9765, '2019-05-16 14:00:00', 4, 5, '2层【南】', 13, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9766, '2019-05-16 14:00:00', 2, 6, '3层【赤壁之战】', 11, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9767, '2019-05-16 14:00:00', 2, 7, '1层【交易大厅】', 51, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9768, '2019-05-16 14:00:00', 2, 8, '2层【技术中心】', 82, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9769, '2019-05-16 14:00:00', 3, 9, '4号候车厅【南侧】', 49, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9770, '2019-05-16 14:00:00', 3, 10, '2号候车厅【东边】', 25, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9771, '2019-05-16 14:00:00', 1, 11, '2层【男】', 26, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9772, '2019-05-16 14:00:00', 1, 12, '2层【女】', 34, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9773, '2019-05-16 14:00:00', 23, 17, '山庄1号', 38, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9774, '2019-05-16 14:00:00', 17, 20, '豪华庄园A座', 38, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9775, '2019-05-16 14:00:00', 17, 21, '豪华庄园B座', 23, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9776, '2019-05-16 14:00:00', 13, 22, 'editor1号', 48, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9777, '2019-05-16 14:00:00', 24, 26, '洛阳市storey', 83, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9778, '2019-05-16 14:00:00', 25, 27, '007房', 125, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (9779, '2019-05-16 14:00:00', 25, 28, '008房', 12, '2019-05-16 15:03:00', '2019-05-16 15:03:00');
INSERT INTO `storey_use_count` VALUES (10122, '2019-05-16 15:00:00', 1, 1, '3层【听雨阁】', 86, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10123, '2019-05-16 15:00:00', 1, 2, '2层【美人鱼】', 27, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10124, '2019-05-16 15:00:00', 2, 3, '5层【闻天轩】', 30, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10125, '2019-05-16 15:00:00', 2, 4, '4层【望月楼】', 126, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10126, '2019-05-16 15:00:00', 4, 5, '2层【南】', 30, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10127, '2019-05-16 15:00:00', 2, 6, '3层【赤壁之战】', 28, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10128, '2019-05-16 15:00:00', 2, 7, '1层【交易大厅】', 113, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10129, '2019-05-16 15:00:00', 2, 8, '2层【技术中心】', 199, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10130, '2019-05-16 15:00:00', 3, 9, '4号候车厅【南侧】', 111, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10131, '2019-05-16 15:00:00', 3, 10, '2号候车厅【东边】', 56, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10132, '2019-05-16 15:00:00', 1, 11, '2层【男】', 57, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10133, '2019-05-16 15:00:00', 1, 12, '2层【女】', 88, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10134, '2019-05-16 15:00:00', 23, 17, '山庄1号', 89, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10135, '2019-05-16 15:00:00', 17, 20, '豪华庄园A座', 81, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10136, '2019-05-16 15:00:00', 17, 21, '豪华庄园B座', 57, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10137, '2019-05-16 15:00:00', 13, 22, 'editor1号', 114, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10138, '2019-05-16 15:00:00', 24, 26, '洛阳市storey', 207, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10139, '2019-05-16 15:00:00', 25, 27, '007房', 286, '2019-05-16 15:57:00', '2019-05-16 15:57:00');
INSERT INTO `storey_use_count` VALUES (10140, '2019-05-16 15:00:00', 25, 28, '008房', 30, '2019-05-16 15:57:00', '2019-05-16 15:57:00');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '手机号',
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `gender` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '性别，男（1），女（2），未知（0）',
  `vip` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '是否为vip，默认为0（非vip），1（vip）',
  `age` int(11) DEFAULT 0 COMMENT '年龄',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (144, '15868153375', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:14:09', '2019-05-06 16:14:09');
INSERT INTO `user` VALUES (145, '15868153671', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:03');
INSERT INTO `user` VALUES (146, '15868153672', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:06');
INSERT INTO `user` VALUES (147, '15868153673', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:10');
INSERT INTO `user` VALUES (148, '15868153674', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:13');
INSERT INTO `user` VALUES (149, '15868153676', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:17');
INSERT INTO `user` VALUES (150, '15868153677', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:24');
INSERT INTO `user` VALUES (151, '15868153678', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:28');
INSERT INTO `user` VALUES (152, '15868153679', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:31');
INSERT INTO `user` VALUES (153, '15868153681', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:38');
INSERT INTO `user` VALUES (154, '15868153682', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:49');
INSERT INTO `user` VALUES (155, '15868153685', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:52');
INSERT INTO `user` VALUES (156, '15868153695', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:04:58');
INSERT INTO `user` VALUES (157, '15868153615', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:01');
INSERT INTO `user` VALUES (158, '15828153675', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:04');
INSERT INTO `user` VALUES (159, '15868353675', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:07');
INSERT INTO `user` VALUES (160, '15868143675', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:10');
INSERT INTO `user` VALUES (161, '15868153775', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:20');
INSERT INTO `user` VALUES (162, '15868157675', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:23');
INSERT INTO `user` VALUES (163, '15868153695', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:26');
INSERT INTO `user` VALUES (164, '15868153675', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-06 16:17:06');
INSERT INTO `user` VALUES (165, '15868153975', 'xuan', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-06 16:17:06', '2019-05-09 16:05:28');
INSERT INTO `user` VALUES (166, '15868133375', 'czx', '202cb962ac59075b964b07152d234b70', '2', '0', 0, '2019-05-12 16:37:37', '2019-05-16 15:04:51');
INSERT INTO `user` VALUES (167, '18868133375', 'czx', '202cb962ac59075b964b07152d234b70', '1', '0', 0, '2019-05-12 16:38:42', '2019-05-12 16:38:42');

SET FOREIGN_KEY_CHECKS = 1;
