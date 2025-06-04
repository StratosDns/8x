

// FileServer.java
import java.io.*;
import java.net.*;
import java.util.*;



public class FileServer {
    private ServerSocket serverSocket;
    private FileDatabase fileDatabase;
    private List<ClientHandler> clients;
    
    @SuppressWarnings("CallToPrintStackTrace")
    public FileServer(int port) {
        try {
            serverSocket = new ServerSocket(port);
            fileDatabase = new FileDatabase();
            clients = new ArrayList<>();
            
            // Get the server's IP address
            String serverIP = InetAddress.getLocalHost().getHostAddress();
            System.out.println("Server is running: " + serverIP + ":" + port);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public void start() {
        while (true) {
            try {
                Socket clientSocket = serverSocket.accept();
                ClientHandler clientHandler = new ClientHandler(clientSocket, this);
                clients.add(clientHandler);
                System.out.println("New client connected from: " + 
                    clientSocket.getInetAddress().getHostAddress() + ":" + 
                    clientSocket.getPort());
                new Thread(clientHandler).start();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public FileDatabase getFileDatabase() {
        return fileDatabase;
    }

    public static void main(String[] args) {
        FileServer server = new FileServer(5000);
        server.start();
    }
}