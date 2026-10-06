USE pmo_project;
-- Find available translators for a language pair (change 'German' to search another language)
SELECT
    translator_id,
    translator_name,
    source_language,
    target_language,
    skills,
    rate_per_word,
    rating
FROM translators
WHERE source_language = 'English'
  AND target_language = 'German'
  AND availability = 'Available'
ORDER BY rating DESC, rate_per_word ASC;