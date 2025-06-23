-- Alternative functions without unaccent extension dependency
-- Use this if unaccent extension is not available in your PostgreSQL setup

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

-- Simple search function without unaccent (fallback for Vietnamese)
CREATE OR REPLACE FUNCTION search_networks_simple(search_term TEXT, result_limit INTEGER DEFAULT 20)
RETURNS TABLE(id BIGINT, name TEXT, category TEXT) 
LANGUAGE sql
AS $$
  SELECT 
    n.id,
    n.name,
    n.category
  FROM network n
  WHERE 
    LOWER(n.name) ILIKE '%' || LOWER(search_term) || '%'
  ORDER BY 
    -- Prioritize exact matches, then prefix matches, then contains
    CASE 
      WHEN LOWER(n.name) = LOWER(search_term) THEN 1
      WHEN LOWER(n.name) LIKE LOWER(search_term) || '%' THEN 2
      ELSE 3
    END,
    n.name
  LIMIT result_limit;
$$;

-- Create basic indexes for performance
CREATE INDEX IF NOT EXISTS network_name_fts_simple_idx 
ON network 
USING gin(to_tsvector('simple', name));

CREATE INDEX IF NOT EXISTS network_name_lower_idx 
ON network (LOWER(name) text_pattern_ops);

CREATE INDEX IF NOT EXISTS network_name_partial_idx 
ON network (name text_pattern_ops);