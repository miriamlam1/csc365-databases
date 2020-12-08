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

TLastName = 0
TFirstName = 1
TClassroom = 2

# search students by last name
# print the last name, first name, grade and classroom assignment, and teacher name
def student(students, teacherarr, lname):
    for student in students:
        if student[0] == lname:
            
            for teacher in teacherarr:
                if int(student[3]) == int(teacher[2]):
                    print(student[0]+","+ student[1]+","+ student[2]+","+ student[3]+ "," +teacher[TLastName]+ "," +teacher[TFirstName])
            return

def student_bus(students, lname):
    for student in students:
        if student[0] == lname:
            print(student[StLastName]+","+ student[StFirstName]+","+ student[Bus])
            return

def teacher(students, teacherarr, tlname):
    for t in teacherarr:
        if t[TLastName] == tlname:
            for s in students:
                #print(s[Classroom])
                if int(s[Classroom]) == int(t[TClassroom]):
                    print(s[StLastName]+","+ s[StFirstName])

def grade(students, grade):
    for s in students:
        if s[Grade] == grade:
            print(s[StLastName]+","+ s[StFirstName])

def gradeh(students, teacherarr, grade, high):
    max = 0
    min = 99
    astudent = students[0]
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
    for t in teacherarr:
        if int(t[TClassroom]) == int(astudent[Classroom]):
            print(astudent[StLastName]+","+astudent[StFirstName]+","+ astudent[GPA]+","+ t[TLastName]+","+ t[TFirstName])

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
        print("grade:", grade + " avg:", str(asum/students_in_grade))

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
        line = line.replace(" ", "")
        line = line.replace("\n", "")
        line = line.split(",")
        struct.append(list(line))
    f.close()
    return struct

def classroom(students, argument):
    for s in students:
        if s[Classroom] == argument:
            print(s[StFirstName]+","+s[StLastName])

def gradet(students, teacherarr, argument):
    tlist = []
    for s in students:
        if int(argument) == int(s[Grade]):
            for t in teacherarr:
                if int(s[Classroom]) == int(t[TClassroom]):
                    if t not in tlist:
                        tlist.append(t)
    for item in tlist:
        print(",".join(item))

def classroomt(students, teacherarr, argument):
    for t in teacherarr:
        if t[TClassroom] == argument:
            print(t[TLastName]+","+t[TFirstName])

def enrollments(students, teacherarr):
    students = sorted(students, key = lambda a: a[Classroom])
    currclass = students[0][Classroom]
    num = 0
    for s in students:
        if s[Classroom] == currclass:
            num += 1
        else:
            print("ROOM: ", currclass, "students: ", num)
            currclass = s[Classroom]
            num = 1
    print("ROOM: ", currclass, "students: ", num)


def analytics(students, teacherarr, option):
    totalGPA = 0
    totalStud = 0

    if option == 1:
        for i in range(7):
            totalGPA = 0
            totalStud = 0
            for s in students:
                if int(s[Grade]) == i:
                    totalGPA += float(s[GPA])
                    totalStud += 1
            if totalStud>0:
                print("grade ", i, "gpa avg", totalGPA/totalStud)

    elif option == 2:
        for t in teacherarr:
            totalStud = 0
            totalGPA = 0
            for s in students:
                if s[Classroom] == t[TClassroom]:
                    totalGPA += float(s[GPA])
                    totalStud += 1
            if totalStud>0:
                print("teacher", t[TLastName].rjust(2), "gpa avg    ", totalGPA/totalStud)

    
    else:
        students = sorted(students, key = lambda a: a[Bus])
        currclass = students[0][Bus]
        num = 0
        for s in students:
            if int(s[Bus]) == int(currclass):
                totalGPA += float(s[GPA])
                totalStud += 1
            else:
                if totalStud> 0:
                    print("bus",currclass, "gpa avg    ", totalGPA/totalStud)
                totalStud = 1
                totalGPA = float(s[GPA])
                currclass = int(s[Bus])
        if totalStud> 0:
                    print("bus", currclass, "gpa avg    ", totalGPA/totalStud)
           
def gpa_sort(students):
    students = sorted(students, key = lambda a: a[GPA], reverse=True)
    for s in students:
        print(s[StLastName]+","+s[GPA])

def prog_loop(students, teacherarr, cmd):

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
        student(students, teacherarr, argument)
    elif (cmd[0] == "S" or cmd == "Student") and (flag[0] == "B"):
        student_bus(students, argument)
    elif cmd[0] == "T" or cmd == "Teacher":
        teacher(students, teacherarr, argument)
    elif cmd[0] == "B" or cmd == "Bus":
        bus(students, argument)
    elif (cmd[0] == "A" or cmd == "Average") and (argument != None):
        average(students, argument)
    elif cmd[0] == "I" or cmd == "Info":
        info(students)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag == None):
        grade(students, argument)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag[0] == "H" or flag == "High"):
        gradeh(students, teacherarr, argument, True)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag[0] == "L" or flag == "Low"):
        gradeh(students, teacherarr, argument, False)
    elif (cmd[0] == "G" or cmd == "Grade") and (flag[0] == "T"):
        gradet(students, teacherarr, argument)
    elif (cmd[0] == "C" or cmd == "Classroom") and (flag == None):
        classroom(students, argument)
    elif (cmd[0] == "C" or cmd == "Classroom") and (flag[0] == "T"):
        classroomt(students, teacherarr, argument)
    elif (cmd[0] == "E" or cmd == "Enrollments"):
        enrollments(students, teacherarr)
    # analytics
    elif (cmd[0] == "N" or cmd == "Analytics") and (argument == None):
        gpa_sort(students)
    elif (cmd[0] == "N" or cmd == "Analytics") and (argument == "G"):
        analytics(students, teacherarr, 1)
    elif (cmd[0] == "N" or cmd == "Analytics") and (argument == "T"):
        analytics(students,teacherarr, 2)
    elif (cmd[0] == "N" or cmd == "Analytics") and (argument == "B"):
        analytics(students, teacherarr,3)
    elif (cmd[0] == "N" or cmd == "Analytics") and (argument == "G"):
        analytics(students,teacherarr, 1)

def main():
    # file management
    listarr = file_to_struct("list.txt")
    teachersarr = file_to_struct("teachers.txt")
    # input test management
    if len(sys.argv) > 1:
        f = open(sys.argv[1], "r")
        for line in f:
            prog_loop(listarr,teachersarr, line)
        f.close()
    
    # get command line inputs from user
    else:
        while 1:
            cmd = input("Enter a command (Q to quit): ") 
            prog_loop(listarr, teachersarr, cmd)

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