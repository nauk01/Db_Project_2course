--TASK 1
set serveroutput on;

DECLARE
    CURSOR cur_howmany IS
        SELECT ders_kod FROM course_sections WHERE ders_kod IN (SELECT ders_kod FROM course_selections_2016 GROUP BY ders_kod
            HAVING COUNT(*) >600) and year='2016' and term='1' ORDER BY ders_kod;
    v_top       course_sections.ders_kod%TYPE;
    v_top2      course_sections.ders_kod%TYPE;
BEGIN
    v_top2 := ' ';
    OPEN cur_howmany;
    LOOP
        FETCH cur_howmany INTO v_top;
        EXIT WHEN cur_howmany%NOTFOUND;
        IF v_top != v_top2
            THEN v_top2 := v_top;
            DBMS_OUTPUT.PUT_LINE(v_top2);
        END IF;
        
    END LOOP;
    CLOSE cur_howmany;
END;
    



-- Task 6
DECLARE
    CURSOR cur_teachers IS
        SELECT hour_num FROM course_sections 
            WHERE emp_id ='10438' and year='2017' and term='1'; 
    v_count     NUMBER;
    v_forstore  course_sections.hour_num%TYPE;
BEGIN
    v_count :=0;
    OPEN cur_teachers;
    LOOP
        FETCH cur_teachers INTO v_forstore;
        EXIT WHEN cur_teachers%NOTFOUND;
        v_count:=v_count+v_forstore;
        DBMS_OUTPUT.PUT_LINE(v_count || ' ' ||v_forstore);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_count);
    CLOSE cur_teachers;
END;


set SERVEROUTPUT on;

--TASK 13
CREATE OR REPLACE PROCEDURE p_all_retakes_2016 IS
    CURSOR cur_selec_2016 IS
        SELECT ders_kod FROM course_selections_2016
            WHERE qiymet_herf='F';
    v_ders_kod      course_selections_2016.ders_kod%TYPE;
    
    CURSOR cur_sections IS
        SELECT ders_kod, credits FROM course_sections;
    v_ders_kod2      course_sections.ders_kod%TYPE;
    v_credit         course_sections.credits%TYPE;
    v_profit         NUMBER;
    v_count          NUMBER;
    
    CURSOR cur_selec_2017 IS
        SELECT ders_kod FROM course_selections_2017
            WHERE qiymet_herf='F';
BEGIN
    v_profit := 0;
    v_count := 0;
    OPEN cur_selec_2016;
    LOOP
        FETCH cur_selec_2016 INTO v_ders_kod;
        EXIT WHEN cur_selec_2016%NOTFOUND;
        OPEN cur_sections;
        LOOP
            FETCH cur_sections INTO v_ders_kod2, v_credit;
            EXIT WHEN cur_sections%NOTFOUND;
            IF v_ders_kod = v_ders_kod2 
                THEN v_count := v_count + 1;
                v_profit := v_profit + (v_credit*25000);
            END IF;
            EXIT WHEN v_ders_kod = v_ders_kod2;
        END LOOP;
        CLOSE cur_sections;
    END LOOP;
    CLOSE cur_selec_2016;
    DBMS_OUTPUT.PUT_LINE(v_count || ' retakes, ' || v_profit || ' tg.');
    
    OPEN cur_selec_2017;
    LOOP
        FETCH cur_selec_2017 INTO v_ders_kod;
        EXIT WHEN cur_selec_2017%NOTFOUND;
        OPEN cur_sections;
        LOOP
            FETCH cur_sections INTO v_ders_kod2, v_credit;
            EXIT WHEN cur_sections%NOTFOUND;
            IF v_ders_kod = v_ders_kod2 
                THEN v_count := v_count + 1;
                v_profit := v_profit + (v_credit*25000);
            END IF;
            EXIT WHEN v_ders_kod = v_ders_kod2;
        END LOOP;
        CLOSE cur_sections;
    END LOOP;
    CLOSE cur_selec_2017;
    DBMS_OUTPUT.PUT_LINE(v_count || ' retakes, ' || v_profit || ' tg.');
END;



CREATE OR REPLACE PROCEDURE p_all_retakes_2017 IS
    CURSOR cur_selec_2017 IS
        SELECT ders_kod FROM course_selections_2017
            WHERE qiymet_herf='F';
    v_ders_kod      course_selections_2017.ders_kod%TYPE;
    
    CURSOR cur_sections IS
        SELECT ders_kod, credits FROM course_sections;
    v_ders_kod2      course_sections.ders_kod%TYPE;
    v_credit         course_sections.credits%TYPE;
    v_profit         NUMBER;
    v_count          NUMBER;
BEGIN
    v_profit := 0;
    v_count := 0;
    OPEN cur_selec_2017;
    LOOP
        FETCH cur_selec_2017 INTO v_ders_kod;
        EXIT WHEN cur_selec_2017%NOTFOUND;
        OPEN cur_sections;
        LOOP
            FETCH cur_sections INTO v_ders_kod2, v_credit;
            EXIT WHEN cur_sections%NOTFOUND;
            IF v_ders_kod = v_ders_kod2 
                THEN v_count := v_count + 1;
                v_profit := v_profit + (v_credit*25000);
            END IF;
            EXIT WHEN v_ders_kod = v_ders_kod2;
        END LOOP;
        CLOSE cur_sections;
    END LOOP;
    CLOSE cur_selec_2017;
    DBMS_OUTPUT.PUT_LINE(v_count || ' retakes, ' || v_profit || ' tg.');
END;

BEGIN
    p_all_retakes_2016;
END;

--TASK 9
set SERVEROUTPUT on
DECLARE
    CURSOR cur_sub_cred IS
        SELECT ders_kod FROM course_selections_2016
            WHERE stud_id = '1BE62388007249890ADF37743AB9D9F27ADCD932' and year='2016' and term='1';
    CURSOR cur_sections_task9 IS 
        SELECT ders_kod, credits FROM course_sections 
            WHERE year='2016' and term='1';
    v_ders_kod          course_selections_2016.ders_kod%TYPE;
    v_ders_kod2         course_sections.ders_kod%TYPE;
    v_credits           course_sections.credits%TYPE;
    v_count_credits     course_sections.credits%TYPE;
    v_count_subj        NUMBER;
BEGIN 
    v_count_subj := 0;
    v_count_credits := 0;
    OPEN cur_sub_cred;
    LOOP
        FETCH cur_sub_cred INTO v_ders_kod;
        EXIT WHEN cur_sub_cred%NOTFOUND;
        OPEN cur_sections_task9;
        LOOP
            FETCH cur_sections_task9 INTO v_ders_kod2, v_credits;
            EXIT WHEN cur_sections_task9%NOTFOUND;
            IF v_ders_kod = v_ders_kod2
                THEN v_count_credits := v_count_credits+v_credits;
                EXIT;
            END IF;
        END LOOP;
        CLOSE cur_sections_task9;
        v_count_subj := v_count_subj + 1;
    END LOOP;
    CLOSE cur_sub_cred;
    DBMS_OUTPUT.PUT_LINE('This student select ' || v_count_subj || 's subjects and ' || v_count_credits || ' credits');
END;       
            
    




--Task 5
DECLARE 
    CURSOR cur_students IS
        SELECT ders_kod FROM course_selections_2016
            WHERE stud_id='1BE62388007249890ADF37743AB9D9F27ADCD932' and year='2016' and term='1';
    v_count     NUMBER;
    v_forstore  course_selections_2016.ders_kod%TYPE;
BEGIN 
    OPEN cur_students;
    LOOP
        FETCH cur_students INTO v_forstore;
        







