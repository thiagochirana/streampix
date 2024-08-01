package br.com.streampix.app.utils;

import java.time.Duration;

public class Time {

    public static Duration secondsToDuration(long seconds) {
        return Duration.ofSeconds(seconds);
    }
}