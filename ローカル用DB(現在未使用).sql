-- プルダウン用データベーステーブル作成スクリプト

-- クラステーブル
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 在籍状況テーブル
CREATE TABLE IF NOT EXISTS enrollment_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 斡旋タイプテーブル
CREATE TABLE IF NOT EXISTS assistance_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assistance_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 業種テーブル
CREATE TABLE IF NOT EXISTS industries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    industry_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- サンプルデータの挿入

-- クラスデータ
INSERT IGNORE INTO classes (class_name) VALUES 
('S3A1'),
('S3A2'),
('S3B1'),
('S3B2'),
('S2A1'),
('S2A2'),
('S2B1'),
('S2B2');

-- 在籍状況データ
INSERT IGNORE INTO enrollment_status (status_name) VALUES 
('在籍'),
('休学'),
('卒業'),
('退学'),
('除籍');

-- 斡旋データ
INSERT IGNORE INTO assistance_types (assistance_name) VALUES 
('学校斡旋'),
('自己応募'),
('エージェント'),
('紹介'),
('その他');

-- 業種データ
INSERT IGNORE INTO industries (industry_name) VALUES 
('IT・ソフトウェア'),
('通信・インターネット'),
('製造業'),
('金融・保険'),
('建設・不動産'),
('小売・流通'),
('医療・福祉'),
('教育'),
('公務員'),
('その他');

-- 学生テーブル（卒業年を取得するため）
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    name_kana VARCHAR(100),
    class_id INT,
    class_number INT,
    enrollment_status_id INT,
    gender VARCHAR(10),
    assistance_id INT,
    first_choice_industry_id INT,
    graduation_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (enrollment_status_id) REFERENCES enrollment_status(id),
    FOREIGN KEY (assistance_id) REFERENCES assistance_types(id),
    FOREIGN KEY (first_choice_industry_id) REFERENCES industries(id)
);

-- サンプル学生データ（卒業年データのため）
INSERT IGNORE INTO students (student_id, name, name_kana, graduation_year) VALUES 
('2023001', '山田太郎', 'ヤマダタロウ', 2025),
('2023002', '佐藤花子', 'サトウハナコ', 2025),
('2023003', '田中次郎', 'タナカジロウ', 2024),
('2023004', '鈴木美咲', 'スズキミサキ', 2026),
('2023005', '高橋健一', 'タカハシケンイチ', 2025); 

mysql> show tables;
+-------------------------+
| Tables_in_jms_essential |
+-------------------------+
| company_occupation_tbl  |
| company_work_place_tbl  |
| companys_tbl            |
| exam_types              |
| interview_exam_content  |
| interview_types         |
| job_activity_detail_tbl |
| job_activity_tbl        |
| occupations_tbl         |
| selection_tbl           |
| students_tbl            |
| students_work_place_tbl |
| teacher_tbl             |
| users                   |
| work_place_tbl          |
+-------------------------+

mysql> SHOW FIELDS FROM company_occupation_tbl;
+---------------+------+------+-----+---------+-------+
| Field         | Type | Null | Key | Default | Extra |
+---------------+------+------+-----+---------+-------+
| companys_id   | int  | NO   | PRI | NULL    |       |
| occupation_id | int  | NO   | PRI | NULL    |       |
+---------------+------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM company_work_place_tbl;
+---------------+------+------+-----+---------+-------+
| Field         | Type | Null | Key | Default | Extra |
+---------------+------+------+-----+---------+-------+
| companys_id   | int  | NO   | PRI | NULL    |       |
| work_place_id | int  | NO   | PRI | NULL    |       |
+---------------+------+------+-----+---------+-------+

mysql> show fields from companys_tbl;
+---------------------+--------------+------+-----+---------+----------------+
| Field               | Type         | Null | Key | Default | Extra          |
+---------------------+--------------+------+-----+---------+----------------+
| companys_id         | int          | NO   | PRI | NULL    | auto_increment |
| company_name        | varchar(50)  | YES  |     | NULL    |                |
| post_code           | varchar(10)  | YES  |     |         |                |
| address             | varchar(100) | YES  |     |         |                |
| tel                 | varchar(15)  | YES  |     |         |                |
| mail_address        | varchar(30)  | YES  |     |         |                |
| manager_name        | varchar(20)  | YES  |     |         |                |
| recruitment_results | tinyint(1)   | YES  |     | NULL    |                |
+---------------------+--------------+------+-----+---------+----------------+

mysql> SHOW FIELDS FROM job_activity_detail_tbl;
+--------------+--------------+------+-----+---------+-------+
| Field        | Type         | Null | Key | Default | Extra |
+--------------+--------------+------+-----+---------+-------+
| student_id   | varchar(8)   | NO   | PRI | NULL    |       |
| companys_id  | int          | NO   | PRI | NULL    |       |
| selection_id | int          | NO   | PRI | NULL    |       |
| date         | date         | YES  |     | NULL    |       |
| time         | time         | YES  |     | NULL    |       |
| venue        | varchar(30)  | YES  |     | NULL    |       |
| remarks      | varchar(200) | YES  |     | NULL    |       |
+--------------+--------------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM job_activity_tbl;
+-----------------+---------------------------------------------------------------------------------------------+------+-----+---------+-------+
| Field           | Type                                                                                        | Null | Key | Default | Extra |
+-----------------+---------------------------------------------------------------------------------------------+------+-----+---------+-------+
| student_id      | varchar(8)                                                                                  | NO   | PRI | NULL    |       |
| companys_id     | int                                                                                         | NO   | PRI | NULL    |       |
| activity_status | enum('検討中','エントリー中','選考中','内定承諾','内定保留','内定辞退','不採用','選考中止') | YES  |     | NULL    |       |
| reporte_date    | date                                                                                        | YES  |     | NULL    |       |
+-----------------+---------------------------------------------------------------------------------------------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM occupations_tbl;
+---------------+-------------+------+-----+---------+----------------+
| Field         | Type        | Null | Key | Default | Extra          |
+---------------+-------------+------+-----+---------+----------------+
| occupation_id | int         | NO   | PRI | NULL    | auto_increment |
| occupation    | varchar(25) | YES  |     | NULL    |                |
+---------------+-------------+------+-----+---------+----------------+

mysql> SHOW FIELDS FROM selection_tbl;
+----------------+-------------+------+-----+---------+----------------+
| Field          | Type        | Null | Key | Default | Extra          |
+----------------+-------------+------+-----+---------+----------------+
| selection_id   | int         | NO   | PRI | NULL    | auto_increment |
| selection_name | varchar(20) | YES  |     | NULL    |                |
+----------------+-------------+------+-----+---------+----------------+

mysql> SHOW FIELDS FROM students_tbl;
+-------------------------+-------------------------------------------------------------------+------+-----+---------+-------+
| Field                   | Type                                                              | Null | Key | Default | Extra |
+-------------------------+-------------------------------------------------------------------+------+-----+---------+-------+
| student_id              | varchar(8)                                                        | NO   | PRI | NULL    |       |
| department              | varchar(3)                                                        | YES  |     | NULL    |       |
| class                   | varchar(3)                                                        | YES  |     | NULL    |       |
| number                  | varchar(3)                                                        | YES  |     | NULL    |       |
| name                    | varchar(20)                                                       | YES  |     | NULL    |       |
| name_reading            | varchar(40)                                                       | YES  |     | NULL    |       |
| gender                  | enum('男','女')                                                   | YES  |     | NULL    |       |
| email                   | varchar(50)                                                       | YES  |     |         |       |
| tel                     | varchar(50)                                                       | YES  |     |         |       |
| enrollment_status       | enum('在籍','退学','休学','卒業')                                 | YES  |     | NULL    |       |
| mediation_status        | enum('受理','辞退')                                               | YES  |     | NULL    |       |
| job_hunting_status      | enum('未開始','準備中','活動中','内定済み','就職決定','就職辞退') | YES  |     | NULL    |       |
| desired_job_type_1st_id | int                                                               | YES  | MUL | NULL    |       |
| desired_job_type_2nd_id | int                                                               | YES  | MUL | NULL    |       |
| desired_job_type_3rd_id | int                                                               | YES  | MUL | NULL    |       |
| graduation_year         | int                                                               | YES  |     | NULL    |       |
| remarks                 | varchar(500)                                                      | YES  |     |         |       |
+-------------------------+-------------------------------------------------------------------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM students_work_place_tbl;
+---------------+---------+------+-----+---------+-------+
| Field         | Type    | Null | Key | Default | Extra |
+---------------+---------+------+-----+---------+-------+
| student_id    | char(8) | NO   | PRI | NULL    |       |
| work_place_id | int     | NO   | PRI | NULL    |       |
+---------------+---------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM teacher_tbl;
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| teacher_id | char(8)     | NO   | PRI | NULL    |       |
| name       | varchar(20) | YES  |     | NULL    |       |
+------------+-------------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM users;
+----------+------------------------------------------------------+------+-----+---------+-------+
| Field    | Type                                                 | Null | Key | Default | Extra |
+----------+------------------------------------------------------+------+-----+---------+-------+
| id       | varchar(8)                                           | NO   | PRI | NULL    |       |
| password | varchar(255)                                         | YES  |     | NULL    |       |
| role     | enum('student','teacher','headmaster','egd','admin') | YES  |     | NULL    |       |
| salt     | varchar(255)                                         | YES  |     | NULL    |       |
+----------+------------------------------------------------------+------+-----+---------+-------+

mysql> SHOW FIELDS FROM work_place_tbl;
+------------+-------------+------+-----+---------+----------------+
| Field      | Type        | Null | Key | Default | Extra          |
+------------+-------------+------+-----+---------+----------------+
| id         | int         | NO   | PRI | NULL    | auto_increment |
| work_place | varchar(15) | YES  |     | NULL    |                |
+------------+-------------+------+-----+---------+----------------+

mysql> show fields from exam_types;
+----------------+-------------+------+-----+---------+----------------+
| Field          | Type        | Null | Key | Default | Extra          |
+----------------+-------------+------+-----+---------+----------------+
| id             | int         | NO   | PRI | NULL    | auto_increment |
| exam_type_name | varchar(50) | NO   | UNI | NULL    |                |
+----------------+-------------+------+-----+---------+----------------+

mysql> show fields from interview_types;
+---------------------+-------------+------+-----+---------+----------------+
| Field               | Type        | Null | Key | Default | Extra          |
+---------------------+-------------+------+-----+---------+----------------+
| id                  | int         | NO   | PRI | NULL    | auto_increment |
| interview_type_name | varchar(50) | NO   | UNI | NULL    |                |
+---------------------+-------------+------+-----+---------+----------------+

mysql> show fields from interview_exam_content;
+---------------------+---------------------+------+-----+-------------------+-----------------------------------------------+
| Field               | Type                | Null | Key | Default           | Extra                                         |
+---------------------+---------------------+------+-----+-------------------+-----------------------------------------------+
| id                  | int                 | NO   | PRI | NULL              | auto_increment                                |
| companys_id         | int                 | NO   | MUL | NULL              |                                               |
| content_type        | enum('試験','面接') | NO   |     | NULL              |                                               |
| content_number      | int                 | NO   |     | NULL              |                                               |
| exam_type_id        | int                 | YES  | MUL | NULL              |                                               |
| exam_subject        | varchar(100)        | YES  |     | NULL              |                                               |
| exam_content        | varchar(1000)       | YES  |     | NULL              |                                               |
| interview_type_id   | int                 | YES  | MUL | NULL              |                                               |
| interview_questions | varchar(1000)       | YES  |     | NULL              |                                               |
| interview_notes     | varchar(1000)       | YES  |     | NULL              |                                               |
| created_at          | timestamp           | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at          | timestamp           | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
+---------------------+---------------------+------+-----+-------------------+-----------------------------------------------+


