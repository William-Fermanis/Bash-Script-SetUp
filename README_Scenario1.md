# README_SCENARIO1

## Overview
The code implemented correctly provides priveledges to users and groups such that all tests in the test_layout2_scenario1.sh pass

## Methodology

1. ### Grouping (Line 15 - 17)
- Script creates groups for priviledges
--- 

2. ### Make arman owner (Line 68 - 72)
- Script here makes arman host for all base directories and grades file
--- 

3. ### Set priviledges for grades and assessments documents and directories (Line 74 - 91)
- Script sets priviledges for arman and Lecturers as read and write for the grades document
- Script provides special permission via setfacl for tutors to read and write the grade document as an exception from the chmod set earlier

- Script sets ownership for all assessment directories and content to arman and Lecturers
- Script sets priviledges to read and write for arman and Lecturers
- Script provides special permissions to Tutors to read both solutions and questions
- Script provides special permissions to Students to read only questions.pdf

- chmod 660 command does not require any changes to be made to restrict access from guest users

--- 

4. ### Set priviledges for student submission documetns and directories (Line 100 - 115)
- Script sets ownership of submission directory and answers.docx to arman to avoid any escalation of priveledge threats posed by students
- Script uses setfacl for all priviledges in submission directory and answers.docx due to diverse needs of access/priviledge 

- Students are given access to both read and write into their answers.docx file
- Students are only given access to read or execute their directory for scenario 1

- Lecturers are given ownership but only read access to both the answers.docx file and the submission directory, Tutors are also given only read access. This is to ensure that students are the only ones able to put answers into their own answers.docx file. If a Lecturer or Tutor would like to give comments then permission should be given to them to write into the file or directory using the "w" tag in the setfacl command however it is assumed in this case that that is not neccessary

- Other users are not allowed entry into the submission directory or the file contained there

--- 
## Trade-offs
- Due to lack of specification of requirements disgression was given to the fact that Students can traverse into other Students directories. If a more thorough procedure were followed Students would only be able to enter into their own directories.
- For-loop complexity did make run-time longer however this is an acceptable flaw de to program only being run once at the start of its lifetime
