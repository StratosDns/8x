import java.util.*;

public class FileDatabase {
    @SuppressWarnings("FieldMayBeFinal")
    private Map<String, Set<FileInfo>> fileRegistry;
    @SuppressWarnings("FieldMayBeFinal")
    private Map<String, Set<FileInfo>> clientFiles; // IP:Port -> Files

    public FileDatabase() {
        fileRegistry = new HashMap<>();
        clientFiles = new HashMap<>();
    }

    public synchronized void registerFiles(String clientId, List<String> filenames) {
        String[] clientInfo = clientId.split(":");
        String ip = clientInfo[0];
        int port = Integer.parseInt(clientInfo[1]);

        Set<FileInfo> files = new HashSet<>();
        for (String filename : filenames) {
            FileInfo fileInfo = new FileInfo(filename, ip, port);
            files.add(fileInfo);
            fileRegistry.computeIfAbsent(filename, k -> new HashSet<>()).add(fileInfo);
        }
        clientFiles.put(clientId, files);
    }

    public synchronized void removeClient(String clientId) {
        Set<FileInfo> files = clientFiles.remove(clientId);
        if (files != null) {
            for (FileInfo file : files) {
                Set<FileInfo> fileSet = fileRegistry.get(file.getFilename());
                if (fileSet != null) {
                    fileSet.remove(file);
                    if (fileSet.isEmpty()) {
                        fileRegistry.remove(file.getFilename());
                    }
                }
            }
        }
    }

    public synchronized List<FileInfo> search(List<String> keywords) {
        Set<FileInfo> results = new HashSet<>();
        boolean firstKeyword = true;

        for (String keyword : keywords) {
            Set<FileInfo> keywordResults = new HashSet<>();
            for (Map.Entry<String, Set<FileInfo>> entry : fileRegistry.entrySet()) {
                if (entry.getKey().contains(keyword)) {
                    keywordResults.addAll(entry.getValue());
                }
            }

            if (firstKeyword) {
                results.addAll(keywordResults);
                firstKeyword = false;
            } else {
                results.retainAll(keywordResults);
            }
        }

        return new ArrayList<>(results);
    }
}