<%@ include file="DBConnection.jsp" %>
<%@ page session="true" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement" %>

<%
    // Ensure user is logged in
    Integer user_id = (Integer) session.getAttribute("user_id");
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve payment details from request
    String scheduleIdParam = request.getParameter("schedule_id");
    String seatCountParam = request.getParameter("seat_count");
    String amountParam = request.getParameter("amount");
    String paymentMethod = request.getParameter("payment_method");

    // Validate inputs
    if (scheduleIdParam == null || seatCountParam == null || amountParam == null || paymentMethod == null ||
        scheduleIdParam.isEmpty() || seatCountParam.isEmpty() || amountParam.isEmpty() || paymentMethod.isEmpty()) {
        out.println("<p style='color:red;'>Error: Missing payment details. Please go back and try again.</p>");
        return;
    }

    // Convert input values
    int schedule_id = Integer.parseInt(scheduleIdParam);
    int seat_count = Integer.parseInt(seatCountParam);
    double amount = Double.parseDouble(amountParam);

    // Establish database connection
    Connection con = getConnection();

    // Insert payment details into database
    PreparedStatement pst = con.prepareStatement(
        "INSERT INTO payments (user_id, schedule_id, seat_count, amount, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, 'Completed')"
    );
    pst.setInt(1, user_id);
    pst.setInt(2, schedule_id);
    pst.setInt(3, seat_count);
    pst.setDouble(4, amount);
    pst.setString(5, paymentMethod);
    pst.executeUpdate();

    // Close database connection
    pst.close();
    con.close();
%>

<html>
<head>
    <title>Payment Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
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
        p {
            font-size: 16px;
            color: #333;
        }
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 20px;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2> Payment Successful!</h2>
        <p>Thank you! Your payment for <strong><%= seat_count %> seat(s)</strong> has been successfully processed.</p>
        <p><strong>Total Amount Paid:</strong> <%= amount %></p>
        <p><strong>Payment Method:</strong> <%= paymentMethod %></p>
        <a href="user-dashboard.jsp" class="btn">Go to Dashboard</a>
        <a href="view-bookings.jsp" class="btn">View My Bookings</a>
    </div>

</body>
</html>
