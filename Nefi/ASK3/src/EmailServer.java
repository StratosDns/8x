// EmailServer.java
import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.*;

public class EmailServer {
    private int port;
    private ServerSocket serverSocket;
    private Map<String, List<Email>> mailboxes;
    private Map<String, PrintWriter> activeClients;

    public EmailServer(int port) {
        this.port = port;
        this.mailboxes = new ConcurrentHashMap<>();
        this.activeClients = new ConcurrentHashMap<>();
    }

    public void start() {
        try {
            serverSocket = new ServerSocket(port);
            System.out.println("Email Server running on port: " + port);

            while (true) {
                Socket clientSocket = serverSocket.accept();
                new Thread(new MessageHandler(this, clientSocket)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public synchronized void addClient(String username, PrintWriter writer) {
        activeClients.put(username, writer);
        mailboxes.putIfAbsent(username, new ArrayList<>());
    }

    public synchronized void removeClient(String username) {
        activeClients.remove(username);
    }

    public synchronized void deliverMail(Email email) {
        String recipient = email.getTo();
        System.out.println("Debug - Delivering mail to mailbox: " + recipient);
        
        if (!mailboxes.containsKey(recipient)) {
            mailboxes.put(recipient, new ArrayList<>());
        }
        mailboxes.get(recipient).add(email);
        System.out.println("Debug - Mail delivered. Mailbox size: " + mailboxes.get(recipient).size());
    }

    public synchronized List<Email> getMail(String username) {
        System.out.println("Debug - Retrieving mail for: " + username);
        return mailboxes.getOrDefault(username, new ArrayList<>());
    }

    public int getPort() {
        return port;
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java EmailServer <port>");
            return;
        }
        int port = Integer.parseInt(args[0]);
        new EmailServer(port).start();
    }
}