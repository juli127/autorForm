<%@ page import="ua.itea.DBWorker" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

Menu: <a href='index.jsp'>Login</a> / <a href='registration.jsp'>Registration</a> / <a href='secret.jsp'>DB</a>
<form action='registration.jsp' method='post'>
<% 

if(request.getParameter("logout")!=null){
	session.invalidate();
	session=request.getSession();
	session.setAttribute("user",null);
}
	String log = request.getParameter("login");
	String pass = request.getParameter("password");
	String name = request.getParameter("name");
	String repass = request.getParameter("repassword");
	String gender = request.getParameter("gender");
	String age = request.getParameter("age");
	String address = request.getParameter("address");
	String comment = request.getParameter("comment");
	String agree = request.getParameter("agree");
	
	boolean showRegForm = true;
	boolean showLogoutForm = false;
	boolean errors = false;
	String msgText = "<font color='red'><ul>";
	
	if (session != null) {
		// already logged in
	if (session.getAttribute("user") != null) {
		showRegForm = false;
		showLogoutForm = true;
		DBWorker worker = new DBWorker();
		log = (String)session.getAttribute("user");
		pass = (String)session.getAttribute("userPass");
		if (log != null && pass != null){
			out.write("<br><b><font color='green'><center>Hi, " + worker.getName(log,pass)+ ". <br>You are registered already.</font><b><br><br>");
		}
		worker.close();
	} // not logged in yet
	else {
		if (pass != null){
			if (log.length() < 1) {
				errors = true;
				msgText += "<li>Empty login!</li>";
			}
			if(name.length()<1){
				errors=true;
				msgText+="<li>Empty name!</li>";
			}
		
			String patternString = "([0-9a-zA-Z]+){4,}";
			Pattern pattern = Pattern.compile(patternString);
			Matcher matcher = pattern.matcher(pass);
			if(!matcher.matches()){
				errors=true;
				msgText+="<li>Password should has minimum 4 symbols <br>with at least one upper case letter and 1 digit! </li>";
			}
			if(!pass.equals(repass)){
				errors=true;
				msgText+="<li>Password and retyped password are not the same! </li>";
			}
			if(gender == null){
				errors=true;
				msgText+="<li>Empty gender!</li>";
			}
			if(address == null){
				errors=true;
				msgText+="<li>Empty address!</li>";
			}
		
			if (errors){
				showRegForm = true;
			} else {
				showRegForm = false;
				DBWorker worker = new DBWorker();
				int addedRecords = worker.addUser(log, pass, name, age, gender, address, comment, agree);
				if (addedRecords > 0){
					out.write("<br><font color='green'><center>OK, " + name + "! <br>You are registered now.");
				}	
				worker.close();
			}
		}
	}
	msgText+="</ul></font>";
}

if (showRegForm){
%>
<center>
<table border=0>
	<tr>
		<table border=0>
			<tr>
				<td>Login:</td>
				<td><input type='email' required name='login' value='<%=(log!=null?log:"")%>' /></td>
			</tr>
			<tr>
				<td>Name:</td>
				<td><input type='text'  name='name' value='<%=(name!=null?name:"")%>'/></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type='password'  name='password' /></td>
			</tr>
			<tr>
				<td>Retype Password:</td>
				<td ><input type='password'  name='repassword' /></td>
			</tr>
			<tr>
				<td>Age:</td><td><input type='age' name='age' value='<%=(age!=null?age:"")%>' /></td>
			</tr>
			<tr>
				<td>Gender:</td>
				<td><input name='gender' type='radio' value='Male' <%=(gender !=null && gender.equals("Male")?"checked":"")%> />Male
					<input name='gender' type='radio' value='Female' <%=(gender !=null && gender.equals("Female")?"checked":"")%> />Female
				</td>
			</tr>
			<tr>
				<td>Address:</td>
				<td><select name='address'  >
				<option value='Kiev' <%=(address!=null && address.equals("Kiev")?"selected":"")%>>Kiev</option>
				<option value='Lviv' <%=(address!=null && address.equals("Lviv")?"selected":"")%>>Lviv</option>
				<option value='Odessa' <%=(address!=null && address.equals("Odessa")?"selected":"")%>>Odessa</option>
				</select>
				</td>
			</tr>
			<tr>
				<td>Comment:</td>
				<td ><textarea cols='40' rows='10' name='comment' align = 'left' value='<%=(comment!=null?comment:"")%>' >
					</textarea>
				</td>
			</tr>
			<tr>
				<td><input type='checkbox' name='agree' />I agree to receive all spam</td>
			</tr>
			<tr>
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