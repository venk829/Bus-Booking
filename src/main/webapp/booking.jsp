<%@ include file="DBConnection.jsp" %>
<%@ page session="true" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>


<%
    Integer user_id = (Integer) session.getAttribute("user_id");
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String scheduleIdParam = request.getParameter("schedule_id");
    if (scheduleIdParam == null) {
        out.println("<p style='color:red;'>Error: No schedule selected.</p>");
        return;
    }

    int schedule_id = Integer.parseInt(scheduleIdParam);
    Connection con = getConnection();

    // Fetch schedule details
    PreparedStatement pst = con.prepareStatement(
        "SELECT b.bus_name, r.source, r.destination, s.departure_time, s.arrival_time, s.fare, b.total_seats " +
        "FROM schedules s " +
        "JOIN buses b ON s.bus_id = b.bus_id " +
        "JOIN routes r ON s.route_id = r.route_id " +
        "WHERE s.schedule_id = ?"
    );
    pst.setInt(1, schedule_id);
    ResultSet rs = pst.executeQuery();

    if (!rs.next()) {
        out.println("<p style='color:red;'>Error: Schedule not found.</p>");
        return;
    }

    String busName = rs.getString("bus_name");
    String source = rs.getString("source");
    String destination = rs.getString("destination");
    String departure = rs.getString("departure_time");
    String arrival = rs.getString("arrival_time");
    double fare = rs.getDouble("fare");
    int totalSeats = rs.getInt("total_seats");
%>

<html>
<head>
    <title>Book Your Seat</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .container { width: 50%; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px #ccc; }
        .btn { background: #007bff; color: white; padding: 10px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; }
        .btn:hover { background: #0056b3; }
    </style>
</head>
<body>
    <div class="container">
        <h2> Confirm Your Booking</h2>
        <p><strong>Bus:</strong> <%= busName %></p>
        <p><strong>Route:</strong> <%= source %>-----<%= destination %></p>
        <p><strong>Departure:</strong> <%= departure %></p>
        <p><strong>Arrival:</strong> <%= arrival %></p>
        <p><strong>Fare per Seat:</strong> <%= fare %></p>

        <form method="post" action="payment.jsp">
            <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
            <label>Select Number of Seats:</label>
            <input type="number" name="seat_count" min="1" max="<%= totalSeats %>" required>
            <input type="hidden" name="amount" value="<%= fare %>">
            <br><br>
            <input type="submit" value="Proceed to Payment" class="btn">
        </form>
    </div>
</body>
</html>

<%
    rs.close();
    pst.close();
    con.close();
%>
