ACCEPT p_num PROMPT 'ENTER POSITIVE INTEGER: '
DECLARE
	v_sex 		VARCHAR2(7);
	v_num		NUMBER;

	CURSOR c_baby IS
		SELECT sex, rank, given_name, approximate_number
		FROM popular_baby_names
		WHERE rank <= &p_num
		ORDER BY sex;
BEGIN
   IF &p_num > 0 THEN

	DBMS_OUTPUT.PUT_LINE ('SEX'||' '|| 'RANK'||' '|| 'GIVEN NAME'||' '|| 				'APPROXIMATE NUMBER');
	DBMS_OUTPUT.PUT_LINE (RPAD('=', 40, '='));

	FOR e_record IN c_baby LOOP
		IF e_record.sex = 'M' THEN
			v_sex := 'Male';
		ELSIF e_record.sex = 'F' THEN
			v_sex := 'Female';
		END IF;
	DBMS_OUTPUT.PUT_LINE (RPAD(e_record.sex, 5)|| RPAD(e_record.rank,5)||
			    RPAD(e_record.given_name,15)||e_record.approximate_number);

	END LOOP;
   ELSE
	DBMS_OUTPUT.PUT_LINE ('Invalid Number!');
   END IF;

END;
/
