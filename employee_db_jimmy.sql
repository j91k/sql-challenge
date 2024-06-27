-- Creating table 'employees'
create table employees (
	emp_no integer not null,
	emp_title varchar not null,
	birth_date date not null,
	first_name varchar not null,
	last_name varchar not null,
	sex char(1) not null,
	hire_date date not null,
	primary key (emp_no)
);

-- checking to see if import was done correctly
select *
from employees
limit 5;

-- Create table 'titles'
create table titles (
	title_id varchar not null,
	title varchar not null,
	primary key (title_id)
);

-- checking to see if import was done correctly
select *
from titles
limit 7;

-- Altered Existing employees table to make reference between titles table
alter table employees
add foreign key (emp_title) references titles(title_id);

-- Creating table 'departments'
create table departments (
	dept_no varchar not null,
	dept_name varchar not null,
	primary key (dept_no)
);

-- checking to see if import was done correctly
select *
from departments
limit 5;

-- creating table 'dept_emp'
create table dept_emp (
	emp_no integer not null,
	dept_no varchar not null,
	primary key (emp_no, dept_no),
	foreign key (emp_no) references employees (emp_no),
	foreign key (dept_no) references departments(dept_no)   
);

-- checking to see if import was done correctly
select *
from dept_emp
limit 10;

-- Creating table 'dept_manager'
create table dept_manager (
	dept_no varchar not null,
	emp_no integer not null, 
	primary key (dept_no, emp_no),
	foreign key (emp_no) references employees(emp_no),
	foreign key (dept_no) references departments(dept_no)
);

-- checking to see if import was done correctly
select *
from dept_manager
limit 5;

-- Creating table 'salaries'
create table salaries (
	emp_no integer not null,
	salary integer not null,
	primary key (emp_no),
	foreign key (emp_no) references employees(emp_no)
);

-- checking to see if import was done correctly
select *
from salaries
limit 5;

-- 1. List the employee number, last name, first name, sex, and salary of each employee
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees as e
inner join salaries as s on e.emp_no = s.emp_no
order by emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986
select e.first_name, e.last_name, e.hire_date
from employees as e
where extract(year from e.hire_date) = 1986;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name
select dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
from dept_manager as dm
inner join employees as e on dm.emp_no = e.emp_no
inner join departments as d on dm.dept_no = d.dept_no;

-- 4. List the department number for each employee along with that employee's employee number, last name, first name and department name
select de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
from dept_emp as de
inner join employees as e on de.emp_no = e.emp_no
inner join departments as d on de.dept_no = d.dept_no;

-- 5. List first name, last name, and sex of each employee whos first name is Hercules and whos last name begins with the letter B
select first_name, last_name, sex
from employees
where first_name = 'Hercules' and last_name like 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name
select e.emp_no, e.last_name, e.first_name
from employees as e
where e.emp_no in
(
	select de.emp_no
	from dept_emp as de
	where de.dept_no in
	(
		select d.dept_no
		from departments as d
		where d.dept_name = 'Sales'
	)
)
order by e.emp_no;

-- Alternative way of doing the question above
select e.emp_no, e.last_name, e.first_name
from employees as e
inner join dept_emp as de on e.emp_no = de.emp_no
inner join departments as d on de.dept_no = d.dept_no
where d.dept_name = 'Sales';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
select e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
inner join dept_emp as de on e.emp_no = de.emp_no
inner join departments as d on de.dept_no = d.dept_no
where d.dept_name = 'Sales' or d.dept_name = 'Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
select e.last_name, count(e.last_name) as frequency
from employees as e
group by e.last_name
order by frequency desc;