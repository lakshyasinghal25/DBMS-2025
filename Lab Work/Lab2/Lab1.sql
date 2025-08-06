CREATE DATABASE IF NOT EXISTS DBMS_Lab;
-- DROP DATABASE IF EXISTS DBMS_Lab; 
USE DBMS_Lab;

CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE,
    is_active BOOLEAN,
    rating FLOAT
);

INSERT INTO Employees (first_name, last_name, email, department, salary, hire_date, is_active, rating)
SELECT
  ELT(FLOOR(1 + (RAND() * 5)), 'John', 'Jane', 'Alice', 'Bob', 'Charlie'),
  ELT(FLOOR(1 + (RAND() * 5)), 'Smith', 'Doe', 'Brown', 'Taylor', 'Johnson'),
  CONCAT(LEFT(UUID(), 8), '@example.com'),
  ELT(FLOOR(1 + (RAND() * 5)), 'HR', 'Engineering', 'Marketing', 'Finance', 'Sales'),
  ROUND(30000 + (RAND() * 70000), 2),
  DATE_ADD('2010-01-01', INTERVAL FLOOR(RAND() * 5000) DAY),
  FLOOR(RAND() * 2),
  ROUND(RAND() * 5, 1)
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
               UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
               UNION ALL SELECT 9 UNION ALL SELECT 10) a
   CROSS JOIN (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
               UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
               UNION ALL SELECT 9 UNION ALL SELECT 10) b
   CROSS JOIN (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
               UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
               UNION ALL SELECT 9 UNION ALL SELECT 10) c;
               
SELECT * FROM Employees;

CREATE TABLE IF NOT EXISTS Departments (
  dept_id   INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(50)    NOT NULL UNIQUE,
  location  VARCHAR(100)
);

ALTER TABLE Employees
  ADD COLUMN dept_id INT,
  ADD CONSTRAINT fk_emp_dept
    FOREIGN KEY (dept_id)
    REFERENCES Departments(dept_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

INSERT INTO Departments (dept_name, location) VALUES
  ('HR', 'New Delhi'),
  ('Engineering', 'Bangalore'),
  ('Marketing', 'Mumbai'),
  ('Finance', 'Chennai');

SET SQL_SAFE_UPDATES = 0;
UPDATE Employees
SET dept_id = FLOOR(1 + RAND() * (SELECT COUNT(*) FROM Departments));
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Employees
  ADD CONSTRAINT chk_salary_min
    CHECK (salary >= 25000);

ALTER TABLE Employees
  DROP CHECK chk_salary_min;

ALTER TABLE Employees
  DROP FOREIGN KEY fk_emp_dept;
ALTER TABLE Employees
  ADD CONSTRAINT fk_emp_dept
    FOREIGN KEY (dept_id)
    REFERENCES Departments(dept_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Employees WHERE is_active = FALSE;
UPDATE Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
SET e.salary = ROUND(e.salary * 1.10, 2)
WHERE d.dept_name = 'Engineering';
SET SQL_SAFE_UPDATES = 1;

-- tee C:/logs/dbms_log.txt;

SELECT employee_id, first_name, last_name, salary
FROM Employees
WHERE is_active = TRUE
  AND salary > 50000
ORDER BY salary DESC;

SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, hire_date
FROM Employees
WHERE hire_date BETWEEN '2012-01-01' AND '2018-12-31';

SELECT employee_id, email
FROM Employees
WHERE email LIKE '%@example.com';

SELECT employee_id, first_name, last_name
FROM Employees
WHERE first_name LIKE 'J%';

SELECT department, COUNT(*) AS num_employees, ROUND(AVG(salary),2) AS avg_salary
FROM Employees
GROUP BY department;

SELECT department, COUNT(*) AS num_employees
FROM Employees
GROUP BY department
HAVING COUNT(*) > 10;

SELECT d.dept_name, COUNT(e.employee_id) AS num_employees, ROUND(AVG(e.salary),2) AS avg_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

SELECT employee_id, first_name, last_name, rating
FROM Employees
WHERE is_active = TRUE
ORDER BY rating DESC
LIMIT 5;

-- notee;