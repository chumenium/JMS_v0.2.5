-- Filess.io用 JMS データベースセットアップスクリプト
-- 注意: drop database は使用しない（無料プランでは制限があるため）

-- メインテーブル作成
CREATE TABLE IF NOT EXISTS occupations_tbl (
    occupation_id INT AUTO_INCREMENT PRIMARY KEY,
    occupation VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS companys_tbl (
    companys_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(50),
    post_code VARCHAR(10),
    address VARCHAR(100),
    tel VARCHAR(15),
    mail_address VARCHAR(30),
    manager_name VARCHAR(20),
    recruitment_results boolean
);

CREATE TABLE IF NOT EXISTS selection_tbl (
    selection_id INT AUTO_INCREMENT PRIMARY KEY,
    selection_name VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(8) PRIMARY KEY,
    password VARCHAR(255),
    role ENUM('student','teacher','headmaster','egd','admin'),
    salt VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS teacher_tbl(
    teacher_id CHAR(8) PRIMARY KEY,
    name VARCHAR(20),
    FOREIGN KEY (teacher_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS students_tbl (
    student_id VARCHAR(8) PRIMARY KEY,
    department VARCHAR(3),
    class VARCHAR(3),
    number VARCHAR(3),
    name VARCHAR(20),
    name_reading VARCHAR(40),
    gender ENUM('男','女'),
    email VARCHAR(50),
    tel VARCHAR(50),
    enrollment_status ENUM('在籍','退学','休学','卒業'),
    mediation_status ENUM('受理','辞退'),
    job_hunting_status ENUM('未開始','準備中','活動中','内定済み','就職決定','就職辞退'),
    desired_job_type_1st_id INT,
    desired_job_type_2nd_id INT,
    desired_job_type_3rd_id INT,
    graduation_year INT,
    remarks VARCHAR(500),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (desired_job_type_1st_id) REFERENCES occupations_tbl(occupation_id),
    FOREIGN KEY (desired_job_type_2nd_id) REFERENCES occupations_tbl(occupation_id),
    FOREIGN KEY (desired_job_type_3rd_id) REFERENCES occupations_tbl(occupation_id)
);

CREATE TABLE IF NOT EXISTS job_activity_tbl (
    student_id VARCHAR(8),
    companys_id INT,
    activity_status ENUM('検討中','エントリー中','選考中','内定承諾','内定保留','内定辞退','不採用','選考中止'),
    reporte_date DATE,
    PRIMARY KEY (student_id, companys_id),
    FOREIGN KEY (student_id) REFERENCES students_tbl(student_id),
    FOREIGN KEY (companys_id) REFERENCES companys_tbl(companys_id)
);

CREATE TABLE IF NOT EXISTS job_activity_detail_tbl (
    student_id VARCHAR(8),
    companys_id INT,
    selection_id INT,
    date DATE,
    time TIME,
    venue VARCHAR(30),
    remarks VARCHAR(200),
    PRIMARY KEY (student_id, companys_id, selection_id),
    FOREIGN KEY (student_id) REFERENCES students_tbl(student_id),
    FOREIGN KEY (companys_id) REFERENCES companys_tbl(companys_id),
    FOREIGN KEY (selection_id) REFERENCES selection_tbl(selection_id)
);

CREATE TABLE IF NOT EXISTS work_place_tbl (
    id INT AUTO_INCREMENT PRIMARY KEY,
    work_place VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS students_work_place_tbl (
    student_id CHAR(8),
    work_place_id INT,
    PRIMARY KEY (student_id, work_place_id),
    FOREIGN KEY (work_place_id) REFERENCES work_place_tbl(id),
    FOREIGN KEY (student_id) REFERENCES students_tbl(student_id)
);

CREATE TABLE IF NOT EXISTS company_work_place_tbl (
    companys_id INT,
    work_place_id INT,
    PRIMARY KEY (companys_id, work_place_id),
    FOREIGN KEY (work_place_id) REFERENCES work_place_tbl(id),
    FOREIGN KEY (companys_id) REFERENCES companys_tbl(companys_id)
);

CREATE TABLE IF NOT EXISTS company_occupation_tbl (
    companys_id INT,
    occupation_id INT,
    PRIMARY KEY (companys_id, occupation_id),
    FOREIGN KEY (occupation_id) REFERENCES occupations_tbl(occupation_id),
    FOREIGN KEY (companys_id) REFERENCES companys_tbl(companys_id)
);

-- プルダウン用テーブル
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS enrollment_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS assistance_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assistance_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS industries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    industry_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 基本データ挿入
INSERT IGNORE INTO occupations_tbl(occupation) VALUES
("システムエンジニア"),
("プログラマー"),
("インフラエンジニア"),
("システム運用保守"),
("ITコンサルタント"),
("ゲームクリエイター"),
("WEBデザイナー"),
("フロントエンドエンジニア"),
("バックエンドエンジニア"),
("組込開発エンジニア"),
("販売・営業"),
("事務職");

INSERT IGNORE INTO occupations_tbl(occupation_id, occupation) VALUES(0, "未設定");

INSERT IGNORE INTO work_place_tbl(work_place) VALUES
("北海道"),("青森県"),("岩手県"),("宮城県"),("秋田県"),("山形県"),("福島県"),
("茨城県"),("栃木県"),("群馬県"),("埼玉県"),("千葉県"),("東京都"),("神奈川県"),
("新潟県"),("富山県"),("石川県"),("福井県"),("山梨県"),("長野県"),("岐阜県"),
("静岡県"),("愛知県"),("三重県"),("滋賀県"),("京都府"),("大阪府"),("兵庫県"),
("奈良県"),("和歌山県"),("鳥取県"),("島根県"),("岡山県"),("広島県"),("山口県"),
("徳島県"),("香川県"),("愛媛県"),("高知県"),("福岡県"),("佐賀県"),("長崎県"),
("熊本県"),("大分県"),("宮崎県"),("鹿児島県"),("沖縄県"),("海外"),("その他");

INSERT IGNORE INTO selection_tbl(selection_name) VALUES
("書類選考"),("筆記試験"),("一次面接"),("二次面接"),("最終面接"),("内定");

-- プルダウン用データ
INSERT IGNORE INTO classes (class_name) VALUES 
('S3A1'),('S3A2'),('S3B1'),('S3B2'),('S2A1'),('S2A2'),('S2B1'),('S2B2');

INSERT IGNORE INTO enrollment_status (status_name) VALUES 
('在籍'),('休学'),('卒業'),('退学'),('除籍');

INSERT IGNORE INTO assistance_types (assistance_name) VALUES 
('学校斡旋'),('自己応募'),('エージェント'),('紹介'),('その他');

INSERT IGNORE INTO industries (industry_name) VALUES 
('IT・ソフトウェア'),('通信・インターネット'),('製造業'),('金融・保険'),
('建設・不動産'),('小売・流通'),('医療・福祉'),('教育'),('公務員'),('その他');

-- 管理者ユーザー作成（パスワードはハッシュ化済み）
INSERT IGNORE INTO users (id, password, role, salt) VALUES 
('admin001', 'hashed_password_here', 'admin', 'salt_here');

-- 完了メッセージ
SELECT 'Database setup completed successfully!' as message; 