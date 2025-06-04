package LAB2;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Client 
{

	public static void main(String[] args) 
        {
		if (args.length != 1) {
			System.out.println("Error: you forgot <server IP>");
			return;
		}

		String serverIP = args[0];
                Socket socket = null;
                PrintWriter pw = null;
                BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                
		try 
                {
			socket = new Socket(serverIP, 4242);
                        pw = new PrintWriter(socket.getOutputStream());
		} 
                catch (Exception e) 
                {
			e.printStackTrace();
		}
                
		while (true) 
                {
                    try 
                    {
                        String data = br.readLine();
                        pw.println(data);
                        pw.flush();
                    }
                    catch (IOException e) 
                    {
                        e.printStackTrace();
                    }
                }	
	}
}