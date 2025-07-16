-- 試験・面接内容用テーブル作成スクリプト

-- 試験種別マスターテーブル
CREATE TABLE IF NOT EXISTS exam_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- 面接種別マスターテーブル
CREATE TABLE IF NOT EXISTS interview_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    interview_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- 試験・面接内容テーブル
CREATE TABLE IF NOT EXISTS interview_exam_content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    companys_id INT NOT NULL,
    content_type ENUM('試験', '面接') NOT NULL,
    content_number INT NOT NULL,  -- 企業IDごとの連番
    exam_type_id INT,             -- 試験種別ID（外部キー）
    exam_subject VARCHAR(100),    -- 試験科目
    exam_content VARCHAR(1000),   -- 試験内容詳細
    interview_type_id INT,        -- 面接種別ID（外部キー）
    interview_questions VARCHAR(1000), -- 面接質問内容
    interview_notes VARCHAR(1000),     -- 面接備考
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (companys_id) REFERENCES companys_tbl(companys_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_type_id) REFERENCES exam_types(id) ON DELETE SET NULL,
    FOREIGN KEY (interview_type_id) REFERENCES interview_types(id) ON DELETE SET NULL,
    UNIQUE KEY unique_company_content (companys_id, content_type, content_number)
);

-- サンプルデータの挿入

-- 試験種別データ
INSERT IGNORE INTO exam_types (exam_type_name) VALUES 
('筆記試験'),
('実技試験'),
('適性検査'),
('SPI'),
('Webテスト'),
('プログラミング試験'),
('英語試験'),
('その他');

-- 面接種別データ
INSERT IGNORE INTO interview_types (interview_type_name) VALUES 
('個人面接'),
('集団面接'),
('役員面接'),
('最終面接'),
('グループディスカッション'),
('プレゼンテーション'),
('その他');

