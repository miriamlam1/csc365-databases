import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.util.Map;
import java.util.Scanner;

import javax.lang.model.util.ElementScanner6;

import java.util.LinkedHashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;

import java.util.*;

public class InnReservations
{
    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";

    public static void main(String[] args) 
     {
        try 
        {
            /* uncomment the first 4 lines to init tables, can comment out after first run*/
            
            InnReservations_setup ir = new InnReservations_setup();
            //ir.delete_tables();

            // if table doesnt exist, create it
            ir.create_rooms_table();
            ir.create_reservations_table();
            
            InnReservations_tests t = new InnReservations_tests();
            t.print_all_rooms();
            t.print_all_reservations();

            Reservations res = new Reservations(); 
            Scanner scanner = new Scanner(System.in);

            //while(true){
               
            System.out.println("Select following options: ");
            System.out.println("1 - Rooms and Rates");
            System.out.println("2 - Create a Reservation");
            System.out.println("3 - Change a Reservation");
            System.out.println("4 - Cancel a Reservation");
            System.out.println("5 - See Revenue Summary");
            System.out.println("6 - Delete tables");
            System.out.println("7 - fill with example data");
            System.out.println("8 - Exit");
           
            int option = 6; 
            if(scanner.hasNextInt()){
                option = scanner.nextInt(); 
            }
            else {
                System.out.println("invalid input\nplease type 1-6");
                scanner.next();
            }
                        if (option == 1)
                        {
                            t.print_all_room_status();
                        }
                    else if (option == 2)
                    {
                        res.create_Reservaiton();
                        // for error checking
                        t.print_all_rooms();
                        t.print_all_reservations();
                    }
                    else if (option == 3)
                    {
                        res.change_reservation();
                        t.print_all_rooms();
                        t.print_all_reservations();
                        
                    }
                    else if (option == 4)
                    {
                        res.delete_reservation();
                        t.print_all_rooms();
                        t.print_all_reservations();
                    }
                    else if (option == 5)
                    {
                        t.print_revenue_summary();
                    }
                    else if (option == 6)
                    {
                        ir.delete_tables();
                    }
                    else if (option == 7){
                        ir.fill_rooms_table();
                        ir.fill_reservations_table();
                    }
                    else 
                    {
                        //System.out.println("-- BAD INPUT --");
                        scanner.close();
                        return; 
                    }
                //}

           //scanner.close();
        } 
        catch (SQLException e) 
        {
	        System.err.println("SQLException: " + e.getMessage());
	    }
    }

}