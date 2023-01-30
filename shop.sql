/*
Navicat MySQL Data Transfer

Source Server         : BasicTest
Source Server Version : 80027
Source Host           : localhost:3306
Source Database       : shop

Target Server Type    : MYSQL
Target Server Version : 80027
File Encoding         : 65001

Date: 2023-01-17 00:57:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for car
-- ----------------------------
DROP TABLE IF EXISTS `car`;
CREATE TABLE `car` (
  `car_id` int NOT NULL AUTO_INCREMENT,
  `count` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `goods_id` int NOT NULL,
  PRIMARY KEY (`car_id`),
  KEY `car_ibfk_1` (`user_id`),
  KEY `car_ibfk_2` (`goods_id`),
  CONSTRAINT `car_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `car_ibfk_2` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of car
-- ----------------------------
INSERT INTO `car` VALUES ('2', '2', '1', '3');
INSERT INTO `car` VALUES ('3', '5', '1', '4');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `types_id` int NOT NULL AUTO_INCREMENT,
  `classification` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`types_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '生鲜');
INSERT INTO `category` VALUES ('2', '电子产品');
INSERT INTO `category` VALUES ('3', '日用品');
INSERT INTO `category` VALUES ('4', '服装');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `goods_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `img` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(32) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `count` int DEFAULT NULL,
  `price` float DEFAULT NULL,
  `goods_sale` int DEFAULT NULL,
  PRIMARY KEY (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES ('1', 'Redmi 12C', '12c.png', '电子产品', '高性能长续航，5000万像素超清双摄', '150', '699', '31');
INSERT INTO `goods` VALUES ('2', 'Redmi K60', 'K60.png', '电子产品', '骁龙8+｜2K 高光直屏｜5500mAh+67W闪充', '120', '2499', '111');
INSERT INTO `goods` VALUES ('3', 'Redmi K60 Pro', 'K60Pro.png', '电子产品', '【第二代晓龙8】狂暴引擎', '161', '3299', '56');
INSERT INTO `goods` VALUES ('4', 'Xiaomi 13 限量定制色', 'Xiaomi13.png', '电子产品', '全新第二代骁龙8｜徕卡专业光学镜头｜徕卡原生双画质 | 6.36″超窄边屏幕｜67W小米澎湃秒充｜徕卡75mm长焦镜头', '151', '4999', '213');
INSERT INTO `goods` VALUES ('5', 'Xiaomi 13', 'Xiaomi13Pro.png', '电子产品', '全新第二代骁龙8｜徕卡专业光学镜头｜徕卡原生双画质 | 6.36″超窄边屏幕｜67W小米澎湃秒充｜徕卡75mm长焦镜头', '81', '3999', '23');
INSERT INTO `goods` VALUES ('6', 'Redmi Note 12 Pro 极速版', 'Note12Pro.png', '电子产品', '高通骁龙778G，OLED柔性直屏+一亿像素', '111', '1699', '314');
INSERT INTO `goods` VALUES ('7', 'Redmi Note 12 5G', 'Xiaomi14.png', '电子产品', '三星 OLED 护眼屏｜骁龙 5G 芯｜5000mAh 电量', '177', '1199', '78');
INSERT INTO `goods` VALUES ('8', 'Xiaomi 13 Pro', 'Xiaomi13.png', '电子产品', '全新第二代骁龙8｜徕卡专业光学镜头｜徕卡原生双画质 | 6.36″超窄边屏幕｜67W小米澎湃秒充｜徕卡75mm长焦镜头', '771', '4999', '213');
INSERT INTO `goods` VALUES ('9', 'Xiaomi Buds 4', 'Buds4.png', '电子产品', '35dB 智能主动降噪 | AI 通话降噪 | 30小时超长续航', '54', '199', '114');
INSERT INTO `goods` VALUES ('10', 'Xiaomi Buds 3', 'Buds3.png', '电子产品', '40dB宽频主动降噪 | HiFi高保真音质 | HRTF专业调音', '111', '299', '56');
INSERT INTO `goods` VALUES ('11', '小米真无线蓝牙耳机Air2 SE', 'Buds4.png', '电子产品', '大尺寸动圈单元 | 20小时持久续航 | 双麦克风通话降噪', '160', '1299', '30');
INSERT INTO `goods` VALUES ('12', 'Redmi Book Pro 14 2022', 'MiBook.png', '电子产品', '全新12代英特尔处理器，2.5K 120Hz高清屏，可选MX550独立显卡,CNC一体精雕工艺', '51', '5399', '100');
INSERT INTO `goods` VALUES ('13', 'Redmi Pad', 'MiPad.png', '电子产品', '入门平板，屏幕/外观/系统三大升级', '210', '1199', '54');
INSERT INTO `goods` VALUES ('14', '小米电视 ES55 2022款', 'xiaomiTV.png', '电子产品', '多分区背光 | MEMC动态补偿 | 杜比视界', '91', '2499', '30');
INSERT INTO `goods` VALUES ('15', '小米路由器', 'MiWiFi.png', '电子产品', '无线速率AX5400 高通多核处理器 5G速度提升20% ', '100', '349', '68');
INSERT INTO `goods` VALUES ('18', '上海青', '上海青.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '200', '28.8', '23');
INSERT INTO `goods` VALUES ('19', '小米辣', '小米辣.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '200', '23.4', '44');
INSERT INTO `goods` VALUES ('20', '杭白菜', '杭白菜.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '200', '26.7', '34');
INSERT INTO `goods` VALUES ('21', '胡萝卜', '胡萝卜.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '200', '34.2', '23');
INSERT INTO `goods` VALUES ('22', '菠菜', '菠菜.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '200', '12.4', '22');
INSERT INTO `goods` VALUES ('23', '黄瓜', '黄瓜.png', '生鲜', '农家自种 新鲜现摘  原产地直发 5斤装', '194', '34.2', '12');
INSERT INTO `goods` VALUES ('24', '毛巾', '毛巾.png', '日用品', '新疆棉毛巾 A类强吸水素色柔软洁面巾洗脸擦脸巾 单条装', '200', '8.8', '18');
INSERT INTO `goods` VALUES ('25', '牙刷', '牙刷.png', '日用品', '成人超细软毛简装牙刷 防出血小头日系牙刷6只装', '200', '29.8', '123');
INSERT INTO `goods` VALUES ('26', '沐浴露', '沐浴露.png', '日用品', '薰衣草花香沐浴露 2kg滋润保湿沐浴乳', '198', '20.8', '45');
INSERT INTO `goods` VALUES ('27', '洗发水', '洗发水.png', '日用品', '男士去屑洗发水清爽控油型500g+100gX2 青柠薄荷醇 洗头膏C罗', '196', '36.9', '23');
INSERT INTO `goods` VALUES ('28', '冬装', '冬装.png', '服装', '潮牌联名棉衣男秋冬季新款棉服加绒加厚棉袄男女情侣青年面包服潮流连帽假两件外套冬装衣服 卡其色 XL（建议120-140斤）', '200', '168', '111');
INSERT INTO `goods` VALUES ('29', '毛衣', '毛衣.png', '服装', '南极人水貂绒毛衣男秋冬季潮流男士毛衫线衣宽松休闲圆领加厚保暖打底衫青少年男生针织衫冬装衣服男装 10909/8270米白 XL', '200', '69', '32');
INSERT INTO `goods` VALUES ('30', 'T恤', 'T恤.png', '服装', '浪莎男士T恤短袖男棉质圆领纯色简约背心薄款吸汗透气运动休闲打底衫 黑色 180/XXL', '200', '29.9', '34');
INSERT INTO `goods` VALUES ('31', '裙子', '裙子.png', '服装', 'LEDE雪纺连衣裙女装2022年新款夏装修身显瘦超仙气质中长款小个子碎花裙子夏天短袖衣服潮 257仙女碎花杏色 M 90-100斤', '200', '168', '89');

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `sum` float DEFAULT NULL,
  `count` int DEFAULT NULL,
  `time` date DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `goods_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `order_ibfk_1` (`user_id`),
  KEY `order_ibfk_2` (`goods_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('1', 'ad', 'wqd', '213', '45', '3', '2023-01-10', '1', '1');
INSERT INTO `order` VALUES ('2', 'gas', 'sdf', '435', '224', '3', '2023-01-08', '1', '5');
INSERT INTO `order` VALUES ('3', 'fgdsg', 'hfgsh', '45636', '321', '4', '2023-01-05', '1', '9');
INSERT INTO `order` VALUES ('4', '张三', '北京', '123456', '4998', '2', '2023-01-15', '1', '2');
INSERT INTO `order` VALUES ('5', '张三', '北京', '123456', '9996', '4', '2023-01-04', '1', '14');
INSERT INTO `order` VALUES ('6', '张三', '北京', '123456', '10798', '2', '2023-01-17', '1', '12');
INSERT INTO `order` VALUES ('7', '张三', '北京', '123456', '68.4', '2', '2023-01-17', '1', '23');
INSERT INTO `order` VALUES ('8', '张三', '北京', '123456', '41.6', '2', '2023-01-17', '1', '26');
INSERT INTO `order` VALUES ('9', '张三', '北京', '123456', '147.6', '4', '2023-01-17', '1', '27');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `nikename` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `sex` varchar(16) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `mail` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'user', 'user', '张三', '男', '北京', '123456', '123456@qq.com');
DROP TRIGGER IF EXISTS `del_goods`;
DELIMITER ;;
CREATE TRIGGER `del_goods` AFTER DELETE ON `goods` FOR EACH ROW BEGIN
DELETE FROM car
WHERE car.goods_id=old.goods_id;
DELETE FROM `order`
WHERE `order`.goods_id=old.goods_id;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `del_user`;
DELIMITER ;;
CREATE TRIGGER `del_user` AFTER DELETE ON `user` FOR EACH ROW BEGIN
DELETE FROM car
WHERE car.user_id=old.user_id;
DELETE FROM `order`
WHERE `order`.user_id=old.user_id;
END
;;
DELIMITER ;
