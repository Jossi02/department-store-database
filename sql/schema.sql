CREATE TABLE 백화점 (
    지점이름 CHAR(4),
    시 VARCHAR2(20) NOT NULL,
    구 VARCHAR2(20),
    동 VARCHAR2(20) NOT NULL,
    CONSTRAINT 백화점_pk PRIMARY KEY (지점이름)
);

CREATE TABLE 매장 (
    매장코드 CHAR(8),
    매장이름 VARCHAR2(30) NOT NULL,
    매장전화번호 VARCHAR2(20) NOT NULL,
    시작시간 VARCHAR2(20) NOT NULL,
    종료시간 VARCHAR2(20) NOT NULL,
    지점이름 CHAR(4) NOT NULL,
    CONSTRAINT 매장_pk PRIMARY KEY (매장코드),
    CONSTRAINT 매장_코드_지점_uq UNIQUE (매장코드, 지점이름),
    CONSTRAINT 매장_백화점_fk FOREIGN KEY (지점이름)
        REFERENCES 백화점 (지점이름)
);

CREATE TABLE 직원 (
    직원코드 CHAR(8),
    이름 VARCHAR2(20) NOT NULL,
    시 VARCHAR2(20) NOT NULL,
    구 VARCHAR2(20),
    동 VARCHAR2(20) NOT NULL,
    지점이름 CHAR(4) NOT NULL,
    입사년 NUMBER(4) NOT NULL,
    입사월 NUMBER(2) NOT NULL,
    입사일 NUMBER(2) NOT NULL,
    매장코드 CHAR(8) NOT NULL,
    CONSTRAINT 직원_pk PRIMARY KEY (직원코드),
    CONSTRAINT 직원_매장_fk FOREIGN KEY (매장코드, 지점이름)
        REFERENCES 매장 (매장코드, 지점이름),
    CONSTRAINT 직원_입사월_ck CHECK (입사월 BETWEEN 1 AND 12),
    CONSTRAINT 직원_입사일_ck CHECK (입사일 BETWEEN 1 AND 31)
);

CREATE TABLE 고객 (
    고객번호 CHAR(8),
    이름 VARCHAR2(20) NOT NULL,
    시 VARCHAR2(20) NOT NULL,
    구 VARCHAR2(20) NOT NULL,
    동 VARCHAR2(20) NOT NULL,
    출생년 NUMBER(4) NOT NULL,
    출생월 NUMBER(2) NOT NULL,
    출생일 NUMBER(2) NOT NULL,
    지점이름 CHAR(4) NOT NULL,
    CONSTRAINT 고객_pk PRIMARY KEY (고객번호),
    CONSTRAINT 고객_백화점_fk FOREIGN KEY (지점이름)
        REFERENCES 백화점 (지점이름),
    CONSTRAINT 고객_출생월_ck CHECK (출생월 BETWEEN 1 AND 12),
    CONSTRAINT 고객_출생일_ck CHECK (출생일 BETWEEN 1 AND 31)
);

CREATE TABLE 멤버십 (
    고객번호 CHAR(8),
    카드번호 CHAR(8) NOT NULL,
    총구매금액 NUMBER(20) DEFAULT 0 NOT NULL,
    CONSTRAINT 멤버십_pk PRIMARY KEY (고객번호),
    CONSTRAINT 멤버십_카드_uq UNIQUE (카드번호),
    CONSTRAINT 멤버십_고객_fk FOREIGN KEY (고객번호)
        REFERENCES 고객 (고객번호),
    CONSTRAINT 멤버십_금액_ck CHECK (총구매금액 >= 0)
);

CREATE TABLE 결제 (
    결제번호 CHAR(8),
    결제금액 NUMBER(20) NOT NULL,
    결제방식 VARCHAR2(20) NOT NULL,
    결제시 NUMBER(2) NOT NULL,
    결제분 NUMBER(2) NOT NULL,
    카드번호 CHAR(8),
    CONSTRAINT 결제_pk PRIMARY KEY (결제번호),
    CONSTRAINT 결제_멤버십_fk FOREIGN KEY (카드번호)
        REFERENCES 멤버십 (카드번호),
    CONSTRAINT 결제_금액_ck CHECK (결제금액 >= 0),
    CONSTRAINT 결제_시_ck CHECK (결제시 BETWEEN 0 AND 23),
    CONSTRAINT 결제_분_ck CHECK (결제분 BETWEEN 0 AND 59)
);

CREATE TABLE 상품 (
    상품코드 CHAR(8),
    이름 VARCHAR2(20) NOT NULL,
    원가 NUMBER(10) NOT NULL,
    할인율 NUMBER(3, 2) DEFAULT 0 NOT NULL,
    가격 NUMBER(10),
    매장코드 CHAR(8) NOT NULL,
    CONSTRAINT 상품_pk PRIMARY KEY (상품코드),
    CONSTRAINT 상품_매장_fk FOREIGN KEY (매장코드)
        REFERENCES 매장 (매장코드),
    CONSTRAINT 상품_원가_ck CHECK (원가 >= 0),
    CONSTRAINT 상품_할인율_ck CHECK (할인율 BETWEEN 0 AND 1),
    CONSTRAINT 상품_가격_ck CHECK (가격 >= 0)
);

CREATE TABLE 구매 (
    고객번호 CHAR(8) NOT NULL,
    상품코드 CHAR(8) NOT NULL,
    결제번호 CHAR(8) NOT NULL,
    CONSTRAINT 구매_pk PRIMARY KEY (결제번호, 상품코드),
    CONSTRAINT 구매_고객_fk FOREIGN KEY (고객번호)
        REFERENCES 고객 (고객번호),
    CONSTRAINT 구매_상품_fk FOREIGN KEY (상품코드)
        REFERENCES 상품 (상품코드),
    CONSTRAINT 구매_결제_fk FOREIGN KEY (결제번호)
        REFERENCES 결제 (결제번호)
);

CREATE TABLE 예약 (
    예약번호 CHAR(8),
    고객번호 CHAR(8) NOT NULL,
    상품코드 CHAR(8) NOT NULL,
    수령일자 DATE NOT NULL,
    CONSTRAINT 예약_pk PRIMARY KEY (예약번호),
    CONSTRAINT 예약_중복_uq UNIQUE (고객번호, 상품코드, 수령일자),
    CONSTRAINT 예약_고객_fk FOREIGN KEY (고객번호)
        REFERENCES 고객 (고객번호),
    CONSTRAINT 예약_상품_fk FOREIGN KEY (상품코드)
        REFERENCES 상품 (상품코드)
);
