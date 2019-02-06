<%@ page import="ua.itea.DBWorker" %>
Menu: <a href='index.jsp'>Login</a> / <a href='registration.jsp'>Registration</a> / <a href='secret.jsp'>DB</a>

<form action='' method='get'>
<% 
String usr = (String) session.getAttribute("user");
if(usr != null && usr.equals("admin@a")){
	out.write("<br><b><center><font color='green'>SECRET INFO: </font></b><br>");
	DBWorker worker = new DBWorker();
	out.write("<br><b><center><font color='green'> All records from DB for admin </font></b><br>");
	out.write(worker.getAllUsers());
	worker.close();
 }else{
	out.write("<br><b><center><font color='red'>ACCESS DENIED</font></b><br>");
}
%>
</form>
 

