import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.util.Map;
import java.util.Scanner;
import java.util.LinkedHashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;

// creates lab7_rooms and lab7_reservations table
// and inserts values into them
public class InnReservations_setup
{
    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";
    
    public void create_rooms_table() throws SQLException
    {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
							   JDBC_USER,
							   JDBC_PASSWORD)) {
	        try (Statement stmt = conn.createStatement()) {
                // stmt.execute("DROP TABLE IF EXISTS lab7_rooms");
                stmt.execute("CREATE TABLE if not exists lab7_rooms (RoomCode char(5) PRIMARY KEY, RoomName varchar(30), " +
                    "Beds INTEGER, bedType varchar(8), maxOcc INTEGER, basePrice FLOAT, decor varchar(20), " +
                    "UNIQUE(RoomName))");
	    }
        }
    }

    public void fill_rooms_table() throws SQLException
    {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
							   JDBC_USER,
							   JDBC_PASSWORD)) {
	        try (Statement stmt = conn.createStatement()) {
                // stmt.execute("DROP TABLE IF EXISTS lab7_rooms");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('AOB', 'Abscond or bolster', 2, 'Queen', 4, 175, 'traditional')");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('CAS', 'Convoke and sanguine', 2, 'King', 4, 175, 'traditional')");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('FNA', 'Frugal not apropos', 2, 'King', 4, 250, 'traditional')");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('HBB', 'Harbinger but bequest', 1, 'Queen', 2, 100, 'modern')");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('IBD', 'Immutable before decorum', 2, 'Queen', 4, 150, 'rustic')");
                stmt.execute("INSERT INTO lab7_rooms (RoomCode, RoomName, Beds, bedType, maxOcc, basePrice, decor)" +
                    " VALUES ('IBS', 'Interim but salutary', 1, 'King', 2, 150, 'traditional')");
	    }
        }
    }

    public void create_reservations_table() throws SQLException
    {
        try(Connection conn = DriverManager.getConnection(JDBC_URL,
                              JDBC_USER, 
                              JDBC_PASSWORD))
        {
            try (Statement stmt = conn.createStatement())
            {
                // stmt.execute("DROP TABLE IF EXISTS lab7_reservations");
                stmt.execute("CREATE TABLE if not exists lab7_reservations (CODE INTEGER PRIMARY KEY, Room char(5), CheckIn DATE, " +
                    "Checkout DATE, Rate FLOAT, LastName varchar(15), FirstName varchar(15), Adults INTEGER, Kids INTEGER, " +
                    "FOREIGN KEY (Room) REFERENCES lab7_rooms(RoomCode))");
                
            }
        }
    }

    public void fill_reservations_table() throws SQLException
    {
        try(Connection conn = DriverManager.getConnection(JDBC_URL,
                              JDBC_USER, 
                              JDBC_PASSWORD))
        {
            try (Statement stmt = conn.createStatement())
            {
                // stmt.execute("DROP TABLE IF EXISTS lab7_reservations");
                
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                    " VALUES (10105, 'HBB', '2020-12-02', '2020-12-05', 100, 'SELBIG', 'CONRAD', 1, 0)");
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                        " VALUES (10112, 'HBB', '2020-12-05', '2020-12-08', 100, 'yuhj', 'yuhj.com', 1, 0)");
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                    " VALUES (10183, 'IBD', '2010-12-19', '2020-12-21', 150, 'GABLER', 'DOLLIE', 2, 0)");
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                    " VALUES (10489, 'AOB', '2020-02-02', '2020-02-05', 218.75, 'CARISTO', 'MARKITA', 2, 1)");
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                    " VALUES (10500, 'HBB', '2020-08-11', '2020-08-12', 90, 'YESSIOS', 'ANNIS', 1, 0)");
                stmt.execute("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate, LastName, FirstName, Adults, Kids)" +
                    " VALUES (10574, 'FNA', '2021-11-26', '2021-12-03', 287.5, 'SWEAZY', 'ROY', 2, 1)");
            }
        }
    }

    public void delete_tables() throws SQLException
    {
        try(Connection conn = DriverManager.getConnection(JDBC_URL,
                              JDBC_USER, 
                              JDBC_PASSWORD))
        {
            try (Statement stmt = conn.createStatement())
            {
                stmt.execute("DROP TABLE IF EXISTS lab7_reservations");
                stmt.execute("DROP TABLE IF EXISTS lab7_rooms");
            }
        }
    }
}