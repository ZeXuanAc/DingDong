package com.zxac.utils;

import lombok.extern.slf4j.Slf4j;

import java.text.DecimalFormat;

@Slf4j
public class DistanceUtil {

    private static final  double EARTH_RADIUS = 6378137; // 赤道半径


    private static double rad(double d){
        return d * Math.PI / 180.0;
    }

    // 单位米
    public static Double GetDistance(String lng1, String lat1, String lng2, String lat2) {
        double radLat1 = 0;
        double radLat2 = 0;
        double a = 0;
        double b = 0;
        try {
            radLat1 = rad(Double.parseDouble(lat1));
            radLat2 = rad(Double.parseDouble(lat2));
            a = radLat1 - radLat2;
            b = rad(Double.parseDouble(lng1)) - rad(Double.parseDouble(lng2));
        } catch (Exception e) {
            log.error("计算距离 转化时失败, lng1: {}, lat1: {}, lng2: {}, lat2: {}", lng1, lat1, lng2, lat2);
        }

        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2), 2) + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b/2), 2)));
        s = s * EARTH_RADIUS;
        return s;
    }


    public static String format2decimal(Double distance) {
        String unit = "m";
        DecimalFormat df = new DecimalFormat("#.0");
        if (distance > 1000) {
            distance /= 1000;
            unit = "km";
        }
        return df.format(distance) + unit;
    }

}
