-- Enable unaccent extension for Vietnamese text search (if not already enabled)
-- CREATE EXTENSION IF NOT EXISTS unaccent;

-- Function to get popular networks based on user count
CREATE OR REPLACE FUNCTION get_popular_networks(limit_count INTEGER DEFAULT 10)
RETURNS TABLE(id BIGINT, name TEXT, category TEXT) 
LANGUAGE sql
AS $$
  SELECT 
    n.id,
    n.name,
    n.category
  FROM network n
  LEFT JOIN user_network un ON n.id = un.network_id
  GROUP BY n.id, n.name, n.category
  ORDER BY COUNT(un.user_id) DESC, n.name ASC
  LIMIT limit_count;
$$;

-- Function to search networks with Vietnamese diacritic handling
CREATE OR REPLACE FUNCTION search_networks_unaccent(search_term TEXT, result_limit INTEGER DEFAULT 20)
RETURNS TABLE(id BIGINT, name TEXT, category TEXT) 
LANGUAGE sql
AS $$
  SELECT 
    n.id,
    n.name,
    n.category
  FROM network n
  WHERE 
    -- Try both accented and unaccented matching for Vietnamese text
    (unaccent(LOWER(n.name)) ILIKE '%' || unaccent(LOWER(search_term)) || '%'
     OR LOWER(n.name) ILIKE '%' || LOWER(search_term) || '%')
  ORDER BY 
    -- Prioritize exact matches, then prefix matches, then contains
    CASE 
      WHEN LOWER(n.name) = LOWER(search_term) THEN 1
      WHEN LOWER(n.name) LIKE LOWER(search_term) || '%' THEN 2
      WHEN unaccent(LOWER(n.name)) LIKE unaccent(LOWER(search_term)) || '%' THEN 3
      ELSE 4
    END,
    n.name
  LIMIT result_limit;
$$;

-- Create indexes for better performance

-- Full-text search indexes for both English and simple (Vietnamese-friendly)
CREATE INDEX IF NOT EXISTS network_name_fts_english_idx 
ON network 
USING gin(to_tsvector('english', name));

CREATE INDEX IF NOT EXISTS network_name_fts_simple_idx 
ON network 
USING gin(to_tsvector('simple', name));

-- Unaccent index for Vietnamese diacritic search (if unaccent is available)
-- CREATE INDEX IF NOT EXISTS network_name_unaccent_idx 
-- ON network (unaccent(LOWER(name)) text_pattern_ops);

-- Standard partial index for ILIKE searches (fallback)
CREATE INDEX IF NOT EXISTS network_name_partial_idx 
ON network (name text_pattern_ops);

-- Lowercase index for case-insensitive searches
CREATE INDEX IF NOT EXISTS network_name_lower_idx 
ON network (LOWER(name) text_pattern_ops);