public class Email {
    private String from;
    private String to;
    private String content;
    private String timestamp;

    public Email(String from, String to, String content) {
        this.from = from;
        this.to = to;
        this.content = content;
        this.timestamp = new java.util.Date().toString();
        System.out.println("Debug - Created email from " + from + " to " + to);
    }

    public String getFrom() { return from; }
    public String getTo() { return to; }
    public String getContent() { return content; }
    public String getTimestamp() { return timestamp; }

    @Override
    public String toString() {
        return "From: " + from + "\nDate: " + timestamp + "\nMessage: " + content;
    }
}