package ua.itea;

public class Main {

    public static void main (String[] args) {

        DBWorker worker = new DBWorker();
//        worker.addUser("lex@ukr.net","1111", "Alex", "34", "Male", "Kiev", "call before delivery", "no");
//        worker.addUser("alex@ukr.net","admin", "Alexander", "43", "Male", "Kiev", "call before delivery", "no");
//        worker.addUser("mash198@ukr.net","1111", "Masha", "28", "Female", "Odessa", "call before delivery", "no");
//        worker.addUser("admin@a","admin", "admin", "40", "Male", "Kiev", "", "no");

//        System.out.println("User exists? " + worker.userExists("alex@ukr.net"));
//        System.out.println("Correct pass? " + worker.correctPass("alex@ukr.net", "admin"));
        System.out.println("Name for  alex@ukr.net: " + worker.getName("alex@ukr.net", "admin"));
        worker.close();
    }
}
