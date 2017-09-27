DECLARE
	CURSOR c_emp (emp_id 	NUMBER) IS
		SELECT employee_name, job_title, manager_id
		FROM employees
		WHERE employee_id = emp_id;

	CURSOR c_manager (mgr_id   NUMBER) IS
		SELECT employee_name, job_title
		FROM employees
		WHERE employee_id = mgr_id;

	v_empid				NUMBER;
	v_ename				VARCHAR2(15);
	v_emptitle			VARCHAR2(25);
        v_mgrid				NUMBER;
	v_mgr_name			VARCHAR2(15);
	v_mgr_title			VARCHAR2(25);
	v_manager			VARCHAR2(50);
	v_level				NUMBER := 0;
	v_count				NUMBER := 0;
	v_error1			EXCEPTION;

BEGIN
	SELECT COUNT(*)
	INTO v_count
	FROM employees
	WHERE employee_id = &p_num;

	IF v_count <> 1 THEN
			RAISE v_error1;
	ELSE
		DBMS_OUTPUT.PUT_LINE (RPAD('LEVEL ', 8)|| RPAD(' Employee: id ',20)|| RPAD(' Name ', 14)|| RPAD(' Job Title ', 20)|| 				RPAD(' Manager id', 14) || RPAD('Name ', 8) ||' Job Title ');
		DBMS_OUTPUT.PUT_LINE (RPAD('-', 95, '-'));

	v_empid := &p_num;

	LOOP
		OPEN c_emp (v_empid);
	  		FETCH c_emp INTO v_ename, v_emptitle, v_mgrid;
	  		EXIT WHEN c_emp%NOTFOUND;

		OPEN c_manager (v_mgrid);
		LOOP
		  	FETCH c_manager INTO v_mgr_name, v_mgr_title;
		  	EXIT WHEN c_manager%NOTFOUND;

	  	END LOOP;
          	CLOSE c_manager;

	  		IF v_mgrid IS NULL THEN
				v_mgr_name 	:= NULL;
				v_mgr_title 	:= NULL;
	  		END IF;

			v_level := v_level + 1;

	  		DBMS_OUTPUT.PUT_LINE (RPAD(v_level, 10) || RPAD(v_empid, 18)|| RPAD(v_ename, 15) || RPAD(v_emptitle, 20) ||
				RPAD(NVL(TO_CHAR(v_mgrid), '-----'), 13) || RPAD(NVL(v_mgr_name, '------'), 10) || RPAD								(NVL(v_mgr_title, '------'), 20));

		v_empid := v_mgrid;

	 	CLOSE c_emp;
         END LOOP;
	 END IF;

	 EXCEPTION
		WHEN v_error1 THEN
			DBMS_OUTPUT.PUT_LINE ('This employee doesn''t exist');
END;
/
