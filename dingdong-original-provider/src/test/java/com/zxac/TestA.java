package com.zxac;

import org.junit.Test;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.IntStream;

public class TestA {

    @Test
    public void aaa(){
        IntStream.range(0, 5).forEach(System.out::println);
    }


    @Test
    public void ads(){
        IntStream.range(0, 10).forEach(i -> System.out.println((int) (Math.random() * 2)));
    }

    @Test
    public void qwe(){
        String key = "CC1_B22_S333_E4444";
        String[] keys = key.split("_");
        System.out.println(keys[0].substring(2));
        System.out.println(keys[1].substring(1));
        System.out.println(keys[2].substring(1));
        System.out.println(keys[3].substring(1));

        //array转set
        String[] s = new String[]{"A", "B", "C", "D","E"};
        Set<String> set = new HashSet<>(Arrays.asList(s));
        System.out.println("set: " + set);
        //set转array
        String[] dest = set.toArray(new String[0]);
        System.out.println("dest: " + Arrays.toString(dest));
    }

}
