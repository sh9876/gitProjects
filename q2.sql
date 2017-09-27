DECLARE
	v_max_sal		NUMBER;
	v_min_sal		NUMBER;
	v_avg_sal		NUMBER;
	v_count			NUMBER;
	v_dept_count		NUMBER;
	v_dept_maxsal		NUMBER;
	v_dept_minsal		NUMBER;
	v_dept_avgsal		NUMBER;
	v_location		VARCHAR2(30);
	v_dname			VARCHAR2(30);
	v_prev_dept		NUMBER := 0;
	v_dept_id		NUMBER;

	CURSOR c_dept IS
		SELECT department_name, location, department_id
		FROM departments
		ORDER BY department_name;

	CURSOR c_emp (p_deptno NUMBER) IS
		SELECT COUNT(*), MAX(salary), MIN(salary), AVG(salary), department_id
		FROM employees
		WHERE department_id = p_deptno
		GROUP BY department_id;
BEGIN
SELECT COUNT(*), MAX(salary), MIN(salary), AVG(salary)
INTO v_count, v_max_sal, v_min_sal, v_avg_sal
FROM employees;

 DBMS_OUTPUT.PUT_LINE (RPAD('NUMBER OF EMPLOYEES:', 60)|| v_count);
 DBMS_OUTPUT.PUT_LINE (RPAD('-', 60, '-'));
 DBMS_OUTPUT.PUT_LINE (RPAD('COMPANY MAXIMUM SALARY:', 50)|| TO_CHAR		(v_max_sal, '$99,999.99'));
 DBMS_OUTPUT.PUT_LINE (RPAD('COMPANY MINIMUM SALARY:', 50)|| TO_CHAR		(v_min_sal, '$99,999.99'));
 DBMS_OUTPUT.PUT_LINE (RPAD('COMPANY AVERAGE SALARY:', 50)|| TO_CHAR		(v_avg_sal, '$99,999.99'));
 DBMS_OUTPUT.PUT_LINE (RPAD('-', 60, '-'));

 FOR e_record1 IN c_dept LOOP

   OPEN c_emp (e_record1.department_id);
   LOOP
   	EXIT WHEN c_emp%NOTFOUND;
	FETCH c_emp INTO v_dept_count, v_dept_maxsal, v_dept_minsal, v_dept_avgsal, v_dept_id;
	IF v_prev_dept <> v_dept_id THEN
	    IF v_dept_avgsal > 0.80 * v_dept_maxsal AND v_dept_avgsal < 			1.11 * v_dept_minsal THEN
		DBMS_OUTPUT.PUT_LINE (RPAD('DEPARTMENT NAME:', 52)|| 				e_record1.department_name);
		DBMS_OUTPUT.PUT_LINE (RPAD('LOCATION: ', 52)|| 					e_record1.location);
		DBMS_OUTPUT.PUT_LINE (RPAD('NUMBER OF EMPLOYEES:', 60)||			v_dept_count);
		DBMS_OUTPUT.PUT_LINE (RPAD('MAXIMUM SALARY:', 50)||				TO_CHAR(v_dept_maxsal, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE (RPAD('MAXIMUM SALARY * 80%:', 50)|| 			TO_CHAR(0.80 * v_dept_maxsal, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE (RPAD('MINIMUM SALARY:', 50)|| 				TO_CHAR(v_dept_minsal, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE (RPAD('MINIMUM SALARY * 111%:', 50)|| 			TO_CHAR(1.11 * v_dept_minsal, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE (RPAD('AVERAGE SALARY:', 50)|| 				TO_CHAR(v_dept_avgsal, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
	  END IF;
        END IF;
   		v_prev_dept := v_dept_id;

    END LOOP;
   CLOSE c_emp;
 END LOOP;
END;
/
