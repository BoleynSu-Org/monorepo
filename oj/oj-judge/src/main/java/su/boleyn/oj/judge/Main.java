package su.boleyn.oj.judge;

import java.sql.ResultSet;
import java.sql.SQLException;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

import su.boleyn.oj.core.Config;
import su.boleyn.oj.core.FileUtils;
import su.boleyn.oj.core.SQL;

public class Main extends Config {
    private static final String RUNNER_HOST = getOrElse("RUNNER_HOST", "localhost");
    private static final int RUNNER_PORT = Integer.parseInt(getOrElse("RUNNER_PORT", "1993"));

    public static void go(RunnerGrpc.RunnerBlockingStub runner, long id) throws SQLException {
        try {
            System.out.println("running " + id);

            ResultSet status = SQL.getSubmissionById(id);
            status.next();
            String source = status.getString("source");
            long pid = status.getLong("pid");

            ResultSet problem = SQL.getProblemById(pid);
            problem.next();
            long testcase = problem.getLong("testcase");

            int time = 0, memory = 0;
            for (int i = 1; i <= testcase; i++) {
                String inputFilePath = "/" + problem.getString("code") + "/" + i + ".in";
                String input = FileUtils.read(inputFilePath);
                String outputFilePath = "/" + problem.getString("code") + "/" + i + ".out";
                String output = FileUtils.read(outputFilePath);
                Task task = Task.newBuilder().setSource(source).setInput(input).build();
                SQL.setResult(id, "running " + i, time, memory);
                Result result = runner.run(task);
                if (!"accepted".equals(result.getResult())) {
                    SQL.setResult(id, result.getResult() + " " + i, time, memory);
                    return;
                } else {
                    boolean res = !result.getOutput().replaceAll("\\s", "").equals(output.replaceAll("\\s", ""));
                    if (res) {
                        SQL.setResult(id, "wrong answer " + i, time, memory);
                        return;
                    } else {
                        time = Math.max(time, result.getTime());
                        memory = Math.max(memory, result.getMemory());
                    }
                }
            }
            SQL.setResult(id, "accepted", time, memory);
        } catch (Exception e) {
            System.out.println("exception: " + e.getMessage());
            SQL.setResult(id, "judge error", 0, 0);
        }
    }

    public static void go(RunnerGrpc.RunnerBlockingStub runner) throws InterruptedException {
        while (true) {
            try {
                long id = SQL.getIdInQueue();
                go(runner, id);
            } catch (Exception e) {
                System.out.println("exception: " + e.getMessage());
                Thread.sleep(2000);
            }
        }
    }

    public static void main(String[] args) throws InterruptedException {
        while (true) {
            try {
                ManagedChannel channel = ManagedChannelBuilder.forAddress(RUNNER_HOST, RUNNER_PORT).usePlaintext()
                        .maxInboundMessageSize(100 * 1024 * 1024).build();
                RunnerGrpc.RunnerBlockingStub runner = RunnerGrpc.newBlockingStub(channel);
                go(runner);
            } catch (Exception e) {
                System.out.println("exception: " + e.getMessage());
                Thread.sleep(2000);
            }
        }
    }
}
