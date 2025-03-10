<%@ include file="DBConnection.jsp" %>
<%@ page session="true" %>

<%
    Integer user_id = (Integer) session.getAttribute("user_id");
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String scheduleIdParam = request.getParameter("schedule_id");
    String seatCountParam = request.getParameter("seat_count");
    String amountParam = request.getParameter("amount");

    if (scheduleIdParam == null || seatCountParam == null || amountParam == null) {
        out.println("<p style='color:red;'>Error: Missing booking details.</p>");
        return;
    }

    int schedule_id = Integer.parseInt(scheduleIdParam);
    int seat_count = Integer.parseInt(seatCountParam);
    double totalAmount = Double.parseDouble(amountParam) * seat_count;
%>

<html>
<head>
    <title>Secure Payment</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .container { width: 50%; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px #ccc; }
        .btn { background: #007bff; color: white; padding: 10px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; }
        .btn:hover { background: #0056b3; }
    </style>
</head>
<body>
    <div class="container">
        <h2> Payment</h2>
        <p><strong>Total Amount:</strong> <%= totalAmount %></p>

        <form method="post" action="confirm-payment.jsp">
            <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
            <input type="hidden" name="seat_count" value="<%= seat_count %>">
            <input type="hidden" name="amount" value="<%= totalAmount %>">

            <label>Select Payment Method:</label>
            <select name="payment_method" required>
                <option value="Credit Card"> Credit/Debit Card</option>
                <option value="UPI"> UPI</option>
                <option value="Net Banking"> Net Banking</option>
            </select>
            <br><br>
            <input type="submit" value="Confirm Payment" class="btn">
        </form>
    </div>
</body>
</html>
