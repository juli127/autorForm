<%@ page import="ua.itea.DBWorker" %>
<%! private int attempt = 0; %>
<%! private long startTime = 0; %>

Menu: <a href='index.jsp'>Login</a> / <a href='registration.jsp'>Registration</a> / <a href='secret.jsp'>DB</a>
<form action='' method='post'>
<% 

if(request.getParameter("logout")!=null){
	session.invalidate();
	session=request.getSession();
	session.setAttribute("user",null);
}

boolean showLoginForm = true;
boolean showLogoutForm = false;
String log = request.getParameter("login");
String pass = request.getParameter("password");
String msgText = "<ul>";

if (session != null) {
	// already logged in
	if (session.getAttribute("user") != null) {
		showLoginForm = false;
		showLogoutForm = true;
		DBWorker worker = new DBWorker();
		log = (String)session.getAttribute("user");
		pass = (String)session.getAttribute("userPass");
		out.write("<br>" + worker.getLog());
		if (log != null && pass != null){
			out.write("<br><font size = 12 color='green'><center>Hi, " + worker.getName(log,pass)+ "</font><br><br>");
		}
		worker.close();
	} // not logged in yet
	else {
		boolean accessGranted = false;
		long waitTime = 0;
	
		if (log != null){
			DBWorker worker = new DBWorker();
			out.write("<br>" + worker.getLog());
			if (worker.userExists(log)){
				accessGranted = worker.correctPass(log, pass); 
				showLoginForm = ((attempt == 0) || (!accessGranted && attempt < 3));
				if(accessGranted){
					session.setAttribute("user",log);
					session.setAttribute("userPass",pass);
					attempt = 0;
					showLoginForm = false;
					showLogoutForm = true;
					out.write("<br><font size = 12 color='green'><center>Hi, " + worker.getName(log, pass) + "</font><br>");
				}else { 
					if (attempt >= 3) {
						if (attempt == 3) {
							startTime = System.currentTimeMillis();
						}
						waitTime = 15 - (System.currentTimeMillis() - startTime)/1000 ; 
						if (waitTime > 0) { 
							msgText += "<br><font color='red'><b> Form will be shown in " + waitTime + " seconds</b></font>";
							attempt++; 
						} else {
							attempt = 0;
							showLoginForm = true;
							log = null;
							pass = null;
						}
					} else if (attempt > 0){
						msgText += "<b><font color='red'><li>Wrong password, try again! (attempt #" + attempt + ")</li>";
					}						
				}
			} else {
				out.write(worker.getLog());
				attempt = 0;
				showLoginForm = false;
				out.write("<br><b><font color='green'><center>User with this login does not exist yet.</b>");
				out.write("<br><b><font color='green'><center>You can register here:  </b>");
				%> <a href='registration.jsp'>Registration</a> <%
			}
			worker.close();
			msgText +="</b></font>";
		} else {
			attempt = 0;
		}
	}
	msgText+="</ul>";
}
	
if (showLoginForm){ 
	attempt++;
%>
	<center>
	<table border=0>
		<tr>
			<table border=0>
				<tr>
					<td>Login</td>
					<td><input type='email' required name='login' value='<%=(log!=null?log:"")%>' /></td>
				</tr>
				<tr>
					<td>Password</td>
					<td><input type='password' required name='password' /></td>
				</tr>
					<td></td><td align='right'><input type='submit' value='Submit' /></td>
				</tr>
			</table>
		</tr>
<% 
}
	
if (showLogoutForm){ 
	%>
	<form action="" method="post">
		<input type='hidden' name='logout' value='logged out'/>
		<input type='submit' value='logout' />
	</form>
	<%
}

%>
	<tr> 
		<table border=0>
			<td></td>
			<td align = 'left'>
			<%=msgText%>
		</td>
		</table>
	</tr>
	</table>
</form>