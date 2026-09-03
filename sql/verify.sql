DECLARE
    위반건수 NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO 위반건수
    FROM 구매 b
    LEFT JOIN 고객 c ON c.고객번호 = b.고객번호
    LEFT JOIN 상품 p ON p.상품코드 = b.상품코드
    LEFT JOIN 결제 pay ON pay.결제번호 = b.결제번호
    WHERE c.고객번호 IS NULL
       OR p.상품코드 IS NULL
       OR pay.결제번호 IS NULL;

    IF 위반건수 <> 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '구매 참조 무결성 검증 실패');
    END IF;

    SELECT COUNT(*)
    INTO 위반건수
    FROM (
        SELECT 고객번호, 상품코드
        FROM 구매
        GROUP BY 고객번호, 상품코드
        HAVING COUNT(*) > 1
    );

    IF 위반건수 = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '반복 구매 예제 검증 실패');
    END IF;

    DBMS_OUTPUT.PUT_LINE('검증 완료');
END;
/
