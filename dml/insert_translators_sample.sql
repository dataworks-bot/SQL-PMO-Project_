USE pmo_project;
-- Sample data for demonstration only (fictional translators)
INSERT INTO translators
(translator_name, source_language, target_language, skills, rate_per_word, availability, rating)
VALUES
('Translator A', 'English', 'German', 'Legal, Technical', 0.080, 'Available', 4.8),
('Translator B', 'English', 'French', 'Marketing, Medical', 0.090, 'Busy', 4.5),
('Translator C', 'English', 'Kannada', 'General, Website', 0.040, 'Available', 4.6),
('Translator D', 'English', 'Spanish', 'Software, Marketing', 0.070, 'Available', 4.2),
('Translator E', 'English', 'German', 'Medical, Technical', 0.085, 'Busy', 4.9),
('Translator F', 'English', 'Hindi', 'General, Legal', 0.035, 'Available', 4.4);