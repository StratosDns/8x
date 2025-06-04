import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.HashMap;
import java.util.Map;

public class Server {
    private Map<String, User> users = new HashMap<>();
    private final DatagramSocket socket;

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
                    
                    case "Signin" -> {
                        if (!users.containsKey(content)) {
                            users.put(content, new User(content, senderIP, senderPort));
                            System.out.println(content + " signed in.");
                            NetworkTools.sendData("Username accepted", InetAddress.getByName("127.0.0.1"), senderPort, socket);
                        } else {
                            NetworkTools.sendData("Username already in use", InetAddress.getByName("127.0.0.1"), senderPort, socket);
                        }
                    }
                    case "Message" -> {
                        String senderUsername = getUsernameByIPAndPort(senderIP, senderPort);
                        if (senderUsername != null) {
                            broadcastMessage(senderUsername + ": " + content, senderIP, senderPort);
                        }
                    }
                    case "Signout" -> {
                        if (users.containsKey(content)) {
                            users.remove(content);
                            System.out.println(content + " signed out.");
                        } else {
                            System.out.println("Signout failed: User " + content + " does not exist.");
                        }
                    }
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    private String getUsernameByIPAndPort(String ip, int port) {
        for (User user : users.values()) {
            if (user.getIp().equals(ip) && user.getPort() == port) {
                return user.getUsername();
            }
        }
        return null;
    }

    private void broadcastMessage(String message, String senderIP, int senderPort) throws IOException {
        for (User user : users.values()) {
            if (!user.getIp().equals(senderIP) || user.getPort() != senderPort) {
                InetAddress userAddress = InetAddress.getByName("127.0.0.1");
                NetworkTools.sendData(message, userAddress, user.getPort(), socket);
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