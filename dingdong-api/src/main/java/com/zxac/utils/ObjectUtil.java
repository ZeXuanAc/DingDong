package com.zxac.utils;

import lombok.extern.slf4j.Slf4j;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class ObjectUtil {


    /**
     * obj to map
     * @param obj 待转化的obj
     * @param t   map中的class类型
     * @param exclusive  obj中不需要转化的属性
     * @param <T>
     * @return
     */
    public static <T> Map<String, T> toMap(Object obj, Class<T> t, String... exclusive) {
        if (obj == null) {
            return null;
        }
        Map<String, T> map = new HashMap<>();
        try {
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                String key = property.getName();
                boolean flag = true;
                for (String anExclusive : exclusive) {
                    if (key.equals(anExclusive)) {
                        flag = false;
                        break;
                    }
                }
                if (flag && !key.equals("class")) {
                    Method getter = property.getReadMethod();
                    T value;
                    if (t.getName().equals("java.lang.String")) {
                        value = (T) getter.invoke(obj).toString();
                    } else {
                        value = (T) getter.invoke(obj);
                    }
                    map.put(key, value);
                }
            }
        } catch (Exception e) {
            log.warn("transBean2Map Error, {} ", e.getMessage());
        }
        return map;
    }


    public static <T> T mapToBean(Map<String, Object> map, Class<T> t, String... exclusive) {
        if (map == null || map.size() == 0) {
            return null;
        }
        T obj = null;
        try {
            obj = t.newInstance();
            BeanInfo beanInfo = Introspector.getBeanInfo(t);
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();

            for (PropertyDescriptor property : propertyDescriptors) {
                String key = property.getName();
                boolean flag = true;
                for (String anExclusive : exclusive) {
                    if (key.equals(anExclusive)) {
                        flag = false;
                        break;
                    }
                }

                if (flag && map.containsKey(key)) {
                    Object value = map.get(key);
                    // 得到property对应的setter方法
                    Method setter = property.getWriteMethod();
                    setter.invoke(obj, value);
                }
            }
        } catch (Exception ex) {
            log.warn("transMap2Bean Error, {}", ex.getMessage());
        }
        return obj;
    }
}
