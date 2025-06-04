import java.io.Serializable;

public class Email implements Serializable {
    public String from;
    public String to;
    public String text;

    public Email(String from, String to, String text) {
        this.from = from;
        this.to = to;
        this.text = text;
    }

    @Override
    public String toString() {
        return "From: " + from + "\nTo: " + to + "\nMessage: " + text;
    }
}
