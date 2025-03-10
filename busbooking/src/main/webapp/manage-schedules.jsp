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

    // Handle Schedule Addition
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int busId = Integer.parseInt(request.getParameter("bus_id"));
        int routeId = Integer.parseInt(request.getParameter("route_id"));
        String departureTime = request.getParameter("departure_time");
        String arrivalTime = request.getParameter("arrival_time");
        double fare = Double.parseDouble(request.getParameter("fare"));

        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO schedules (bus_id, route_id, departure_time, arrival_time, fare) VALUES (?, ?, ?, ?, ?)"
        );
        pst.setInt(1, busId);
        pst.setInt(2, routeId);
        pst.setString(3, departureTime);
        pst.setString(4, arrivalTime);
        pst.setDouble(5, fare);
        pst.executeUpdate();
    }

    // Retrieve all schedules
    PreparedStatement pst = con.prepareStatement(
        "SELECT s.schedule_id, b.bus_name, r.source, r.destination, s.departure_time, s.arrival_time, s.fare " +
        "FROM schedules s " +
        "JOIN buses b ON s.bus_id = b.bus_id " +
        "JOIN routes r ON s.route_id = r.route_id"
    );
    ResultSet rs = pst.executeQuery();

    // Fetch Buses
    PreparedStatement busStmt = con.prepareStatement("SELECT * FROM buses");
    ResultSet busRs = busStmt.executeQuery();

    // Fetch Routes
    PreparedStatement routeStmt = con.prepareStatement("SELECT * FROM routes");
    ResultSet routeRs = routeStmt.executeQuery();
%>

<html>
<head>
    <title>Manage Bus Schedules - Admin Panel</title>

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
            max-width: 900px;
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
        <h2> Manage Bus Schedules</h2>

        <!-- Add New Schedule Form -->
        <div class="form-container">
            <h3>➕ Add New Schedule</h3>
            <form method="post">
                <div class="form-group">
                    <label>Bus:</label>
                    <select name="bus_id" required>
                        <option value="">Select Bus</option>
                        <% while (busRs.next()) { %>
                            <option value="<%= busRs.getInt("bus_id") %>"><%= busRs.getString("bus_name") %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Route:</label>
                    <select name="route_id" required>
                        <option value="">Select Route</option>
                        <% while (routeRs.next()) { %>
                            <option value="<%= routeRs.getInt("route_id") %>">
                                <%= routeRs.getString("source") %> ➝ <%= routeRs.getString("destination") %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Departure Time:</label>
                    <input type="datetime-local" name="departure_time" required>
                </div>

                <div class="form-group">
                    <label>Arrival Time:</label>
                    <input type="datetime-local" name="arrival_time" required>
                </div>

                <div class="form-group">
                    <label>Fare (₹):</label>
                    <input type="number" name="fare" required placeholder="Enter fare amount">
                </div>

                <input type="submit" value="Add Schedule" class="btn">
            </form>
        </div>

        <!-- Schedule List -->
        <h3> Existing Schedules</h3>
        <table>
            <tr>
                <th>Schedule ID</th>
                <th>Bus Name</th>
                <th>Route</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Fare (₹)</th>
            </tr>
            <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("schedule_id") %></td>
                    <td><%= rs.getString("bus_name") %></td>
                    <td><%= rs.getString("source") %> ➝ <%= rs.getString("destination") %></td>
                    <td><%= rs.getString("departure_time") %></td>
                    <td><%= rs.getString("arrival_time") %></td>
                    <td>₹<%= rs.getDouble("fare") %></td>
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
