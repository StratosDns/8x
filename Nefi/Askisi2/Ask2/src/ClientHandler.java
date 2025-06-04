import java.io.*;
import java.net.*;
import java.util.*;

public class ClientHandler implements Runnable {
    private Socket clientSocket;
    private FileServer server;
    private BufferedReader in;
    private PrintWriter out;
    private String clientId;

    
    @SuppressWarnings("CallToPrintStackTrace")
    public ClientHandler(Socket socket, FileServer server) {
        this.clientSocket = socket;
        this.server = server;
        try {
            in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            out = new PrintWriter(clientSocket.getOutputStream(), true);
            clientId = clientSocket.getInetAddress().getHostAddress() + ":" + clientSocket.getPort();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    @SuppressWarnings("CallToPrintStackTrace")
    public void run() {
        try {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                String[] parts = inputLine.split("\\s+", 2);
                String command = parts[0];

                switch (command) {
                    case Protocol.SIGNIN -> handleSignin(parts[1]);
                    case Protocol.SIGNOUT -> {
                        handleSignout();
                        return;
                    }
                    case Protocol.SEARCH -> handleSearch(parts[1]);
                    default -> out.println(Protocol.ERROR + " Unknown command");
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            handleSignout();
        }
    }

    private void handleSignin(String fileList) {
        List<String> files = Arrays.asList(fileList.split(","));
        server.getFileDatabase().registerFiles(clientId, files);
        out.println(Protocol.OK);
    }

    @SuppressWarnings("CallToPrintStackTrace")
    private void handleSignout() {
        server.getFileDatabase().removeClient(clientId);
        try {
            clientSocket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleSearch(String keywords) {
        List<String> keywordList = Arrays.asList(keywords.split(","));
        List<FileInfo> results = server.getFileDatabase().search(keywordList);
        
        StringBuilder response = new StringBuilder(Protocol.RESULTS);
        for (FileInfo file : results) {
            response.append(" ").append(file.toString());
        }
        out.println(response.toString());
    }
}