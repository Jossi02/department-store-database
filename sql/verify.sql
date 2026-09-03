SET SERVEROUTPUT ON;

DECLARE
    위반건수 NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO 위반건수
    FROM 구매 b
    LEFT JOIN 고객 c ON c.고객번호 = b.고객번호
    LEFT JOIN 상품 p ON p.상품코드 = b.상품코드
    LEFT JOIN 결제 pay ON pay.결제번호 = b.결제번호
    LEFT JOIN 멤버십 m ON m.카드번호 = pay.카드번호
    WHERE c.고객번호 IS NULL
       OR p.상품코드 IS NULL
       OR pay.결제번호 IS NULL
       OR (pay.카드번호 IS NOT NULL AND m.고객번호 <> b.고객번호);

    IF 위반건수 <> 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '구매·결제 참조 정합성 검증 실패');
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

    SELECT COUNT(*)
    INTO 위반건수
    FROM (
        SELECT pay.결제번호
        FROM 결제 pay
        JOIN 구매 b ON b.결제번호 = pay.결제번호
        JOIN 상품 p ON p.상품코드 = b.상품코드
        GROUP BY pay.결제번호, pay.결제금액
        HAVING pay.결제금액 <> SUM(p.가격)
    );

    IF 위반건수 <> 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '상품·결제 금액 정합성 검증 실패');
    END IF;

    SELECT COUNT(*)
    INTO 위반건수
    FROM 멤버십 m
    WHERE m.총구매금액 <> (
        SELECT NVL(SUM(pay.결제금액), 0)
        FROM 결제 pay
        WHERE pay.카드번호 = m.카드번호
    );

    IF 위반건수 <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '멤버십 누적 금액 검증 실패');
    END IF;

    DBMS_OUTPUT.PUT_LINE('검증 완료');
END;
/
