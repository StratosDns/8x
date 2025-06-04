package LAB1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

public class Client 
{
	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Error: you forgot <server IP>");
			return;
		}


		InetAddress serverAddress = null;
		int serverPort = 4242;
		DatagramSocket socket = null;

		//Metatroph IP paralipth apo String se InetAddress
		String serverIP = args[0];
		try {
			serverAddress = InetAddress.getByName(serverIP);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
	
		//Dhmiourgeia socket gia send kai receive.
		try {
                	socket = new DatagramSocket();
            	}catch (SocketException e) {
                	e.printStackTrace();
            	}	

                BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		while (true) 
                {
                    try 
                    {
                        String data = br.readLine();
                        NetworkTools.sendData(data, serverAddress, serverPort, socket);
                    }
                    catch (IOException e) 
                    {
                        e.printStackTrace();
                    }
                }	
	}
}