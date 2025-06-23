# Vietnamese Text Search Implementation

## Overview

The network search has been optimized to handle both Vietnamese and English text with multiple fallback strategies for maximum compatibility.

## Search Strategy Hierarchy

### 1. Full-Text Search (Primary)
- **Vietnamese**: Uses PostgreSQL `simple` config (better for non-English text)
- **English**: Uses PostgreSQL `english` config (with stemming and stop words)

### 2. Unaccent Search (Fallback 1)
- Handles Vietnamese diacritics (á, à, ả, ã, ạ → a)
- Requires `unaccent` PostgreSQL extension
- Function: `search_networks_unaccent()`

### 3. Simple Function Search (Fallback 2)
- Case-insensitive ILIKE with intelligent ranking
- Works without any extensions
- Function: `search_networks_simple()`

### 4. Basic ILIKE (Final Fallback)
- Direct table query with basic pattern matching
- Always works as last resort

## Database Setup

### Option A: With unaccent extension (Recommended)
```sql
-- Enable unaccent extension
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Run the main functions file
\i schema/network_functions.sql
```

### Option B: Without unaccent extension
```sql
-- Run the simple functions file
\i schema/network_functions_simple.sql
```

## Search Features

### Vietnamese Text Handling
- **Diacritic normalization**: "Đại học" matches "dai hoc"
- **Case insensitive**: "HANOI" matches "Hà Nội"
- **Partial matching**: "bách" matches "Đại học Bách khoa"

### Search Ranking
1. **Exact matches**: Highest priority
2. **Prefix matches**: Second priority  
3. **Contains matches**: Third priority
4. **Alphabetical**: Final sort order

### Performance Features
- **20 result limit**: Prevents large responses
- **2 character minimum**: Reduces noise
- **300ms debouncing**: Reduces API calls
- **Multiple indexes**: Optimized for different search types

## Example Searches

| Vietnamese Input | Matches |
|------------------|---------|
| "bách khoa" | "Đại học Bách khoa Hà Nội" |
| "dai hoc" | "Đại học Kinh tế Quốc dân" |
| "FPT" | "Đại học FPT", "FPT Software" |
| "hanoi" | "Trường Đại học Hà Nội" |

## Error Handling

The implementation gracefully degrades through multiple fallback levels:

1. If Vietnamese FTS fails → Try English FTS
2. If English FTS fails → Try unaccent function
3. If unaccent fails → Try simple function  
4. If simple fails → Use basic ILIKE
5. If all fail → Return empty array

This ensures search always works regardless of database configuration.