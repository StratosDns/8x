import java.io.*;
import java.net.*;
import java.util.*;

public class Client {
    private static String SERVER_IP; // Remove the constant declaration
    private static int SERVER_PORT;  // Remove the constant declaration
    private static String username;

    public static void main(String[] args) throws IOException, ClassNotFoundException {
        if (args.length != 2) {
            System.out.println("Usage: java Client <server_ip> <server_port>");
            System.exit(1);
        }

        // Get IP and port from command line arguments
        SERVER_IP = args[0];
        SERVER_PORT = Integer.parseInt(args[1]);

        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter your username: ");
        username = scanner.nextLine();

        sendCommand("signin");

        while (true) {
            System.out.println("\n1. Read Emails\n2. Send Email");
            String choice = scanner.nextLine();

            if (choice.equals("1")) {
                readEmails();
            } else if (choice.equals("2")) {
                System.out.print("To (user@ip:port): ");
                String to = scanner.nextLine();
                System.out.print("Message: ");
                String msg = scanner.nextLine();
                sendEmail(to, msg);
            }
        }
    }

    private static void sendCommand(String command) throws IOException, ClassNotFoundException {
        try (Socket socket = new Socket(SERVER_IP, SERVER_PORT);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {
            out.writeObject(command);
            String response = (String) in.readObject();
            System.out.println("Server: " + response);
        }
    }

    private static void readEmails() throws IOException, ClassNotFoundException {
        try (Socket socket = new Socket(SERVER_IP, SERVER_PORT);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {
            out.writeObject("mail");
            out.writeObject(username);

            List<Email> emails = (List<Email>) in.readObject();
            if (emails.isEmpty()) {
                System.out.println("No emails.");
            } else {
                for (Email email : emails) {
                    System.out.println("----------");
                    System.out.println(email);
                }
            }
        }
    }

    private static void sendEmail(String to, String msg) throws IOException, ClassNotFoundException {
        try (Socket socket = new Socket(SERVER_IP, SERVER_PORT);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {

            out.writeObject("mail user@ip:port text");
            out.writeObject(to);
            out.writeObject(username);
            out.writeObject(msg);

            String response = (String) in.readObject();
            System.out.println("Server: " + response);
        }
    }
}
