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

    // Handle Bus Addition
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String busName = request.getParameter("bus_name");
        int totalSeats = Integer.parseInt(request.getParameter("total_seats"));
        String busType = request.getParameter("bus_type");

        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO buses (bus_name, total_seats, bus_type) VALUES (?, ?, ?)"
        );
        pst.setString(1, busName);
        pst.setInt(2, totalSeats);
        pst.setString(3, busType);
        pst.executeUpdate();
    }

    // Retrieve all buses
    PreparedStatement pst = con.prepareStatement("SELECT * FROM buses");
    ResultSet rs = pst.executeQuery();
%>

<html>
<head>
    <title>Manage Buses - Admin Panel</title>

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
        <h2> Manage Buses</h2>

        <!-- Add New Bus Form -->
        <div class="form-container">
            <h3> Add New Bus</h3>
            <form method="post">
                <div class="form-group">
                    <label>Bus Name:</label>
                    <input type="text" name="bus_name" required placeholder="Enter bus name">
                </div>

                <div class="form-group">
                    <label>Total Seats:</label>
                    <input type="number" name="total_seats" required placeholder="Enter total seats">
                </div>

                <div class="form-group">
                    <label>Bus Type:</label>
                    <select name="bus_type" required>
                        <option value="AC">AC</option>
                        <option value="Non-AC">Non-AC</option>
                        <option value="Sleeper">Sleeper</option>
                        <option value="Seater">Seater</option>
                    </select>
                </div>

                <input type="submit" value="Add Bus" class="btn">
            </form>
        </div>

        <!-- Bus List -->
        <h3> Existing Buses</h3>
        <table>
            <tr>
                <th>Bus ID</th>
                <th>Bus Name</th>
                <th>Total Seats</th>
                <th>Bus Type</th>
            </tr>
            <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("bus_id") %></td>
                    <td><%= rs.getString("bus_name") %></td>
                    <td><%= rs.getInt("total_seats") %></td>
                    <td><%= rs.getString("bus_type") %></td>
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
