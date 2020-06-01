package com.zcreate;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Serializable;

/**
 * Created by IntelliJ IDEA.
 * User: 黄海晏
 * Date: 2004-6-14
 * Time: 14:58:46
 */
public class ExceptionAdapter extends RuntimeException implements Serializable {
    private final String stackTrace;
    public Exception originalException;

    public ExceptionAdapter(Exception e) {
        super(e.toString());
        originalException = e;
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        stackTrace = sw.toString();
    }

    public void printStackTrace() {
        printStackTrace(System.err);
    }

    public void printStackTrace(java.io.PrintStream s) {
        synchronized (s) {
            s.print(getClass().getName() + ": ");
            s.print(stackTrace);
        }
    }

    public void printStackTrace(PrintWriter s) {
        synchronized (s) {
            s.print(getClass().getName() + ": ");
            s.print(stackTrace);
        }
    }

    public void rethrow() throws Exception{
        throw originalException;
    }
}
