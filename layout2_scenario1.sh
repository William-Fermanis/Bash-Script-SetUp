#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (or with sudo privileges)." >&2
    exit 1
fi

# Variables
COURSE_CODE="cybr371"
NUM_STUDENTS=112
ASSESSMENTS=("lab1" "lab2" "lab3" "lab4" "lab5" "assignment1" "assignment2" "midterm" "final") 
TUTORS=("alix" "annie" "david" "dedy" "krishna" "alvien")
LECTURERS=("arman" "lisa")
groupadd "Lecturers"
groupadd "Tutors"
groupadd "Students"

# Base course directory
COURSE_DIR="/courses/$COURSE_CODE"
mkdir -p "$COURSE_DIR"
echo "Creating directory structure..."

# Create main directories
mkdir -p "$COURSE_DIR/grades"
mkdir -p "$COURSE_DIR/assessments"
mkdir -p "$COURSE_DIR/submissions"


# Create the grades file
touch "$COURSE_DIR/grades/grades.xlsx"

# Create assessment directories and files
for assess in "${ASSESSMENTS[@]}"; do
    ASSESSMENT_DIR="$COURSE_DIR/assessments/$assess"
    mkdir -p "$ASSESSMENT_DIR"
    touch "$ASSESSMENT_DIR/questions.pdf"
    touch "$ASSESSMENT_DIR/solutions.pdf"
done

# Create student submission directories
for i in $(seq -w 1 $NUM_STUDENTS); do
    STUDENT="student$i"
    STUDENT_SUBMISSION_DIR="$COURSE_DIR/submissions/$STUDENT"
    mkdir -p "$STUDENT_SUBMISSION_DIR"

    for assess in "${ASSESSMENTS[@]}"; do
        ASSESSMENT_SUBMISSION_DIR="$STUDENT_SUBMISSION_DIR/$assess"
        mkdir -p "$ASSESSMENT_SUBMISSION_DIR"
        touch "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
    done
done

# Create users (without home directories)
echo "Creating tutor users..."

for tutor in "${TUTORS[@]}"; do
    useradd --no-create-home -g "Tutors"  "$tutor"
done


echo "Creating lecturer users..."

for lecturer in "${LECTURERS[@]}"; do
    useradd --no-create-home -g "Lecturers"  "$lecturer"
done

#Provide Arman with all necessay priviledges and ownerships
chown arman:Lecturers "$COURSE_DIR"
chown arman:Lecturers "$COURSE_DIR/grades/grades.xlsx"
chown arman:Lecturers "$COURSE_DIR/assessments"
chown arman:Lecturers "$COURSE_DIR/submissions"

#Set necessary priviledges for grades.xlsx
chmod 770 "$COURSE_DIR/grades/grades.xlsx"
setfacl -m g:Tutors:rwX "$COURSE_DIR/grades/grades.xlsx"

#Provide priviledges for Assessment Directory for all groups
#Include all groups to only run for loop once
for assess in "${ASSESSMENTS[@]}"; do
        ASSESSMENT_DIR="$COURSE_DIR/assessments/$assess"
        chown arman:Lecturers "$ASSESSMENT_DIR"
        chown arman:Lecturers "$ASSESSMENT_DIR/questions.pdf"
        chown arman:Lecturers "$ASSESSMENT_DIR/solutions.pdf"
        chmod 660 "$ASSESSMENT_DIR/questions.pdf"
        chmod 660 "$ASSESSMENT_DIR/solutions.pdf"
        setfacl -m g:Tutors:r-- "$ASSESSMENT_DIR/solutions.pdf"
        setfacl -m g:Tutors:r-- "$ASSESSMENT_DIR/questions.pdf"
        setfacl -m g:Students:r-- "$ASSESSMENT_DIR/questions.pdf"

 done


echo "Creating Student users..."

for i in $(seq -w 1 $NUM_STUDENTS); do
    STUDENT="student$i"
    useradd --no-create-home -g "Students" "$STUDENT"

    #Provide priviledges for Submission Directory for all groups
    STUDENT_SUBMISSION_DIR="$COURSE_DIR/submissions/$STUDENT"
    for assess in "${ASSESSMENTS[@]}"; do
        ASSESSMENT_SUBMISSION_DIR="$STUDENT_SUBMISSION_DIR/$assess"
        chown arman "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
        chown arman "$ASSESSMENT_SUBMISSION_DIR"     
        setfacl -m u:"$STUDENT":rw- "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
        setfacl -m u:"$STUDENT":rx "$ASSESSMENT_SUBMISSION_DIR"
        setfacl -m g:Lecturers:rX "$ASSESSMENT_SUBMISSION_DIR" 
        setfacl -m g:Lecturers:r "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
        setfacl -m g:Tutors:r "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
        setfacl -m g:Tutors:rX "$ASSESSMENT_SUBMISSION_DIR"
        setfacl -m o::--- "$ASSESSMENT_SUBMISSION_DIR/answers.docx"
        setfacl -m o::--- "$ASSESSMENT_SUBMISSION_DIR"
    done
done


echo "Initial directory structure (for layout 2) and users created."


