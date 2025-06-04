import java.io.*;
import java.net.*;
import java.util.*;

public class FileClient {
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private List<String> localFiles;
    private static final int DEFAULT_PORT = 5000;

    public FileClient(String host, int port) {
        try {
            socket = new Socket(host, port);
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            localFiles = new ArrayList<>();
            System.out.println("Connected to server at " + host + ":" + port);
        } catch (IOException e) {
            System.out.println("Could not connect to server at " + host + ":" + port);
            System.exit(1);
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public void signin(List<String> files) {
        localFiles.addAll(files);
        String fileList = String.join(",", files);
        out.println("SIGNIN " + fileList);
        try {
            String response = in.readLine();
            System.out.println("Server response: " + response);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public void search(List<String> keywords) {
        String keywordList = String.join(",", keywords);
        out.println("SEARCH " + keywordList);
        try {
            String response = in.readLine();
            System.out.println("Search results: " + response);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public void signout() {
        out.println("SIGNOUT");
        try {
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java FileClient <server-ip>");
            System.out.println("Example: java FileClient 127.0.0.1");
            System.exit(1);
        }

        String serverIP = args[0];
        FileClient client = new FileClient(serverIP, DEFAULT_PORT);
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\nAvailable commands:");
            System.out.println("1. Signin (register files)");
            System.out.println("2. Search files");
            System.out.println("3. Signout");
            System.out.print("Enter command number: ");

            int choice;
            try {
                choice = scanner.nextInt();
                scanner.nextLine(); // consume newline
            } catch (InputMismatchException e) {
                System.out.println("Please enter a valid number");
                scanner.nextLine(); // consume invalid input
                continue;
            }

            switch (choice) {
                case 1 -> {
                    System.out.println("Enter filenames (comma-separated): ");
                    String files = scanner.nextLine();
                    client.signin(Arrays.asList(files.split(",")));
                }

                case 2 -> {
                    System.out.println("Enter search keywords (comma-separated): ");
                    String keywords = scanner.nextLine();
                    client.search(Arrays.asList(keywords.split(",")));
                }

                case 3 -> {
                    client.signout();
                    scanner.close();
                    System.out.println("Client disconnected");
                    return;
                }

                default -> System.out.println("Invalid command");
            }
        }
    }
}