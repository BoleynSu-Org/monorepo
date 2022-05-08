package su.boleyn.oj.c99runner;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import su.boleyn.oj.judge.Result;
import su.boleyn.oj.judge.Task;

public class MainTest {
    Task.Builder builder = Task.newBuilder();
    Result result;

    @Test
    public void testAC() {
        result = Main.run(builder.setInput("1 2")
                .setSource(
                        "#include <stdio.h>\nint main() { int a, b; scanf(\"%d%d\", &a, &b); printf(\"%d\", a + b); }")
                .build());
        assertEquals("3", result.getOutput());
    }

    @Test
    public void testCE() {
        result = Main.run(builder.setInput("1 2")
                .setSource(
                        "#include <stdio.h>\nint main() { int a, b; xscanf(\"%d%d\", &a, &b); printf(\"%d\", a + b); }")
                .build());
        assertEquals("compilation error", result.getResult());

        result = Main.run(builder.setInput("1 2").setSource(
                "#include </dev/random>\nint main() { int a, b; scanf(\"%d%d\", &a, &b); printf(\"%d\", a + b); }")
                .build());
        if (Main.getCC().equals("clang")) {
                assertEquals("accepted", result.getResult());
        } else {
                assertEquals("compilation error", result.getResult());
        }
    }

    @Test
    public void testTLE() {
        result = Main.run(builder.setInput("1 2").setSource(
                "#include <stdio.h>\nint main() { int a, b; scanf(\"%d%d\", &a, &b); while (a % 2) a += 2; printf(\"%d\", a + b); }")
                .build());
        assertEquals("time limit exceeded", result.getResult());
    }

}
