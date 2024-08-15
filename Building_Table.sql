CREATE TABLE Students_Data (
student_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
age INT CHECK (age>0),
grade CHAR(1) CHECK (grade IN ("A","B","C","D","F")) 
);
INSERT INTO Students_Data (student_id,name,age,grade)
VALUES
	(1,"Alaa",23,"A"),
    (2,"Aya",23,"A"),
    (3,"Ahmed",25,"B"),
    (4,"Emad",24,"C");

ALTER TABLE Students_Data
ADD COLUMN Email VARCHAR(100);

SELECT *
FROM Students_Data;
