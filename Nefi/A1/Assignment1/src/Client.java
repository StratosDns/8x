import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Arrays;

public class Client {

    public static void sendData(String data, InetAddress address, int port, DatagramSocket socket) throws IOException
    {
            byte[] dataToSend = data.getBytes(); // Metatroph mhnumatos apo String se pinaka apo byte
            DatagramPacket packet = new DatagramPacket(dataToSend, dataToSend.length, address, port);
            socket.send(packet);
    }

    public static String receiveData(DatagramSocket socket) throws IOException
    {
        byte[] msg = new byte[200];
        Arrays.fill(msg, (byte)0); //delete previous message
        DatagramPacket packet = new DatagramPacket(msg, 200);
        socket.receive(packet);
        return new String(packet.getData(), 0, packet.getLength())+":"+packet.getAddress()+":"+packet.getPort();
    }
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Error: you forgot <server IP>");
            return;
        }

        InetAddress serverAddress = null;
        int serverPort = 4242;
        final DatagramSocket socket;

        String serverIP = args[0];
        try {
            serverAddress = InetAddress.getByName(serverIP);
        } catch (UnknownHostException e) {
            e.printStackTrace();
            return;
        }

        try {
            socket = new DatagramSocket();
            System.out.println("Client created with IP: " + InetAddress.getLocalHost().getHostAddress() + " and port: " + socket.getLocalPort());
        } catch (SocketException | UnknownHostException e) {
            e.printStackTrace();
            return;
        }

        // Νήμα για λήψη μηνυμάτων
        new Thread(() -> {
            while (true) {
                try {
                    String receivedMessage = receiveData(socket);
                    System.out.println("Received: " + receivedMessage);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        boolean signedIn = false;
        while (true) {
            try {
                String data = br.readLine();
                if (data.startsWith("Signin")) {
                    if (signedIn) {
                        System.out.println("Already signed in.");
                        continue;
                    } else {
                        signedIn = true;
                    }
                } else if (data.startsWith("Signout")) {
                    signedIn = false;
                }
                sendData(data, serverAddress, serverPort, socket);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}