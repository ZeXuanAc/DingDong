/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50641
 Source Host           : localhost:3306
 Source Schema         : dingdong

 Target Server Type    : MySQL
 Target Server Version : 50641
 File Encoding         : 65001

 Date: 11/05/2019 17:09:09
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of admin_building
-- ----------------------------
INSERT INTO `admin_building` VALUES (1, 2, 3, '2019-05-10 20:04:50', '2019-05-10 20:04:50');
INSERT INTO `admin_building` VALUES (2, 3, 1, '2019-05-10 20:05:07', '2019-05-10 20:05:07');
INSERT INTO `admin_building` VALUES (3, 3, 2, '2019-05-10 20:05:22', '2019-05-10 20:05:22');
INSERT INTO `admin_building` VALUES (4, 3, 4, '2019-05-10 20:05:41', '2019-05-10 20:05:41');

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
  `priority` int(11) DEFAULT NULL COMMENT '热度，1最小',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '具体地址，如东和公寓5幢，图书馆A座，以整个建筑物为单位' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of building
-- ----------------------------
INSERT INTO `building` VALUES (1, '东和公寓5栋', '0571', '杭州市', 4, '30.217871', '120.03187', 2, '2019-04-07 13:50:11', '2019-04-29 14:22:20');
INSERT INTO `building` VALUES (2, '浙江科技学院东图书馆', '0571', '杭州市', 0, '30.22784629566467', '120.03305590799634', 1, '2019-04-07 15:16:06', '2019-04-29 14:22:30');
INSERT INTO `building` VALUES (3, '义乌火车站', '0579', '金华市', 0, '29.384094708973084', '120.04983892590838', 1, '2019-04-07 15:17:23', '2019-04-29 14:22:43');
INSERT INTO `building` VALUES (4, '杭州城西银泰', '0571', '杭州市', 0, '30.30596669357389', '120.11517426724171', 3, '2019-04-12 11:21:52', '2019-04-29 14:22:53');
INSERT INTO `building` VALUES (5, 'aaa', '123', 'aaa', 0, NULL, NULL, NULL, '2019-05-11 13:40:18', '2019-05-11 13:40:18');
INSERT INTO `building` VALUES (6, 'aaa', '123', 'aaa', 0, NULL, NULL, NULL, '2019-05-11 13:41:41', '2019-05-11 13:41:41');
INSERT INTO `building` VALUES (7, 'bbbaa', '123', 'aaa', 0, NULL, NULL, NULL, '2019-05-11 13:41:42', '2019-05-11 13:48:14');

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
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for city
-- ----------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE `city`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '城市id',
  `citycode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市代码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市名称',
  `province` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '所在省名称',
  `priority` int(11) DEFAULT NULL COMMENT '热度，1最小',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of city
-- ----------------------------
INSERT INTO `city` VALUES (1, '0571', '杭州市', '浙江省', 1, '2019-04-07 15:14:53', '2019-05-10 16:44:35');
INSERT INTO `city` VALUES (2, '0579', '金华市', '浙江省', 123, '2019-04-07 15:15:20', '2019-05-10 16:44:51');
INSERT INTO `city` VALUES (24, '0984', '河南', '河南省', 53, '2019-05-10 19:06:10', '2019-05-10 22:36:49');
INSERT INTO `city` VALUES (29, '123', '123', '123', 123, '2019-05-10 22:42:58', '2019-05-10 22:42:58');
INSERT INTO `city` VALUES (30, '122222', '123', '123', 123, '2019-05-10 22:43:03', '2019-05-10 22:43:03');
INSERT INTO `city` VALUES (31, '12412', '123', '123', 23, '2019-05-10 22:43:09', '2019-05-10 22:43:09');
INSERT INTO `city` VALUES (32, '144423', '123', '123', 1233, '2019-05-10 22:45:03', '2019-05-11 00:00:00');
INSERT INTO `city` VALUES (33, '1444323', '123', '123', NULL, '2019-05-11 01:23:19', '2019-05-11 01:23:19');
INSERT INTO `city` VALUES (34, '14434323', '123', '123', NULL, '2019-05-11 01:24:18', '2019-05-11 01:24:18');
INSERT INTO `city` VALUES (35, '144334323', '123', '123', NULL, '2019-05-11 01:29:01', '2019-05-11 01:29:01');
INSERT INTO `city` VALUES (36, '1477', '123', '123', 123, '2019-05-11 02:36:43', '2019-05-11 15:44:25');

-- ----------------------------
-- Table structure for equipment
-- ----------------------------
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备名称',
  `storey_id` int(11) DEFAULT NULL COMMENT '楼层id',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备所在地址',
  `condition` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '状态（1为正常，0为维护中）',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '经度',
  `priority` int(11) DEFAULT NULL COMMENT '优先级，同一楼层比较时使用，1为最大',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息表' ROW_FORMAT = Compact;

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
INSERT INTO `equipment` VALUES (30, '2', 11, NULL, '1', NULL, NULL, 2, '2019-04-29 14:33:10', '2019-04-29 14:33:28');
INSERT INTO `equipment` VALUES (31, '3', 12, NULL, '1', NULL, NULL, 3, '2019-04-29 14:33:12', '2019-04-29 14:33:55');
INSERT INTO `equipment` VALUES (32, '1', 12, NULL, '1', NULL, NULL, 1, '2019-04-29 14:33:35', '2019-04-29 14:34:04');
INSERT INTO `equipment` VALUES (33, '2', 12, NULL, '1', NULL, NULL, 2, '2019-04-29 14:33:40', '2019-04-29 14:34:06');

-- ----------------------------
-- Table structure for storey
-- ----------------------------
DROP TABLE IF EXISTS `storey`;
CREATE TABLE `storey`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '楼层表id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '楼层名称',
  `building_id` int(11) DEFAULT NULL COMMENT '所在建筑id',
  `floor` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '楼层，如“F1”（地上一层）,“B1”（地下一层）',
  `gender` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '性别类型，默认为公用（0），男（1），女（2）',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '经度',
  `eq_num` int(11) DEFAULT 0 COMMENT '所在楼层设备数量',
  `priority` int(11) DEFAULT NULL COMMENT '优先级，同一楼层比较时使用，1为最大',
  `create_time` datetime(0) DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '楼层，如图书馆A座的2楼' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of storey
-- ----------------------------
INSERT INTO `storey` VALUES (1, '3层【听雨阁】', 1, 'F3', '0', '30.217871', '120.03187', 3, 4, '2019-04-07 15:33:04', '2019-04-29 16:11:06');
INSERT INTO `storey` VALUES (2, '2层【美人鱼】', 1, 'F2', '0', '30.217871', '120.03187', 1, 1, '2019-04-07 15:33:34', '2019-04-29 16:11:07');
INSERT INTO `storey` VALUES (3, '5层【闻天轩】', 2, 'F5', '0', '30.22784629566467', '120.03305590799634', 4, 5, '2019-04-07 15:34:17', '2019-04-29 16:11:09');
INSERT INTO `storey` VALUES (4, '4层【望月楼】', 2, 'F4', '0', '30.22784629566467', '120.03305590799634', 2, 4, '2019-04-09 19:36:42', '2019-04-29 16:11:10');
INSERT INTO `storey` VALUES (5, '2层【南】', 4, 'F2', '0', '30.30596669357389', '120.11517426724171', 0, 3, '2019-04-12 11:30:26', '2019-04-29 16:11:10');
INSERT INTO `storey` VALUES (6, '3层【赤壁之战】', 2, 'F3', '0', '30.22784629566467', '120.03305590799634', 0, 3, '2019-04-12 11:33:41', '2019-04-29 16:11:10');
INSERT INTO `storey` VALUES (7, '1层【交易大厅】', 2, 'F1', '0', '30.22784629566467', '120.03305590799634', 0, 1, '2019-04-12 11:34:53', '2019-04-29 16:11:11');
INSERT INTO `storey` VALUES (8, '2层【技术中心】', 2, 'F2', '0', '30.22784629566467', '120.03305590799634', 0, 2, '2019-04-12 11:35:19', '2019-04-29 16:11:12');
INSERT INTO `storey` VALUES (9, '4号候车厅【南侧】', 3, 'F2', '0', '29.384094708973085', '120.04983892590838', 0, 1, '2019-04-19 22:13:20', '2019-04-29 16:11:11');
INSERT INTO `storey` VALUES (10, '2号候车厅【东边】', 3, 'F1', '0', '29.384094708973085', '120.04983892590838', 0, 2, '2019-04-19 22:13:24', '2019-04-29 16:11:16');
INSERT INTO `storey` VALUES (11, '2层【男】', 1, 'F2', '1', '30.217871', '120.03187', 0, 2, '2019-04-29 14:18:56', '2019-04-29 14:32:19');
INSERT INTO `storey` VALUES (12, '2层【女】', 1, 'F2', '2', '30.217871', '120.03187', 0, 3, '2019-04-29 14:31:53', '2019-04-29 14:32:31');

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
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

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

SET FOREIGN_KEY_CHECKS = 1;
