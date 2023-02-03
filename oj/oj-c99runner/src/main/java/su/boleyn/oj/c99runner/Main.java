package su.boleyn.oj.c99runner;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.util.concurrent.TimeUnit;

import io.grpc.Server;
import io.grpc.netty.NettyServerBuilder;
import io.grpc.stub.StreamObserver;
import su.boleyn.oj.judge.Result;
import su.boleyn.oj.judge.RunnerGrpc;
import su.boleyn.oj.judge.Task;

public class Main extends RunnerGrpc.RunnerImplBase {
    private static final String RUNNER_ADDRESS = System.getenv().getOrDefault("RUNNER_ADDRESS", "0.0.0.0");
    private static final int RUNNER_PORT = Integer.parseInt(System.getenv().getOrDefault("RUNNER_PORT", "1993"));
    private static final String SOURCE_FILE = "/tmp/su.boleyn.oj-source.c";
    private static final String BINARY_FILE = "/tmp/su.boleyn.oj-main";
    private static final String INPUT_FILE = "/tmp/su.boleyn.oj-in.txt";
    private static final String OUTPUT_FILE = "/tmp/su.boleyn.oj-out.txt";

    public Main() {
    }

    public static String read(String path) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(path), "utf-8"))) {
            StringBuffer data = new StringBuffer();
            char[] buffer = new char[1024];
            int length;
            while ((length = reader.read(buffer)) != -1) {
                data.append(String.valueOf(buffer, 0, length));
            }
            return data.toString();
        }
    }

    public static String getCC() {
        Runtime r = Runtime.getRuntime();
        for (String CC : new String[] { "gcc", "clang" }) {
            try {
                if (r.exec(new String[] { "/bin/sh", "-c", "command -v " + CC }).waitFor() == 0) {
                    return CC;
                }
            } catch (Exception e) {
            }
        }
        return "false";
    }

    public static synchronized Result run(Task task) {
        Result.Builder builder = Result.newBuilder();
        try {
            try (PrintWriter out = new PrintWriter(SOURCE_FILE)) {
                out.write(task.getSource());
            }
            try (PrintWriter out = new PrintWriter(INPUT_FILE)) {
                out.write(task.getInput());
            }
            Runtime r = Runtime.getRuntime();
            Process compile = r.exec(new String[] { "/bin/sh", "-c",
                    getCC() + " -lm -std=c99 " + SOURCE_FILE + " -o " + BINARY_FILE + " >" + OUTPUT_FILE + " 2>&1" });
            if (!compile.waitFor(15, TimeUnit.SECONDS)) {
                compile.destroyForcibly();
                builder.setResult("compilation error")
                        .setOutput("error: it takes more than 15s to compile your program.").setTime(0).setMemory(0);
            } else if (compile.exitValue() != 0) {
                builder.setResult("compilation error").setOutput(read(OUTPUT_FILE)).setTime(0).setMemory(0);
            } else {
                int timeLimit = task.getTimeLimit() == 0 ? 5000 : task.getTimeLimit();
                long start = System.currentTimeMillis();
                Process run = r
                        .exec(new String[] { "/bin/sh", "-c", BINARY_FILE + " < " + INPUT_FILE + " > " + OUTPUT_FILE });
                if (!run.waitFor(timeLimit, TimeUnit.MILLISECONDS)) {
                    run.destroyForcibly();
                    builder.setResult("time limit exceeded")
                            .setOutput("error: it takes more than " + timeLimit + "ms to run your program.")
                            .setTime(timeLimit).setMemory(0);
                } else {
                    int time = Math.min(timeLimit, (int) (System.currentTimeMillis() - start));
                    builder.setResult("accepted").setOutput(read(OUTPUT_FILE)).setTime(time).setMemory(0);
                }
            }
            new File(SOURCE_FILE).delete();
            new File(INPUT_FILE).delete();
            new File(BINARY_FILE).delete();
            new File(OUTPUT_FILE).delete();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            builder.setResult("judge error").setOutput("").setTime(0).setMemory(0);
        }
        return builder.build();
    }

    public void run(Task task, StreamObserver<Result> responseObserver) {
        responseObserver.onNext(run(task));
        responseObserver.onCompleted();
    }

    public static void main(String[] args) throws IOException, InterruptedException {
        System.out.println("WARNING:");
        System.out.println(
                "The runner should be in a very restricted enviroment since we are running untrusted code in it.");
        Server server = NettyServerBuilder.forAddress(new InetSocketAddress(RUNNER_ADDRESS, RUNNER_PORT))
                .maxInboundMessageSize(100 * 1024 * 1024).addService(new Main()).build();
        server.start();
        server.awaitTermination();
    }
}
