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