package org.example;

import io.javalin.Javalin;

public class Main {
    public static void main(String[] args) {
        Javalin app1 = Javalin.create().start(7070);
        Javalin app2 = Javalin.create().start(7080);

        app1.get("/", ctx -> ctx.html("Hello World desde <b>Aplicacion 1</b>"));
        app2.get("/", ctx -> ctx.html("Hello World desde <b>Aplicacion 2</b>"));
    }
}
