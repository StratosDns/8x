import javax.swing.*;
import javax.swing.text.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

public class ClientGUI {
    private static DatagramSocket socket;
    private static InetAddress serverAddress;
    private static int serverPort = 4242;
    private static JFrame chatFrame;
    private static JTextPane chatPane;
    private static String username;

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Error: you forgot <server IP>");
            return;
        }

        try {
            serverAddress = InetAddress.getByName(args[0]);
            socket = new DatagramSocket();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        showLoginWindow();
    }

    private static void showLoginWindow() {
        JFrame loginFrame = new JFrame("Login");
        JTextField usernameField = new JTextField(20);
        JButton submitButton = new JButton("Submit");
        JLabel warningLabel = new JLabel("");
        warningLabel.setForeground(Color.RED);

        submitButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                username = usernameField.getText().trim();
                if (!username.isEmpty()) {
                    try {
                        Client.sendData("Signin " + username, serverAddress, serverPort, socket);
                        String response = Client.receiveData(socket);
                        if (response.startsWith("Username accepted")) {
                            showChatWindow();
                            loginFrame.dispose();
                        } else {
                            warningLabel.setText("Username already in use. Try again.");
                        }
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        });

        loginFrame.setLayout(new FlowLayout());
        loginFrame.add(new JLabel("Enter Username:"));
        loginFrame.add(usernameField);
        loginFrame.add(submitButton);
        loginFrame.add(warningLabel);
        loginFrame.setSize(300, 150);
        loginFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        loginFrame.setVisible(true);
    }

    private static void showChatWindow() {
        chatFrame = new JFrame("Chatroom - " + username);
        chatPane = new JTextPane();
        chatPane.setEditable(false);
        chatPane.setPreferredSize(new Dimension(780, 400));
        JTextField messageField = new JTextField(50);
        JButton sendButton = new JButton("Send");
        JButton signOutButton = new JButton("Sign Out");

        sendButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String message = messageField.getText().trim();
                if (!message.isEmpty()) {
                    try {
                        Client.sendData("Message " + message, serverAddress, serverPort, socket);
                        appendMessage(username + ": " + message, true);
                        messageField.setText("");
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        });

        signOutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    Client.sendData("Signout " + username, serverAddress, serverPort, socket);
                    chatFrame.dispose();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        });

        chatFrame.setLayout(new BorderLayout());
        chatFrame.add(new JScrollPane(chatPane), BorderLayout.CENTER);
        JPanel panel = new JPanel();
        panel.add(messageField);
        panel.add(sendButton);
        panel.add(signOutButton);
        chatFrame.add(panel, BorderLayout.SOUTH);
        chatFrame.setSize(780, 500);
        chatFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        chatFrame.setVisible(true);

        new Thread(() -> {
            while (true) {
                try {
                    String receivedMessage = Client.receiveData(socket);
                    appendMessage(receivedMessage, false);
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        }).start();
    }

    private static void appendMessage(String message, boolean isSender) {
        StyledDocument doc = chatPane.getStyledDocument();
        SimpleAttributeSet attributes = new SimpleAttributeSet();
        StyleConstants.setForeground(attributes, isSender ? Color.BLUE : Color.BLACK);

        try {
            doc.insertString(doc.getLength(), message + "\n", attributes);
        } catch (BadLocationException e) {
            e.printStackTrace();
        }
    }
}