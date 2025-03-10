<%@ include file="DBConnection.jsp" %>
<%@ page session="true" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>

<%
    Integer adminId = (Integer) session.getAttribute("user_id");
    String role = (String) session.getAttribute("role");

    if (adminId == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = getConnection();

    // Handle Route Addition
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        int distance = Integer.parseInt(request.getParameter("distance"));

        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO routes (source, destination, distance) VALUES (?, ?, ?)"
        );
        pst.setString(1, source);
        pst.setString(2, destination);
        pst.setInt(3, distance);
        pst.executeUpdate();
    }

    // Retrieve all routes
    PreparedStatement pst = con.prepareStatement("SELECT * FROM routes");
    ResultSet rs = pst.executeQuery();
%>

<html>
<head>
    <title>Manage Routes - Admin Panel</title>

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
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        /* Header */
        h2 {
            color: #007bff;
            margin-bottom: 20px;
        }

        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background: #007bff;
            color: white;
        }

        /* Form Styles */
        .form-container {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

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
            margin-top: 10px;
            display: inline-block;
            text-decoration: none;
        }

        .btn:hover {
            background: #0056b3;
        }

        /* Footer */
        footer {
            margin-top: 30px;
            padding: 10px;
            background: #007bff;
            color: white;
            font-size: 14px;
        }
    </style>
</head>

<body>

    <div class="container">
        <h2> Manage Routes</h2>

        <!-- Add New Route Form -->
        <div class="form-container">
            <h3>Add New Route</h3>
            <form method="post">
                <div class="form-group">
                    <label>Source:</label>
                    <input type="text" name="source" required placeholder="Enter source location">
                </div>

                <div class="form-group">
                    <label>Destination:</label>
                    <input type="text" name="destination" required placeholder="Enter destination location">
                </div>

                <div class="form-group">
                    <label>Distance (km):</label>
                    <input type="number" name="distance" required placeholder="Enter distance in km">
                </div>

                <input type="submit" value="Add Route" class="btn">
            </form>
        </div>

        <!-- Route List -->
        <h3> Existing Routes</h3>
        <table>
            <tr>
                <th>Route ID</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Distance (km)</th>
            </tr>
            <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("route_id") %></td>
                    <td><%= rs.getString("source") %></td>
                    <td><%= rs.getString("destination") %></td>
                    <td><%= rs.getInt("distance") %> km</td>
                </tr>
            <% } %>
        </table>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>

<%
    rs.close();
    pst.close();
    con.close();
%>
