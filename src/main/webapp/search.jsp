<%@ include file="DBConnection.jsp" %>

<html>
<head>
    <title>Search for Buses</title>

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
            max-width: 700px;
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

        select, input {
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
            margin-top: 10px;
        }

        .btn:hover {
            background: #0056b3;
        }

        /* Table Styles */
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

        /* No Buses Message */
        .no-buses {
            color: red;
            font-size: 16px;
            font-weight: bold;
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

    <div class="container">
        <h2> Search for Buses</h2>

        <form method="get">
            <div class="form-group">
                <label>From:</label>
                <select name="source">
                    <option value="Vijayawada">Vijayawada</option> <!-- Fixed source -->
                </select>
            </div>

            <div class="form-group">
                <label>To:</label>
                <select name="destination" required>
                    <option value="Chennai">Chennai</option>
                    <option value="Mumbai">Mumbai</option>
                    <option value="Bangalore">Bangalore</option>
                    <option value="Hyderabad">Hyderabad</option>
                    <option value="Kolkata">Kolkata</option>
                </select>
            </div>

            <input type="submit" value="Search Buses" class="btn">
        </form>

        <%
            String source = "Vijayawada"; // Fixed source
            String destination = request.getParameter("destination");

            if (destination != null) {
                Connection con = getConnection();
                PreparedStatement pst = con.prepareStatement(
                    "SELECT s.schedule_id, b.bus_name, r.source, r.destination, " +
                    "s.departure_time, s.arrival_time, s.fare " +
                    "FROM schedules s " +
                    "JOIN buses b ON s.bus_id = b.bus_id " +
                    "JOIN routes r ON s.route_id = r.route_id " +
                    "WHERE r.source = ? AND r.destination = ?"
                );
                pst.setString(1, source);
                pst.setString(2, destination);
                ResultSet rs = pst.executeQuery();

                boolean hasData = false;
        %>

        <h3> Available Buses</h3>
        <table>
            <tr>
                <th>Bus Name</th>
                <th>From</th>
                <th>To</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Fare </th>
                <th>Book</th>
            </tr>

            <%
                while (rs.next()) {
                    hasData = true;
            %>
                <tr>
                    <td><%= rs.getString("bus_name") %></td>
                    <td><%= rs.getString("source") %></td>
                    <td><%= rs.getString("destination") %></td>
                    <td><%= rs.getString("departure_time") %></td>
                    <td><%= rs.getString("arrival_time") %></td>
                    <td><%= rs.getDouble("fare") %></td>
                    <td><a href='booking.jsp?schedule_id=<%= rs.getInt("schedule_id") %>' class="btn">Book</a></td>
                </tr>
            <% } %>
        </table>

        <%
                if (!hasData) {
                    out.println("<p class='no-buses'>❌ No buses available for this route.</p>");
                }

                con.close();
            }
        %>
    </div>

    <footer>© 2024 Bus Booking System</footer>

</body>
</html>
