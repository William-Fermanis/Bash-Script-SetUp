# README_SCENARIO2

## Overview
The code implemented correctly provides priveledges to users and groups such that all tests in the test_layout2_scenario2.sh pass

For sake of efficiency all Methodologies from 1 - 3 will be removed as they are identical to README_SCENARIO1

## Methodology

4. ### Set priviledges for student submission documetns and directories (Line 100 - 115)
- Script sets ownership of submission directory and answers.docx to arman to avoid any escalation of priveledge threats posed by students
- Script uses setfacl for all priviledges in submission directory and answers.docx due to diverse needs of access/priviledge 

- Students are given access to both read and write into their answers.docx file
- Students are given access to read, write, or execute their directory for scenario 2, students will then be able to add files, or folders as needed

- Lecturers are given ownership but only read access to both the answers.docx file and the submission directory, Tutors are also given only read access. This is to ensure that students are the only ones able to put answers into their own answers.docx file or submission directory. 
- Lecturers and Tutors can traverse through folders added by the student but cannot write into a file or directory and should not be able to 
- If a Lecturer or Tutor would like to give comments then permission should be given to them to write into the file or directory using the "w" tag in the setfacl command however it is assumed in this case that that is not neccessary

- Other users are not allowed entry into the submission directory or the file contained there

--- 
## Trade-offs
- Due to lack of specification of requirements disgression was given to the fact that Students can traverse into other Students directories. If a more thorough procedure were followed Students would only be able to enter into their own directories.
- For-loop complexity did make run-time longer however this is an acceptable flaw de to program only being run once at the start of its lifetime
