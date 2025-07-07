-- 企業詳細画面テスト用のサンプルデータ

-- 勤務地テーブル
CREATE TABLE IF NOT EXISTS work_places_tbl (
    work_place_id INT AUTO_INCREMENT PRIMARY KEY,
    work_place_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 職種テーブル
CREATE TABLE IF NOT EXISTS occupations_tbl (
    occupation_id INT AUTO_INCREMENT PRIMARY KEY,
    occupation VARCHAR(100) NOT NULL,
    industry_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 企業テーブル
CREATE TABLE IF NOT EXISTS companies_tbl (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    post_code VARCHAR(10),
    address TEXT,
    tel VARCHAR(20),
    mail_address VARCHAR(100),
    manager_name VARCHAR(100),
    recruitment_results BOOLEAN DEFAULT FALSE,
    work_place_id INT,
    occupation_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (work_place_id) REFERENCES work_places_tbl(work_place_id),
    FOREIGN KEY (occupation_id) REFERENCES occupations_tbl(occupation_id)
);

-- 勤務地データ
INSERT IGNORE INTO work_places_tbl (work_place_name) VALUES 
('東京都'),
('大阪府'),
('愛知県'),
('神奈川県'),
('埼玉県'),
('千葉県'),
('福岡県'),
('北海道'),
('宮城県'),
('広島県'),
('その他');

-- 職種データ
INSERT IGNORE INTO occupations_tbl (occupation, industry_name) VALUES 
('プログラマー', 'IT・ソフトウェア'),
('システムエンジニア', 'IT・ソフトウェア'),
('Webデザイナー', 'IT・ソフトウェア'),
('営業', '営業・販売'),
('事務', '事務・管理'),
('製造技術', '製造業'),
('品質管理', '製造業'),
('経理', '事務・管理'),
('人事', '事務・管理'),
('マーケティング', '企画・マーケティング'),
('その他', 'その他');

-- サンプル企業データ
INSERT IGNORE INTO companies_tbl (company_name, post_code, address, tel, mail_address, manager_name, recruitment_results, work_place_id, occupation_id) VALUES 
('株式会社テックソリューション', '100-0001', '東京都千代田区千代田1-1-1', '03-1234-5678', 'info@techsolution.co.jp', '田中一郎', TRUE, 1, 1),
('サンプル製造株式会社', '530-0001', '大阪府大阪市北区梅田1-1-1', '06-1234-5678', 'contact@sample-mfg.co.jp', '佐藤花子', TRUE, 2, 6),
('グローバル商事株式会社', '460-0001', '愛知県名古屋市中区錦1-1-1', '052-123-4567', 'hr@global-trading.co.jp', '鈴木太郎', FALSE, 3, 4),
('デジタルクリエイト株式会社', '220-0001', '神奈川県横浜市西区みなとみらい1-1-1', '045-123-4567', 'recruit@digital-create.co.jp', '高橋美咲', TRUE, 4, 3),
('フューチャーシステムズ株式会社', '330-0001', '埼玉県さいたま市大宮区大宮1-1-1', '048-123-4567', 'jobs@future-systems.co.jp', '山田健一', FALSE, 5, 2); 