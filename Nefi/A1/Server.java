package A1;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.HashMap;
import java.util.Map;

public class Server {
    private Map<String, User> users = new HashMap<>();
    private DatagramSocket socket;

    public Server(int port) throws SocketException {
        socket = new DatagramSocket(port);
    }

    public void start() {
        while (true) {
            try {
                String s = NetworkTools.receiveData(socket);
                String[] sp = s.split(":");
                String message = sp[0];
                String senderIP = sp[1];
                int senderPort = Integer.parseInt(sp[2]);

                String[] commandParts = message.split(" ", 2);
                String command = commandParts[0];
                String content = commandParts.length > 1 ? commandParts[1] : "";

                switch (command) {
                    case "Signin":
                        users.put(content, new User(content, senderIP, senderPort));
                        System.out.println(content + " signed in.");
                        break;
                    case "Message":
                        broadcastMessage(content, senderIP, senderPort);
                        break;
                    case "Signout":
                        users.remove(content);
                        System.out.println(content + " signed out.");
                        break;
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    private void broadcastMessage(String message, String senderIP, int senderPort) throws IOException {
        for (User user : users.values()) {
            if (!user.getIp().equals(senderIP) || user.getPort() != senderPort) {
                NetworkTools.sendData(message, InetAddress.getByName(user.getIp()), user.getPort(), socket);
            }
        }
    }

    public static void main(String[] args) {
        try {
            Server server = new Server(4242);
            server.start();
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }
}