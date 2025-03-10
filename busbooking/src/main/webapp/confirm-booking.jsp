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
    String[] selectedSeats = request.getParameterValues("seat_numbers");

    if (scheduleIdParam == null || selectedSeats == null || selectedSeats.length == 0) {
        out.println("<p style='color:red;'>Error: No seats selected. Please go back and try again.</p>");
        return;
    }

    int schedule_id = Integer.parseInt(scheduleIdParam);
    Connection con = getConnection();

    // Get fare per seat
    PreparedStatement pstFare = con.prepareStatement(
        "SELECT fare FROM schedules WHERE schedule_id = ?"
    );
    pstFare.setInt(1, schedule_id);
    ResultSet rsFare = pstFare.executeQuery();

    double farePerSeat = 0;
    if (rsFare.next()) {
        farePerSeat = rsFare.getDouble("fare");
    }

    boolean bookingFailed = false;
    double totalAmount = 0;
    int bookedSeatsCount = 0;

    for (String seat : selectedSeats) {
        int seat_number = Integer.parseInt(seat);

        // Check if the seat is already booked
        PreparedStatement checkSeat = con.prepareStatement(
            "SELECT 1 FROM bookings WHERE schedule_id = ? AND seat_number = ?"
        );
        checkSeat.setInt(1, schedule_id);
        checkSeat.setInt(2, seat_number);
        ResultSet rsCheck = checkSeat.executeQuery();

        if (rsCheck.next()) {
            out.println("<p style='color:red;'>Seat " + seat_number + " is already booked. Please choose different seats.</p>");
            bookingFailed = true;
        } else {
            // Book the seat
            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO bookings (user_id, schedule_id, seat_number, status) VALUES (?, ?, ?, 'BOOKED')"
            );
            pst.setInt(1, user_id);
            pst.setInt(2, schedule_id);
            pst.setInt(3, seat_number);
            pst.executeUpdate();

            totalAmount += farePerSeat;
            bookedSeatsCount++;
        }
    }

    if (!bookingFailed) {
        response.sendRedirect("confirm-payment.jsp?schedule_id=" + schedule_id + "&total_amount=" + totalAmount + "&seat_count=" + bookedSeatsCount);
    }

    con.close();
%>

<html>
<head>
    <title>Booking Confirmation</title>

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
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        /* Success Icon */
        .success-icon {
            font-size: 50px;
            color: #28a745;
            margin-bottom: 20px;
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

        /* Button */
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 20px;
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
        <div class="success-icon"></div>
        <h2> Booking Successful!</h2>
        <p>Your seats have been booked successfully. Please proceed with the payment to confirm your booking.</p>

        <table>
            <tr>
                <th>Seats Selected</th>
                <th>Total Amount</th>
                <th>Proceed to Payment</th>
            </tr>
            <tr>
                <td><%= bookedSeatsCount %> Seats</td>
                <td><%= totalAmount %></td>
                <td><a href="confirm-payment.jsp?schedule_id=<%= schedule_id %>&total_amount=<%= totalAmount %>&seat_count=<%= bookedSeatsCount %>" class="btn">Pay Now</a></td>
            </tr>
        </table>

        <a href="user-dashboard.jsp" class="btn">Go to Dashboard</a>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>
