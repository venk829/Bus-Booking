<%@ page session="true" %>
<%
    session.invalidate(); // Destroy session
%>
<html>
<head>
    <title>Logout - Bus Booking System</title>

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
            margin-top: 100px;
        }

        /* Header */
        h2 {
            color: #007bff;
            margin-bottom: 20px;
        }

        /* Message */
        .message {
            font-size: 18px;
            color: green;
            margin-bottom: 20px;
        }

        /* Buttons */
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background: #0056b3;
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
        <h2>🔓 Logout Successful</h2>
        <p class="message">You have been successfully logged out.</p>
        <a href="login.jsp" class="btn">Login Again</a>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>
