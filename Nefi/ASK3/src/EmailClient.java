// EmailClient.java
import java.io.*;
import java.net.*;
import java.util.*;

public class EmailClient {
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private String username;
    private Scanner userInput;

    public EmailClient(String serverAddress, int port) {
        try {
            socket = new Socket(serverAddress, port);
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            userInput = new Scanner(System.in);
            System.out.println("Connected to email server at " + serverAddress + ":" + port);
        } catch (IOException e) {
            System.out.println("Could not connect to server at " + serverAddress + ":" + port);
            System.exit(1);
        }
    }

    public void start() {
        // First, sign in
        signin();

        while (true) {
            showMenu();
            try {
                int choice = Integer.parseInt(userInput.nextLine());
                switch (choice) {
                    case 1:
                        readEmails();
                        break;
                    case 2:
                        sendEmail();
                        break;
                    case 3:
                        System.out.println("Goodbye!");
                        cleanup();
                        return;
                    default:
                        System.out.println("Invalid choice. Please try again.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number.");
            }
        }
    }

    private void signin() {
        System.out.print("Enter your username: ");
        username = userInput.nextLine();
        out.println(Protocol.SIGNIN + " " + username);
        try {
            String response = in.readLine();
            if (response.equals(Protocol.OK)) {
                System.out.println("Successfully signed in as " + username);
            } else {
                System.out.println("Sign in failed");
                System.exit(1);
            }
        } catch (IOException e) {
            System.out.println("Error during sign in");
            System.exit(1);
        }
    }

    private void showMenu() {
        System.out.println("\n=== Email Client Menu ===");
        System.out.println("1. Read emails");
        System.out.println("2. Send new email");
        System.out.println("3. Exit");
        System.out.print("Choose an option: ");
    }

    private void sendEmail() {
        try {
            System.out.print("Enter recipient (username@ip:port): ");
            String fullAddress = userInput.nextLine();
            
            // Validate address format
            if (!fullAddress.matches("[^@]+@[^:]+:[0-9]+")) {
                System.out.println("Invalid format. Use: username@ip:port");
                return;
            }
    
            System.out.println("Enter your message (end with a line containing only '.'): ");
            StringBuilder message = new StringBuilder();
            String line;
            while (!(line = userInput.nextLine()).equals(".")) {
                message.append(line).append("\n");
            }
    
            String command = Protocol.MAIL_SEND + " " + fullAddress + " " + message.toString().trim();
            System.out.println("Debug - Sending: " + command);
            out.println(command);
            
            String response = in.readLine();
            if (response.equals(Protocol.OK)) {
                System.out.println("Email sent successfully");
            } else {
                System.out.println("Failed to send email: " + response);
            }
        } catch (IOException e) {
            System.out.println("Error sending email: " + e.getMessage());
        }
    }

    private void readEmails() {
        try {
            out.println(Protocol.MAIL_REQUEST + " mail");
            
            String line;
            System.out.println("\n=== Your Emails ===");
            
            while ((line = in.readLine()) != null) {
                if (line.equals(Protocol.OK)) {
                    break;
                }
                System.out.println(line);
            }
        } catch (IOException e) {
            System.out.println("Error reading emails");
        }
    }

    private void cleanup() {
        try {
            in.close();
            out.close();
            socket.close();
            userInput.close();
        } catch (IOException e) {
            System.out.println("Error during cleanup");
        }
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java EmailClient <server-address> <port>");
            System.out.println("Example: java EmailClient localhost 5000");
            System.exit(1);
        }

        String serverAddress = args[0];
        int port = Integer.parseInt(args[1]);
        
        EmailClient client = new EmailClient(serverAddress, port);
        client.start();
    }
}