<%@ page import="java.sql.*" %>

<%! 
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bookingbuses", "admin", "admin");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
%>
