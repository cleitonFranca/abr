<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page session="false"%>
<html>
<head>
<link rel="shortcut icon"
	href="<c:url value="/resources/images/piano.jpg" />"
	type="image/x-icon" />
<title>Login</title>
<style>
.error {
	color: #ff0000;
}
</style>
</head>
<body>
	<h2>Please login:</h2>
	<form:form action="welcome" commandName="USER" method="post">
		<div class="label">Username:</div>
		<form:input type="text" path="username" />
		<form:errors path="username" cssClass="error" />
		<br />
		<div class="label">Password:</div>
		<form:input type="password" path="password" />
		<form:errors path="password" cssClass="error" />
		<br>
		<c:if test="${USER.validUser==false}">
			<p class="error">Invalid login
			<p>
		</c:if>
		<p>
			<input type="submit" name="button" value="Login" />
		</p>
	</form:form>
</body>
</html>
