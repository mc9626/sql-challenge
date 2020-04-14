-- Drop tables
Drop table if exists departments;
Drop table if exists dept_emp;
Drop table if exists dept_manager;
Drop table if exists employees;
Drop table if exists salaries;
Drop table if exists titles;

-- Create tables
CREATE TABLE departments (
    dept_no VARCHAR NOT NULL,
    dept_name VARCHAR NOT NULL
);
CREATE TABLE dept_emp (
    emp_no VARCHAR NOT NULL,
	dept_no VARCHAR NOT NULL,
    from_date date DEFAULT ('now'::text)::date NOT NULL,
	to_date date DEFAULT ('now'::text)::date NOT NULL
);
CREATE TABLE dept_manager (
    dept_no VARCHAR NOT NULL,
	emp_no VARCHAR NOT NULL,
    from_date date DEFAULT ('now'::text)::date NOT NULL,
	to_date date DEFAULT ('now'::text)::date NOT NULL
);
CREATE TABLE employees (
    emp_no VARCHAR NOT NULL,
	birth_date date DEFAULT ('now'::text)::date NOT NULL,
	first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
	gender VARCHAR(1) NOT NULL,
	hire_date date DEFAULT ('now'::text)::date NOT NULL
);
CREATE TABLE salaries (
    emp_no VARCHAR NOT NULL,
	salary integer NOT NULL,
    from_date date DEFAULT ('now'::text)::date NOT NULL,
	to_date date DEFAULT ('now'::text)::date NOT NULL
);
CREATE TABLE titles (
    emp_no VARCHAR NOT NULL,
	title VARCHAR NOT NULL,
    from_date date DEFAULT ('now'::text)::date NOT NULL,
	to_date date DEFAULT ('now'::text)::date NOT NULL
);

-- Import CSV files
COPY departments FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_departments.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_employees.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_salaries.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM '/Applications/PostgreSQL 11/temp-data/09-SQL_homework_assignment_data_titles.csv' DELIMITER ',' CSV HEADER;

select * from salaries

-- Question 1: Employee Information
SELECT employees.emp_no, employees.last_name, employees.first_name,employees.gender,salaries.salary
FROM employees
JOIN salaries
	on employees.emp_no = salaries.emp_no;
	
-- Question 2: Employees hired in 1986
SELECT emp_no, hire_date
FROM employees
WHERE hire_date >= '1986-01-01'
	and hire_date <= '1986-12-31';

-- Question 3: Manager information
SELECT dept_manager.dept_no, dept_manager.emp_no, employees.last_name, employees.first_name, dept_manager.from_date, dept_manager.to_date
FROM dept_manager
JOIN employees
	on dept_manager.emp_no = employees.emp_no
JOIN departments
	on dept_manager.dept_no = departments.dept_no;

--Question 4: Find department of each employee
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp
	on dept_emp.emp_no = employees.emp_no
JOIN departments
	on dept_emp.dept_no = departments.dept_no;

--Question 5: Employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name FROM employees
WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%';

--Question 6: Employees in Sales Department

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp
	on dept_emp.emp_no = employees.emp_no
JOIN departments
	on dept_emp.dept_no = departments.dept_no
WHERE dept_emp.dept_no IN
(
	SELECT dept_no FROM departments
	WHERE dept_name = 'Sales'
);

-- Question 7: Employees in Sales and Development Departments

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp
	on dept_emp.emp_no = employees.emp_no
JOIN departments
	on dept_emp.dept_no = departments.dept_no
WHERE dept_emp.dept_no IN
(
	SELECT dept_no FROM departments
	WHERE dept_name IN ('Sales','Development')
);

-- Question 8: Frequency count of employees' last names
SELECT last_name as "Last Name", COUNT(last_name) as "Count"
FROM employees
GROUP BY last_name
ORDER BY "Count" DESC;


