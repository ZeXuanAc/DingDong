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

    public static Map toMap(Object obj, String... exclusive){
        if(obj == null){
            return null;
        }
        Map<String, Object> map = new HashMap<>();
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
                    Object value = getter.invoke(obj);
                    map.put(key, value);
                }
            }
        } catch (Exception e) {
            log.warn("transBean2Map Error ", e);
        }
        return map;
    }
}
