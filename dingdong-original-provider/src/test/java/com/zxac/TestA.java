package com.zxac;

import org.junit.Test;

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

}
