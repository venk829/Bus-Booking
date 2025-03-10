<%@ include file="DBConnection.jsp" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>

<html>
<head>
    <title>Bus Booking System - Home</title>

    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* Navigation Bar */
        .navbar {
            background: #007bff;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            font-weight: bold;
        }

        .navbar a:hover {
            background: white;
            color: #007bff;
            border-radius: 5px;
        }

        /* Hero Section */
        .hero {
            background: url('bus-background.jpg') center/cover no-repeat;
            height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 2px 2px 5px black;
            font-size: 32px;
            font-weight: bold;
        }

        /* Main Container */
        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            text-align: center;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
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
            width: 100%;
        }

        .btn:hover {
            background: #0056b3;
        }

        /* Popular Routes */
        .popular-routes {
            margin-top: 30px;
            text-align: left;
        }

        .route-card {
            background: #f9f9f9;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .route-card .btn {
            width: auto;
            padding: 8px 12px;
        }

        /* Footer */
        footer {
            margin-top: 20px;
            padding: 15px;
            background: #007bff;
            color: white;
            font-size: 14px;
            text-align: center;
        }
    </style>
</head>

<body>

    <!-- Navigation Bar -->
    <div class="navbar">
        <a href="index.jsp"> Home</a>
        <div>
            <a href="login.jsp"> Login</a>
            <a href="register.jsp">Register</a>
        </div>
    </div>

    <!-- Hero Section -->
    <div class="hero">
         Book Your Bus Tickets Easily & Comfortably!
    </div>

    <!-- Main Search Section -->
    <div class="container">
        <h2> Search for a Bus</h2>

        <form action="search.jsp" method="GET">
            <div class="form-group">
                <label>From:</label>
                <select name="source" required>
                    <option value="">Select Source</option>
                    <% 
                        Connection con = getConnection();
                        PreparedStatement pst = con.prepareStatement("SELECT DISTINCT source FROM routes");
                        ResultSet rs = pst.executeQuery();
                        while (rs.next()) { 
                    %>
                        <option value="<%= rs.getString("source") %>"><%= rs.getString("source") %></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>To:</label>
                <select name="destination" required>
                    <option value="">Select Destination</option>
                    <% 
                        rs = pst.executeQuery(); // Reset ResultSet for destination
                        while (rs.next()) { 
                    %>
                        <option value="<%= rs.getString("source") %>"><%= rs.getString("source") %></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Date of Journey:</label>
                <input type="date" name="journey_date" required>
            </div>

            <div class="form-group">
                <input type="submit" value="Search Buses" class="btn">
            </div>
        </form>
    </div>

    <!-- Popular Routes -->
    <div class="container popular-routes">
        <h2> Popular Routes</h2>
        
        <div class="route-card">
            <span> Vijayawada------------ Mumbai</span>
            <a href="search.jsp?source=Delhi&destination=Mumbai" class="btn">Find Buses</a>
        </div>
        <div class="route-card">
            <span> Vijayawada ------------ Hyderabad</span>
            <a href="search.jsp?source=Bangalore&destination=Hyderabad" class="btn">Find Buses</a>
        </div>
        <div class="route-card">
            <span> Vijayawada -------------- Channai</span>
            <a href="search.jsp?source=Chennai&destination=Kolkata" class="btn">Find Buses</a>
        </div>
    </div>

    <footer>© 2024 Bus Booking System | Designed for Comfort & Convenience</footer>

</body>
</html>
