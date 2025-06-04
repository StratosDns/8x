

public class FileInfo {
    private final String filename;
    private final String ip;
    private final int port;

    public FileInfo(String filename, String ip, int port) {
        this.filename = filename;
        this.ip = ip;
        this.port = port;
    }

    // Getters and setters
    public String getFilename() { return filename; }
    public String getIp() { return ip; }
    public int getPort() { return port; }

    @Override
    public String toString() {
        return filename + ":" + ip + ":" + port;
    }
}