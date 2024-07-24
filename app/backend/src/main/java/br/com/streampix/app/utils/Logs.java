package br.com.streampix.app.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Logs {

    private final Logger LOG;

    public Logs(Class clazz){
        LOG = LoggerFactory.getLogger(clazz);
    }

    //INFO
    public void info(String msg){
        LOG.info(msg);
    }

    //WARN
    public void warn(String msg){
        LOG.warn(msg);
    }

    public void warn(String msg, Throwable t){
        LOG.warn(msg, t);
    }

    //ERROR
    public void error(String msg){
        LOG.error(msg);
    }

    public void error(String msg, Throwable t){
        LOG.error(msg, t);
    }

}