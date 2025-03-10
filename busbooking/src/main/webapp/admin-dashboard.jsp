
<%@ page session="true" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ include file="DBConnection.jsp" %>

<%
    Integer adminId = (Integer) session.getAttribute("user_id");
    String adminName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (adminId == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Admin Dashboard - Bus Booking System</title>

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
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        /* Header */
        header {
            background: #007bff;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        /* Dashboard Navigation */
        .dashboard-menu {
            display: flex;
            justify-content: space-around;
            background: #f9f9f9;
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .dashboard-menu a {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            padding: 10px 15px;
            border: 1px solid #007bff;
            border-radius: 5px;
            transition: 0.3s;
        }

        .dashboard-menu a:hover {
            background: #007bff;
            color: white;
        }

        /* Dashboard Sections */
        .dashboard-section {
            margin-top: 30px;
            text-align: left;
        }

        .dashboard-section h3 {
            color: #007bff;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
            margin-bottom: 15px;
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

        /* Buttons */
        .btn {
            background: #007bff;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background: #0056b3;
        }

        /* Logout Button */
        .logout {
            margin-top: 20px;
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

    <header> Admin Dashboard - Bus Booking System</header>

    <div class="container">
        <h2>Welcome, <%= adminName %> (Admin) </h2>

        <div class="dashboard-menu">
            <a href="manage-buses.jsp"> Manage Buses</a>
            <a href="manage-routes.jsp"> Manage Routes</a>
            <a href="manage-schedules.jsp"> Manage Schedules</a>
            <a href="view-bookings.jsp"> View Bookings</a>
        </div>

        <div class="dashboard-section">
            <h3> Recent Bookings</h3>
            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>User</th>
                    <th>Bus</th>
                    <th>Route</th>
                    <th>Seats</th>
                    <th>Status</th>
                </tr>
                <%
                    Connection con = getConnection();
                    PreparedStatement pst = con.prepareStatement(
                        "SELECT b.booking_id, u.name AS user_name, bus.bus_name, r.source, r.destination, " +
                        "b.seat_number, b.status FROM bookings b " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "JOIN schedules s ON b.schedule_id = s.schedule_id " +
                        "JOIN buses bus ON s.bus_id = bus.bus_id " +
                        "JOIN routes r ON s.route_id = r.route_id " +
                        "ORDER BY b.booking_id DESC LIMIT 5"
                    );
                    ResultSet rs = pst.executeQuery();
                    while (rs.next()) { 
                %>
                    <tr>
                        <td><%= rs.getInt("booking_id") %></td>
                        <td><%= rs.getString("user_name") %></td>
                        <td><%= rs.getString("bus_name") %></td>
                        <td><%= rs.getString("source") %> ➝ <%= rs.getString("destination") %></td>
                        <td><%= rs.getInt("seat_number") %></td>
                        <td><%= rs.getString("status") %></td>
                    </tr>
                <% } %>
            </table>
        </div>

        <div class="logout">
            <a href="logout.jsp" class="btn"> Logout</a>
        </div>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>
