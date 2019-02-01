package ua.itea;

public class Main {

    public static void main (String[] args) {
        DBWorker worker = new DBWorker();
        System.out.println(worker.getRows());
        worker.close();
    }
}
