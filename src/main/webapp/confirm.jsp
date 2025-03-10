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

    // Retrieve payment details (Declare only once)
    String scheduleIdParam = request.getParameter("schedule_id");
    String amountParam = request.getParameter("amount");
    String paymentMethod = request.getParameter("payment_method");

    // Validate inputs
    if (scheduleIdParam == null || amountParam == null || paymentMethod == null ||
        scheduleIdParam.isEmpty() || amountParam.isEmpty() || paymentMethod.isEmpty()) {
        out.println("<p style='color:red;'>Error: Missing payment details. Please go back and try again.</p>");
        return;
    }

    // Convert input values
    int schedule_id = Integer.parseInt(scheduleIdParam);
    double amount = Double.parseDouble(amountParam);

    // Establish database connection
    Connection con = getConnection();

    // Insert payment details into database
    PreparedStatement pst = con.prepareStatement(
        "INSERT INTO payments (user_id, schedule_id, amount, payment_method, payment_status) VALUES (?, ?, ?, ?, 'Completed')"
    );
    pst.setInt(1, user_id);
    pst.setInt(2, schedule_id);
    pst.setDouble(3, amount);
    pst.setString(4, paymentMethod);
    int rows = pst.executeUpdate();

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
        <p>Your payment of <%= amount %> has been completed using <strong><%= paymentMethod %></strong>.</p>
        <a href="user-dashboard.jsp" class="btn">Go to Dashboard</a>
    </div>

</body>
</html>
