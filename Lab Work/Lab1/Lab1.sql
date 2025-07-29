CREATE TABLE Employees (
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
               
select * from Employees;