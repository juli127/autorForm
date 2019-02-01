Menu: <a href='index.jsp'>Home</a> / <a href='db.jsp'>DB</a>
<% 
	String login = request.getParameter("login");
	String pass = request.getParameter("password");
	String name = request.getParameter("name");
	String repass = request.getParameter("repassword");
	String gender = request.getParameter("gender");
	String address = request.getParameter("address");
	String comment = request.getParameter("comment");
	String agree = request.getParameter("agree");
	
	boolean showLoginForm = true;
	boolean errors = false;
	String errorText = "<font color='red'><ul>";
	
	if (login != null){
		if (login.length() < 1) {
			errors = true;
			errorText += "<li>Empty login</li>";
		}
		if(name.length()<1){
			errors=true;
			errorText+="<li>Empty name</li>";
		}
		if(pass.length()<8){
			errors=true;
			errorText+="<li>Password should has minimum 8 symbols with at least one upper case letter and 2 digits </li>";
		}
		if(!pass.equals(repass)){
			errors=true;
			errorText+="<li>Password and retyped password are not the same! Try again</li>";
		}
		if(gender == null){
			errors=true;
			errorText+="<li>Empty gender</li>";
		}
		if(address == null){
			errors=true;
			errorText+="<li>Empty address</li>";
		}
		
	if (errors){
		showLoginForm = true;%>
		<form action='index.jsp' method='post'>
	<%} else {
		showLoginForm = false;%>
		<form action='DB.jsp' method='get'>
	<%	out.write("Data is valid! It was saved to DB:")	;
	}
	}
	errorText+="</ul></font>";

	if (showLoginForm){
%>
<center>
<table border=1>
	<td>
		<table border=0>
			<tr>
				<td>Login:</td>
				<td><input type='email' required name='login' value='<%=(login!=null?login:"")%>' /></td>
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
				<td>Gender:</td>
				<td><input name='gender' type='radio' value='Male' <%=(gender !=null && gender.equals("Male")?"checked":"")%> />Male
					<input name='gender' type='radio' value='Female' <%=(gender !=null && gender.equals("Female")?"checked":"")%> />Female
				</td>
			</tr>
			<tr>
				<td>Address:</td>
				<td><select name='address'  >
				<option value='1' <%=(address!=null && address.equals("1")?"selected":"")%>>Kiev</option>
				<option value='2' <%=(address!=null && address.equals("2")?"selected":"")%>>Lviv</option>
				<option value='3' <%=(address!=null && address.equals("3")?"selected":"")%>>Odessa</option>
				</select>
				</td>
			</tr>
			<tr>
				<td>Comment:</td>
				<td ><textarea cols='40' rows='10' name='comment' >
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
		</td>
	<td>
		<%=errorText%>
	</td>
	</table>
	</center>
</form>
<% 
	}
%>