import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.List;

public class MessageHandler implements Runnable {
    private Socket clientSocket;
    private EmailServer server;
    private BufferedReader in;
    private PrintWriter out;
    private String username;

    public MessageHandler(EmailServer server, Socket socket) {
        this.server = server;
        this.clientSocket = socket;
        try {
            this.in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            this.out = new PrintWriter(socket.getOutputStream(), true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void run() {
        try {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                System.out.println("Server received: " + inputLine); // Debug
                String[] parts = inputLine.split(" ", 2);
                int command = Integer.parseInt(parts[0]);

                switch (command) {
                    case Protocol.SIGNIN:
                        handleSignin(parts[1]);
                        break;
                    case Protocol.MAIL_SEND:
                        handleMailSend(parts[1]);
                        break;
                    case Protocol.MAIL_REQUEST:
                        handleMailRequest();
                        break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleMailSend(String mailData) {
        try {
            String[] parts = mailData.split(" ", 2);
            String fullAddress = parts[0];  // format: username@ip:port
            String content = parts[1];

            // Parse the address
            String[] addressParts = fullAddress.split("@");
            String recipient = addressParts[0];
            
            System.out.println("Debug - Delivering mail to: " + recipient);

            // Create and store the email
            Email email = new Email(username, recipient, content);
            server.deliverMail(email);
            
            System.out.println("Debug - Mail delivered from " + username + " to " + recipient);
            out.println(Protocol.OK);
        } catch (Exception e) {
            System.out.println("Error in handleMailSend: " + e.getMessage());
            e.printStackTrace();
            out.println(Protocol.ERROR);
        }
    }

    private void forwardEmail(String recipient, String targetIP, int targetPort, String content) {
        try {
            // Connect to the other server
            Socket forwardSocket = new Socket(targetIP, targetPort);
            PrintWriter forwardOut = new PrintWriter(forwardSocket.getOutputStream(), true);
            BufferedReader forwardIn = new BufferedReader(new InputStreamReader(forwardSocket.getInputStream()));
    
            // Send forward command
            String command = Protocol.MAIL_FORWARD + " " + recipient + " " + username + " " + content;
            forwardOut.println(command);
    
            // Wait for response
            String response = forwardIn.readLine();
            out.println(response);
    
            forwardSocket.close();
        } catch (IOException e) {
            out.println(Protocol.ERROR + " Forward failed");
            e.printStackTrace();
        }
    }

    private void handleMailRequest() {
        try {
            List<Email> emails = server.getMail(username);
            System.out.println("Debug - Found " + emails.size() + " emails for " + username);

            if (emails.isEmpty()) {
                out.println("No messages in your mailbox.");
            } else {
                for (Email email : emails) {
                    out.println("=== New Message ===");
                    out.println("From: " + email.getFrom());
                    out.println("Message: " + email.getContent());
                    out.println("=================");
                }
            }
            out.println(Protocol.OK);
        } catch (Exception e) {
            System.out.println("Error in handleMailRequest: " + e.getMessage());
            out.println(Protocol.ERROR);
        }
    }

    private void handleSignin(String username) {
        this.username = username;
        server.addClient(username, out);
        out.println(Protocol.OK);
        System.out.println("Server: User signed in: " + username);
    }
}