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
import java.lang.*;


//prints out all values in tables
public class InnReservations_tests {
    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";

    public void print_all_rooms() throws SQLException {
        // Step 1: Establish connection to RDBMS
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            // Step 2: Construct SQL statement
            String sql = "SELECT * FROM lab7_rooms ORDER BY RoomName";

            // Step 3: (omitted in this example) Start transaction

            // Step 4: Send SQL statement to DBMS
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                // Step 5: Receive results
                while (rs.next()) {
                    String roomcode = rs.getString("RoomCode");
                    String roomname = rs.getString("RoomName");
                    int bed = rs.getInt("Beds");
                    String bedtype = rs.getString("bedType");
                    int maxocc = rs.getInt("maxOcc");
                    float baseprice = rs.getFloat("basePrice");
                    String decor = rs.getString("decor");
                    System.out.format("%s %s %d %s %d ($%.2f) %s\n", roomcode, roomname, bed, bedtype, maxocc, baseprice, decor);
                }
            }
            // Step 6: (omitted in this example) Commit or rollback transaction
        }
        // Step 7: Close connection (handled by try-with-resources syntax)
    }

    public void print_all_room_status() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            // Step 2: Construct SQL statement
                String sql =
                "with MostRecentReservation as (" +
                "select Room, " +
                "datediff(d,checkin, current_date) as daysSinceCheckIn, " +
                "datediff(d,checkout, current_date) as daysSinceCheckOut, Checkin, Checkout " +
                "from lab7_reservations " +
                "where datediff(d,checkin, current_date) >= 0 " +
                "group by Room, Checkin, Checkout), " +
                "NextReservation as (select Room, " +
                "datediff(d,checkin, current_date) as daysSinceCheckIn, " +
                "datediff(d,checkout, current_date) as daysSinceCheckOut, Checkin, Checkout " +
                "from lab7_reservations " +
                "where datediff(d,checkin, current_date) < 0 and CheckIn <> Current_Date and checkIn not in (select checkOut from lab7_reservations)" +
                "group by Room, Checkin, Checkout), " +
                "prev as ( " +
                "select Room, Checkin, Checkout, daysSinceCheckIn, daysSinceCheckout from MostRecentReservation a1 " +
                "where daysSinceCheckIn = (select MIN(daysSinceCheckIn) from MostRecentReservation a2 " +
                "where a1.Room = a2.room)), " +
                "next as ( " +
                "select Room, Checkin, Checkout, daysSinceCheckIn, daysSinceCheckout from NextReservation a1 " +
                "where daysSinceCheckOut = (select MAX(daysSinceCheckOut) from NextReservation a2 " +
                "where a1.Room = a2.room)), " +
                "occupiedRooms as (select r1.* from lab7_rooms " +
                "join lab7_reservations r2 on r2.Room = lab7_rooms.RoomCode " +
                "join lab7_reservations r1 on r1.Room = lab7_rooms.RoomCode " +
                "where r1.CheckIn <= Current_Date and r1.Checkout > Current_Date " +
                "and r1.CheckOut <> r2.Checkin), " +
                "occupiedInFuture as (select * from lab7_rooms " +
                "join lab7_reservations on lab7_reservations.Room = lab7_rooms.RoomCode " +
                "where CheckIn >= Current_Date) " +
                "select RoomCode, Roomname, Beds, bedType, MaxOcc, BasePrice, decor, " +
                "case when prev.Room not in (select Room from occupiedRooms) " +
                "then NULL " +
                "else prev.CheckOut " +
                "end as NextAvailable, " +
                "case when prev.Room not in (select Room from occupiedInFuture) " +
                "then NULL " +
                "else next.Checkin " +
                "end as NextReservation " +
                "from lab7_rooms " +
                "left join prev on prev.Room = lab7_rooms.RoomCode " +
                "left join next on next.Room = lab7_rooms.RoomCode";

            // Step 3: (omitted in this example) Start transaction

            // Step 4: Send SQL statement to DBMS
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                // Step 5: Receive results
                System.out.println("roomcode, roomname, bed, bedtype, maxocc, baseprice, decor, next day availale, next reservation");
                while (rs.next()) {
                    String roomcode = rs.getString("RoomCode");
                    String roomname = rs.getString("RoomName");
                    int bed = rs.getInt("Beds");
                    String bedtype = rs.getString("bedType");
                    int maxocc = rs.getInt("maxOcc");
                    float baseprice = rs.getFloat("basePrice");
                    String decor = rs.getString("decor");
                    String nextAvail = rs.getString("NextAvailable");
                    String nextReservation = rs.getString("NextReservation");
                    if (nextAvail == null) {
                        nextAvail = "Today";
                    }
                    if (nextReservation == null) {
                        nextReservation = "None";
                    }
                    System.out.format("%s %25s %d %5s %d ($%.2f) %14s %s %s\n", roomcode, roomname, bed, bedtype,
                            maxocc, baseprice, decor, nextAvail, nextReservation);
                }
            }
            // Step 6: (omitted in this example) Commit or rollback transaction
        }
        // Step 7: Close connection (handled by try-with-resources syntax)
    }

    public void print_all_reservations() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            String sql = "SELECT * FROM lab7_reservations";

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    int code = rs.getInt("CODE");
                    String room = rs.getString("Room");
                    java.sql.Date checkin = rs.getDate("CheckIn");
                    java.sql.Date checkout = rs.getDate("Checkout");
                    int rate = rs.getInt("Rate");
                    String lastname = rs.getString("LastName");
                    String firstname = rs.getString("FirstName");
                    int adults = rs.getInt("Adults");
                    int kids = rs.getInt("Kids");
                    System.out.format("%d %s %s %s %d %s %s %d %d\n", code, room, checkin, checkout, rate, lastname, firstname, adults, kids);
                }
            }
        }
    }

    public void print_revenue_summary() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            String sql = "with rtotals as (\n" +
                    "select room, month(CheckOut) as month, abs(datediff(d,CheckOut,Checkin)) * Rate as price from lab7_reservations\n " +
                    "join lab7_rooms on lab7_rooms.roomcode = lab7_reservations.room\n " +
                    "where year(Checkout) <= year(current_date) and year(Checkout) >= (year(current_date)-1)),\n " +
                    "mtotals as (\n " +
                    "select room, month, sum(price) as mtotal from rtotals\n " +
                    "group by month, room),\n " +
                    "roomtotal as(\n " +
                    "select room, sum(mtotal) as total from mtotals\n " +
                    "group by room)\n " +
                    "select roomname,\n " +
                    "(select mtotal from mtotals where month = 1 and roomcode = mtotals.room) as JAN,\n " +
                    "(select mtotal from mtotals where month = 2 and roomcode = mtotals.room) as FEB,\n " +
                    "(select mtotal from mtotals where month = 3 and roomcode = mtotals.room) as MAR,\n " +
                    "(select mtotal from mtotals where month = 4 and roomcode = mtotals.room) as APR,\n " +
                    "(select mtotal from mtotals where month = 5 and roomcode = mtotals.room) as MAY,\n " +
                    "(select mtotal from mtotals where month = 6 and roomcode = mtotals.room) as JUN,\n " +
                    "(select mtotal from mtotals where month = 7 and roomcode = mtotals.room) as JUL,\n " +
                    "(select mtotal from mtotals where month = 8 and roomcode = mtotals.room) as AUG,\n " +
                    "(select mtotal from mtotals where month = 9 and roomcode = mtotals.room) as SEP,\n " +
                    "(select mtotal from mtotals where month = 10 and roomcode = mtotals.room) as OCT,\n " +
                    "(select mtotal from mtotals where month = 11 and roomcode = mtotals.room) as NOV,\n " +
                    "(select mtotal from mtotals where month = 12 and roomcode = mtotals.room) as DEM,\n " +
                    "(select total from roomtotal where roomtotal.room = roomcode) as TOTAL\n " +
                    "from lab7_rooms";

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                System.out.println("Room Name, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, Total");
                while (rs.next()) {
                    String room = rs.getString("roomname");
                    float jan_rev = rs.getFloat("JAN");
                    float feb_rev = rs.getFloat("FEB");
                    float mar_rev = rs.getFloat("MAR");
                    float apr_rev = rs.getFloat("APR");
                    float may_rev = rs.getFloat("MAY");
                    float jun_rev = rs.getFloat("JUN");
                    float jul_rev = rs.getFloat("JUL");
                    float aug_rev = rs.getFloat("AUG");
                    float sep_rev = rs.getFloat("SEP");
                    float oct_rev = rs.getFloat("OCT");
                    float nov_rev = rs.getFloat("NOV");
                    float dec_rev = rs.getFloat("DEM");
                    float total = rs.getFloat("TOTAL");
                    System.out.format("%25s, ($%.2f), ($%.2f), ($%.2f), ($%.2f), ($%.2f), ($%.2f), ($%.2f), ($%.2f), ($%.2f), " +
                            "($%.2f), ($%.2f), ($%.2f), ($%.2f)\n", room, jan_rev, feb_rev, mar_rev, apr_rev, may_rev,
                            jun_rev, jul_rev, aug_rev, sep_rev, oct_rev, nov_rev, dec_rev, total);
                }
            }
        }
    }
}