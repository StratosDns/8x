import java.io.*;
import java.net.*;
import java.util.*;

public class EmailServer {
    private static int PORT; 
    private static final Map<String, List<Email>> inboxes = new HashMap<>();

    public static void main(String[] args) throws IOException {
        if (args.length != 1) {
            System.out.println("Usage: java EmailServer <port>");
            System.exit(1);
        }

        // Get port from command line arguments
        PORT = Integer.parseInt(args[0]);
        
        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println("Email Server running on port " + PORT);

        while (true) {
            Socket socket = serverSocket.accept();
            new Thread(() -> handleClient(socket)).start();
        }
    }

    private static void handleClient(Socket socket) {
        try (ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream())) {

            String command = (String) in.readObject();

            switch (command) {
                case "signin":
                    out.writeObject("ok");
                    break;

                case "mail":
                    String user = (String) in.readObject();
                    List<Email> emails = inboxes.getOrDefault(user, new ArrayList<>());
                    out.writeObject(emails);
                    break;

                case "mail user from text": {
                    String toUser = (String) in.readObject();
                    String fromUser = (String) in.readObject();
                    String msg = (String) in.readObject();

                    Email email = new Email(fromUser, toUser, msg);
                    inboxes.computeIfAbsent(toUser, k -> new ArrayList<>()).add(email);
                    out.writeObject("ok");
                    break;
                }

                case "mail user@ip:port text": {
                    String fullTo = (String) in.readObject(); 
                    String fromUser = (String) in.readObject();
                    String msg = (String) in.readObject();

                    String[] parts = fullTo.split("@|:");
                    String toUser = parts[0];
                    String ip = parts[1];
                    int port = Integer.parseInt(parts[2]);

                    try (Socket relaySocket = new Socket(ip, port);
                         ObjectOutputStream relayOut = new ObjectOutputStream(relaySocket.getOutputStream());
                         ObjectInputStream relayIn = new ObjectInputStream(relaySocket.getInputStream())) {

                        relayOut.writeObject("mail user from text");
                        relayOut.writeObject(toUser);
                        relayOut.writeObject(fromUser);
                        relayOut.writeObject(msg);

                        String reply = (String) relayIn.readObject();
                        out.writeObject(reply);
                    } catch (Exception e) {
                        out.writeObject("error sending to remote server: " + e.getMessage());
                    }
                    break;
                }

                default:
                    out.writeObject("unknown command");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
