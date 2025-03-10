<%@ include file="DBConnection.jsp" %>
<html>
<head>
    <title>Login - Bus Booking System</title>

    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        /* Container */
        .container {
            max-width: 400px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        /* Header */
        h2 {
            color: #007bff;
            margin-bottom: 20px;
        }

        /* Form Styles */
        form {
            text-align: left;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        /* Input Fields */
        input[type="email"], 
        input[type="password"], 
        select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        /* Buttons */
        input[type="submit"] {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background: #0056b3;
        }

        /* Error Message */
        .error {
            color: red;
            margin-top: 10px;
        }

        /* Footer */
        footer {
            margin-top: 20px;
            padding: 10px;
            background: #007bff;
            color: white;
            font-size: 14px;
        }
    </style>

</head>
<body>

    <div class="container">
        <h2> Login to Your Account</h2>

        <% if ("POST".equalsIgnoreCase(request.getMethod())) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            Connection con = getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ? AND role = ?");
            pst.setString(1, email);
            pst.setString(2, password);
            pst.setString(3, role);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));

                if ("ADMIN".equals(role)) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("user-dashboard.jsp");
                }
            } else { %>
                <p class="error">❌ Invalid Email, Password, or Role.</p>
        <%  } 
            con.close();
        } %>

        <form method="post">
            <label>Email:</label>
            <input type="email" name="email" required placeholder="Enter your email">

            <label>Password:</label>
            <input type="password" name="password" required placeholder="Enter your password">

            <label>Role:</label>
            <select name="role">
                <option value="USER">User</option>
                <option value="ADMIN">Admin</option>
            </select>

            <input type="submit" value="Login">
        </form>

        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>
