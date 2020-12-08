import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Driver;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;
import java.util.LinkedHashMap;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import java.util.Calendar;
import java.text.*;

// handles all reservation functional requirements
// i.e. FR2, FR3, FR4
public class Reservations
{
    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";

    public void change_reservation() throws SQLException
    {
        String newFirst = "";
        String newLast = "";
        String newBeginDate = "";
        String newEndDate = "";
        String room = "";
        int newNumChild = 0;
        int newNumAdult = 0;
        String ans; 
        DateFormat df = new SimpleDateFormat("YYYY-MM-dd");

        try(Connection conn = DriverManager.getConnection(JDBC_URL, 
                                JDBC_USER, 
                                JDBC_PASSWORD))
        {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter Reservation number: ");
            int code = Integer.parseInt(scanner.nextLine());

            // get initial values
            String sql = "SELECT CODE, Room, FirstName, LastName, CheckIn, Checkout, Adults, "+
                "Kids from lab7_reservations WHERE CODE=" + code;

            try (Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql))
            {
                while(rs.next())
                {
                    room = rs.getString("Room"); 
                    newFirst = rs.getString("FirstName");
                    newLast = rs.getString("LastName");
                    java.sql.Date ci = rs.getDate("CheckIn");
                    java.sql.Date co = rs.getDate("Checkout");

                    // convert date to string
                    newBeginDate = df.format(ci);
                    newEndDate = df.format(co);
                    newNumChild = rs.getInt("Kids");
                    newNumAdult = rs.getInt("Adults");

                    if (room.length() == 0 && newFirst.length() == 0 && newLast.length() == 0 && newBeginDate.length() ==0 &&
                            newEndDate.length() == 0 && newNumChild == 0 && newNumAdult == 0)
                    {
                        System.out.println("Reservation Number does not exist!");
                        return; 
                    }
                }
            }

            if (room.length() == 0 && newFirst.length() == 0 && newLast.length() == 0 && newBeginDate.length() ==0 &&
                            newEndDate.length() == 0 && newNumChild == 0 && newNumAdult == 0)
            {
                        System.out.println("Reservation Number does not exist!");
                        scanner.close();
                        return; 
            }

            // rewrite variables if ans is Yes
            System.out.println("Change First Name on Reservation? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New First Name: ");
                newFirst = scanner.nextLine(); 
            }
            System.out.println("Change Last Name on Reservation? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New Last Name: ");
                newLast = scanner.nextLine(); 
            }
            System.out.println("Change Begin Date? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New Begin Date: ");
                newBeginDate = scanner.nextLine(); 
            }
            System.out.println("Change End Date? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New End Date: ");
                newEndDate = scanner.nextLine(); 
            }
            System.out.println("Change Number of Children? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New Number of Children: ");
                newNumChild = Integer.parseInt(scanner.nextLine());
            }
            System.out.println("Change Number of Adults? (Y/N)");
            ans = scanner.nextLine();
            if (ans.equals("Y"))
            {
                System.out.println("New Number of Adults: ");
                newNumAdult = Integer.parseInt(scanner.nextLine());
            }
            scanner.close();
            
            if (check_if_valid(room, newNumAdult+newNumChild, newBeginDate, newEndDate) == false)
            {
                System.out.println("Error with changes made to reservation");
                return; 
            }

            // update table with new info
            PreparedStatement pstmt = conn.prepareStatement("UPDATE lab7_reservations SET FirstName=?, LastName=?" +
                ", CheckIn=?, Checkout=?, Kids=?, Adults=? WHERE CODE=?");
            pstmt.setString(1, newFirst);
            pstmt.setString(2, newLast);
            pstmt.setString(3, newBeginDate);
            pstmt.setString(4, newEndDate);
            pstmt.setInt(5, newNumChild);
            pstmt.setInt(6, newNumAdult);
            pstmt.setInt(7, code);
            pstmt.executeUpdate();
            conn.commit();
        }
    }

    public void delete_reservation() throws SQLException
    {
        try (Connection conn = DriverManager.getConnection(JDBC_URL, 
                                JDBC_USER,
                                JDBC_PASSWORD))
        {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter Reservation number: "); 
            int code = Integer.parseInt(scanner.nextLine()); 
            System.out.println("Are you sure you want to cancel? (Y/N)");
            String ans = scanner.nextLine(); 

            if (ans.equals("N"))
            {
                scanner.close();
                return; 
            }

            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM lab7_reservations WHERE CODE=?");
            pstmt.setInt(1, code);
            pstmt.executeUpdate();

            System.out.format("Reservation %d has been cancelled\n", code);

            scanner.close();
            conn.commit();
        }
    }

    public void create_Reservaiton() throws SQLException
    {
	// Step 1: Establish connection to RDBMS
	    try (Connection conn = DriverManager.getConnection(JDBC_URL,
							   JDBC_USER,
							   JDBC_PASSWORD)) {
            // Step 2: Construct SQL statement
            Scanner scanner = new Scanner(System.in);
            System.out.format("\n First Name: ");
            String firstName = scanner.nextLine();
            System.out.format("\n Last Name: ");
            String lastName = scanner.nextLine();
            System.out.format("\n Room Code: ");
            String roomCode = scanner.nextLine();
            System.out.format("\n Begin date of stay (YYYY-MM-DD): ");
            String checkin = scanner.nextLine();
            System.out.format("\n End date of stay (YYYY-MM-DD): ");
            String checkout = scanner.nextLine();
            System.out.format("\n Number of children: ");
            int numChildren = Integer.parseInt(scanner.nextLine());
            System.out.format("\n Number of adults: "); 
            int numAdults = Integer.parseInt(scanner.nextLine());

            if (check_if_valid(roomCode, numAdults+numChildren, checkin, checkout) == false)
            {
                System.out.format("Reservation cannot be completed\n");
                scanner.close();
                return; 
            } 

            int resCode = ThreadLocalRandom.current().nextInt(10000, 100000+1);
            double rate = ThreadLocalRandom.current().nextDouble(67.5, 250+1);
            float r = (float) rate; 

            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO lab7_reservations (CODE, Room, CheckIn, Checkout, Rate" +
                ", LastName, FirstName, Adults, Kids) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, resCode); //gives random code for reservation
            pstmt.setString(2, roomCode);
            pstmt.setDate(3, java.sql.Date.valueOf(checkin));
            pstmt.setDate(4, java.sql.Date.valueOf(checkout));
            pstmt.setFloat(5, r); //gives random nightly rate to room reservation
            pstmt.setString(6, lastName);
            pstmt.setString(7, firstName);
            pstmt.setInt(8, numAdults);
            pstmt.setInt(9, numChildren); 
            pstmt.executeUpdate();
            scanner.close();
            conn.commit();

            String sql = "SELECT RoomCode, RoomName, bedType, basePrice from lab7_rooms";
            try (Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql))
            {
                while(rs.next())
                {
                    String room = rs.getString("RoomCode");

                    
                    if (!(room.equals(roomCode)))
                    {
                        continue;
                    }
                    

                    String roomName = rs.getString("RoomName");
                    String bedtype = rs.getString("bedType");
                    float baseprice = rs.getFloat("basePrice");

                    
                    float total_cost = calc_cost(checkin, checkout, room, baseprice);
                    System.out.println();
                    System.out.println("You have entered the following: ");
                    System.out.format("First and Last Name: %s, %s\n", firstName, lastName);
                    System.out.format("Room Code: %s, Room Name: %s, Bed Type: %s\n", roomCode, roomName, bedtype);
                    System.out.format("Number of Adults: %d\n", numAdults);
                    System.out.format("Number of Children: %d\n", numChildren);
                    System.out.format("Total cost of stay: ($%.2f)\n", total_cost);
                    System.out.println();
                }
            }
        }
    }

    public float calc_cost(String checkin, String checkout, String room, float baseprice)
    {
        LocalDate Checkin = LocalDate.parse(checkin);
        LocalDate Checkout = LocalDate.parse(checkout);
        int numWeekend = 0; 
        int numWeekday = 0; 
        float total = 0; 

        for (LocalDate date = Checkin; date.isBefore(Checkout); date = date.plusDays(1))
        {
            if (date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY)
                {
                    numWeekend++; 
                }
            else
            {
                numWeekday++;
            }
        }

        total = (numWeekday*baseprice) + (numWeekend*(baseprice*1.1f));
        return total; 
    }

    // checks if entered reservation info has no conflicts
    public boolean check_if_valid(String room, int total_guest, String start, String end) throws SQLException
    {
        return check_person_count(room, total_guest) && check_date_range(room, start, end);
    }

    // checks if the number of guests staying in room exceeds maxOcc
    public boolean check_person_count(String room, int total_guest) throws SQLException
    {
        try(Connection conn = DriverManager.getConnection(JDBC_URL,
                              JDBC_USER, 
                              JDBC_PASSWORD))
        {
            String sql = "SELECT RoomCode, maxOcc FROM lab7_rooms"; 
            try (Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql))
            {
                Boolean found = false;
                while (rs.next())
                {
                    int max = rs.getInt("maxOcc");
                    String roomCode = rs.getString("RoomCode");
                    

                    if (roomCode.equals(room) && total_guest > max)
                    {
                        return false;
                    }
                    
                    if (roomCode.equals(room)){
                        found = true;
                    }

                }
                if (found == false)
                    return false;
            }
        }
        return true;
    }

    // checks if room is available for the entire start and end date given
    public boolean check_date_range(String room, String start, String end) throws SQLException
    {
        // converts String into java.sql.Date
        Date begins = Date.valueOf(start);
        Date ends = Date.valueOf(end); 

        try(Connection conn = DriverManager.getConnection(JDBC_URL, 
                                JDBC_USER, 
                                JDBC_PASSWORD))
        {
            String sql = "SELECT Room, CheckIn, Checkout FROM lab7_reservations";
            try (Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql))
            {
                while(rs.next())
                {
                    String roomCode = rs.getString("Room");
                    if (!(roomCode.equals(room)))
                    {
                        continue;
                    }
                    java.sql.Date checkin = rs.getDate("CheckIn");
                    java.sql.Date checkout = rs.getDate("Checkout");

                    //do calculation to determine if room is available
                    if ((begins.after(checkin) && begins.before(checkout) || (ends.after(checkin) && ends.before(checkout))) )
                    {
                        return false; 
                    }
                }
            } 
        }
        return true; 
    }


}