USE pmo_project;
CREATE TABLE translators (
    translator_id INT PRIMARY KEY AUTO_INCREMENT,
    translator_name VARCHAR(150) NOT NULL,
    source_language VARCHAR(50) NOT NULL,
    target_language VARCHAR(50) NOT NULL,
    skills VARCHAR(255),
    rate_per_word DECIMAL(6,3),
    availability VARCHAR(20) DEFAULT 'Available',
    rating DECIMAL(2,1)
);