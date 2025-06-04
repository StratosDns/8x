package LAB2;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.ServerSocket;

class ServerThread extends Thread
{
    Socket s;

    public ServerThread(Socket s)
    {
        this.s = s;
    }

    public void run()
    {
        try
        {
            BufferedReader br = new BufferedReader(new InputStreamReader(s.getInputStream()));
            while (true)
            {
                String message = br.readLine();
                System.out.println(message);
            }
        }
        catch (IOException e) {e.printStackTrace();}
    }

}

public class Server 
{
    
    public static void main(String args[]) 
    {
        ServerSocket serverSocket = null;

        try 
        {
            serverSocket = new ServerSocket(4242);
        } 
        catch (Exception ex) 
        {
            ex.printStackTrace();
        }
        
        while (true) 
        {
            Socket clientSocket = null;
            try 
            {
                clientSocket = serverSocket.accept();
                new ServerThread(clientSocket).start();
            }
            catch (IOException e)
            {
               e.printStackTrace();
            }
            
            
        }
    }
}
