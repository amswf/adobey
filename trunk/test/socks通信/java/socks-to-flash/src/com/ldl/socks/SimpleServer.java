package com.ldl.socks;

import java.io.*;
import java.net.*;

/**
 *
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Copyright: Copyright (c) 2007</p>
 *
 * <p>Company: </p>
 *
 * @author not attributable
 * @version 1.0
 */
class SimpleServer {
    private static SimpleServer server;
    ServerSocket socket;
    Socket incoming;
    BufferedReader readerIn;
    PrintStream printOut;

    public static void main(String[] args) {
        int port = 10086;

        try {
            port = Integer.parseInt(args[0]);
        } catch (ArrayIndexOutOfBoundsException e) {
            // 捕获异常并继续操作。
        }

        server = new SimpleServer(port);
    }

    private SimpleServer(int port) {
        System.out.println(">> Starting SimpleServer");
        try {
            boolean done = false;
            while (!done) {
            socket = new ServerSocket(port);
            incoming = socket.accept();
            readerIn = new BufferedReader(new InputStreamReader(incoming.
                    getInputStream()));
            printOut = new PrintStream(incoming.getOutputStream());
            //printOut.println("java server get it!");
            //out("Enter EXIT to exit.\r");


                String str = readerIn.readLine();
//                if (str == null) {
//                    done = true;
//                } else {
                if(str != null){
                    printOut.println("java get:" + str);
                    System.out.println("java get:" + str);
                    //out("java get:" + str + "\r\n");
                    if (str.trim().equals("EXIT")) {
                        done = true;
                    }
                }
                incoming.close();
                socket.close();
                readerIn.close();
                printOut.close();
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    private void out(String str) {
        printOut.println(str);
        System.out.println(str);
    }
}

