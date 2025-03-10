<%@ include file="DBConnection.jsp" %>
<%@ page session="true" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>

<%
    // Ensure user is logged in
    Integer user_id = (Integer) session.getAttribute("user_id");
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = getConnection();

    // Retrieve user's bookings
    PreparedStatement pst = con.prepareStatement(
        "SELECT b.booking_id, bus.bus_name, r.source, r.destination, s.departure_time, s.arrival_time, " +
        "b.seat_number, p.amount, p.payment_status " +
        "FROM bookings b " +
        "JOIN schedules s ON b.schedule_id = s.schedule_id " +
        "JOIN buses bus ON s.bus_id = bus.bus_id " +
        "JOIN routes r ON s.route_id = r.route_id " +
        "JOIN payments p ON b.booking_id = p.booking_id " +
        "WHERE b.user_id = ? ORDER BY b.booking_id DESC"
    );
    pst.setInt(1, user_id);
    ResultSet rs = pst.executeQuery();
%>

<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }
        h2 {
            color: #007bff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
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
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            background: #0056b3;
        }
        .no-bookings {
            color: red;
            font-size: 16px;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2> My Bookings</h2>

        <table>
            <tr>
                <th>Booking ID</th>
                <th>Bus Name</th>
                <th>Route</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Seat Number</th>
                <th>Amount Paid </th>
                <th>Payment Status</th>
            </tr>

            <%
                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
            %>
                <tr>
                    <td><%= rs.getInt("booking_id") %></td>
                    <td><%= rs.getString("bus_name") %></td>
                    <td><%= rs.getString("source") %> ➝ <%= rs.getString("destination") %></td>
                    <td><%= rs.getString("departure_time") %></td>
                    <td><%= rs.getString("arrival_time") %></td>
                    <td><%= rs.getInt("seat_number") %></td>
                    <td><%= rs.getDouble("amount") %></td>
                    <td><%= rs.getString("payment_status") %></td>
                </tr>
            <% } %>
        </table>

        <%
            if (!hasData) {
                out.println("<p class='no-bookings'>❌ No bookings found.</p>");
            }
            rs.close();
            pst.close();
            con.close();
        %>

        <a href="user-dashboard.jsp" class="btn">Go to Dashboard</a>
    </div>

</body>
</html>
