DECLARE
	CURSOR c_dept IS
		SELECT department_name, location, department_id
		FROM departments;

	CURSOR c_emp (p_deptno NUMBER) IS
		SELECT employee_name, salary
		FROM employees
		WHERE department_id = p_deptno;

	e_record2	c_emp%ROWTYPE;

	v_deptno		NUMBER;
	v_loc			VARCHAR2(30);
	v_dname			VARCHAR2(30);
	v_count			NUMBER := 0;
	v_max			NUMBER;
	v_avg			NUMBER;
	v_new_avg		NUMBER;
	v_sal			NUMBER;
	v_prev_dept		NUMBER := 0;
	v_ename			VARCHAR2(200);
	v_empname		VARCHAR2(200);

BEGIN
	FOR e_record IN c_dept LOOP
		v_deptno := e_record.department_id;
		v_loc	 := e_record.location;
		v_dname  := e_record.department_name;

		SELECT MAX(salary), AVG(salary)
		INTO v_max, v_avg
		FROM employees
		WHERE department_id = v_deptno;

	 OPEN c_emp (v_deptno);
	 LOOP
	 FETCH c_emp INTO v_ename, v_sal;
	 EXIT WHEN c_emp%NOTFOUND;
	 v_new_avg := 0.80 * v_avg;
	 IF v_sal > v_new_avg THEN
		v_count := v_count + 1;
		v_empname := v_empname||' '||v_ename||' '|| TRIM(TO_CHAR(v_sal, '$99,999.99'))||';';
	 END IF;
	 END LOOP;
	 CLOSE c_emp;
	IF v_count > 2 THEN
		DBMS_OUTPUT.PUT_LINE(RPAD('DEPARTMENT ID:', 23)|| v_deptno);
		DBMS_OUTPUT.PUT_LINE(RPAD('DEPARTMENT NAME:', 23)|| v_dname);
		DBMS_OUTPUT.PUT_LINE(RPAD('LOCATION:', 23)||v_loc);
		DBMS_OUTPUT.PUT_LINE(RPAD('MAXIMUM SALARY:', 21)||TO_CHAR(v_max, 		'$99,999.99'));
		DBMS_OUTPUT.PUT_LINE(RPAD('AVERAGE SALARY:', 21)||TO_CHAR(v_avg, 		'$99,999.99'));
		DBMS_OUTPUT.PUT_LINE(RPAD('80% OF AVERAGE SALARY:', 21)||TO_CHAR		(v_new_avg, '$99,999.99'));
		DBMS_OUTPUT.PUT_LINE('There are '||v_count||' employees whose salaries are above '|| TRIM(TO_CHAR(v_new_avg, '$99,999.99'))||'.');
		DBMS_OUTPUT.PUT_LINE ('EMPLOYEE NAME AND SALARY: '||v_empname);

		DBMS_OUTPUT.PUT_LINE ('                      		    ');

	 END IF;
		v_count := 0;
		v_empname := NULL;
	END LOOP;
END;
/
