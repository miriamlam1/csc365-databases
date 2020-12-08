# Miriam Lam
# Databases CSC365
# The program will look through students.txt file in the same directory
# Some starter code taken from Canvas

import sys

StLastName = 0
StFirstName = 1
Grade = 2
Classroom = 3
Bus = 4
GPA = 5
TLastName = 6
TFirstName = 7

# search students by last name
# print the last name, first name, grade and classroom assignment, and teacher name
def student(students, lname):
    for student in students:
        if student[0] == lname:
            print(student[0]+","+ student[1]+","+ student[2]+","+ student[3]+ ","+ student[6]+","+ student[7])
            return

def student_bus(students, lname):
    for student in students:
        if student[0] == lname:
            print(student[StLastName]+","+ student[StFirstName]+","+ student[Bus])
            return

def teacher(students, tlname):
    for s in students:
        if s[TLastName] == tlname:
            print(s[StLastName]+","+ s[StFirstName])

def grade(students, grade):
    for s in students:
        if s[Grade] == grade:
            print(s[StLastName]+","+ s[StFirstName])

def gradeh(students, grade, high):
    max = 0
    min = 99
    astudent = None
    for s in students:
        if s[Grade] == grade:
            if high == True:
                if float(s[GPA]) > max:
                    astudent = s
                    max = float(s[GPA])
            if high == False:
                if float(s[GPA]) < min:
                    astudent = s
                    min = float(s[GPA])
    if (astudent == None):
        return
    print(astudent[StLastName]+","+astudent[StFirstName]+","+ astudent[GPA]+","+ 
    astudent[TLastName]+","+ astudent[TFirstName])

def bus(students, busNo):
    for s in students:
        if s[Bus] == busNo:
            print(s[StFirstName]+","+ s[StLastName]+","+ s[Grade]+","+ s[Classroom])

def average(students, grade):
    asum = 0
    students_in_grade = 0
    for s in students:
        if s[Grade] == grade:
            asum += float(s[GPA])
            students_in_grade += 1
    
    if students_in_grade == 0:
        print(grade+","+ "0")
    else:
        print(grade + ",", str(asum/students_in_grade))

def info(students):
    num_students = [0]*7
    for s in students:
        grade = int(s[Grade])
        num_students[grade] += 1
    for i in range(len(num_students)):
        print(i, ":", num_students[i])

# creating a 2D array (table) of students
def file_to_struct(fname):
    try:
        f = open(fname, "r")
    except IOError:
        print("Error: File not found:", fname)
        exit()
    struct = []
    for line in f:
        line = line.strip().split(",")
        struct.append(list(line))
    f.close()
    return struct

def prog_loop(students, cmd):

    # quit command
    if cmd[0] == "Q" or cmd == "Quit":
        exit()

    # flag checking and setting
    flag = None
    argument = None
    command_line = cmd.split()
    if len(command_line)>= 2:
        argument = command_line[1]
    if len(command_line)>= 3:
        flag = command_line[2]

    # main switch statement
    if (cmd[0] == "S" or cmd == "Student") and (flag == None):
        student(students, argument)
    elif (cmd[0] == "S" or cmd == "Student") and (flag[0] == "B"):
        student_bus(students, argument)
    elif cmd[0] == "T" or cmd == "Teacher":
        teacher(students, argument)
    elif cmd[0] == "B" or cmd == "Bus":
        bus(students, argument)
    elif (cmd[0] == "A" or cmd == "Average") and (argument != None):
        average(students, argument)
    elif cmd[0] == "I" or cmd == "Info":
        info(students)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag == None):
        grade(students, argument)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag[0] == "H" or flag == "High"):
        gradeh(students, argument, True)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag[0] == "L" or flag == "Low"):
        gradeh(students, argument, False)

def main():
    # file management
    students = file_to_struct("students.txt")

    # input test management
    if len(sys.argv) > 1:
        f = open(sys.argv[1], "r")
        for line in f:
            prog_loop(students, line)
        f.close()
    
    # get command line inputs from user
    else:
        while 1:
            cmd = input("Enter a command (Q to quit): ") 
            prog_loop(students, cmd)

if __name__ == "__main__":
    main()

# user interface
# print("""Enter one of the following commands:
# S[tudent]: <lastname> [B[us]]
# T[eacher]: <lastname>
# B[us]: <number>
# G[rade]: <number> [H[igh]|L[ow]]
# A[verage]: <number>
# I[nfo]
# Q[uit]""")