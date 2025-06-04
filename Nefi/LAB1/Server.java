package LAB1;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.SocketException;

public class Server 
{   
    public static void main(String args[]) 
    {
        DatagramSocket socket = null;
        
        //Dhmiourgeia socket gia send kai receive
        try 
        {
            socket = new DatagramSocket(4242);
        } 
        catch (SocketException ex) 
        {
            ex.printStackTrace();
        }
        
        while (true) 
        {
            try 
            {
                String s = NetworkTools.receiveData(socket);
                String []sp = s.split(":"); //sp[0] = keimeno mhnymatos, sp[1] = IP apostolea san String, sp[2]= port apostolea san String
                System.out.println("Message: "+sp[0]+" from "+sp[1]+":"+Integer.parseInt(sp[2]));
            } 
            catch (IOException ex) 
            {
                ex.printStackTrace();
            }
        }
    }
}
