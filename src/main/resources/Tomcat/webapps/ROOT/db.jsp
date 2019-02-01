<%@ page import="ua.itea.DBWorker" %>
Menu: <a href='index.jsp'>Home</a> / <a href='db.jsp'>DB</a>
<%

		DBWorker worker = new DBWorker();
		out.write(worker.getRows());
		worker.close();
		
%>

 

