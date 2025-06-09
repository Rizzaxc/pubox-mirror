# pubox

Next gen casual sport portal

## Stack
DB: Postgres/ Supabase
Frontend: Flutter
Complex operations are done at SQL functions and called using Supabase

## Flow
User will choose a "context sport" (frontend variable). The app will help them
find teammates, parties ("lobby"), organize play, hire coaches/ referees etc

4 Main Tabs:
- Home: split into 4 subtabs
  - Teammates: find people/ lobbies to play with
  - Challengers: put up your lobby for challengers or look for them
  - Neutrals: hire coaches, referees, etc for your sport
  - Locations: find available venues according to criteria
- Manage:
  - the user's schedule
  - their lobbies' activities: view, accept/ reject play invite, split bill, inspect history etc
- Health: integrate with user's wearables
  - capture data during activities
  - gamify and encourage further interactions (goals/ achievements etc)
- Profile:
  - general account bookkeeping
  - misc info/ preference on any particular sport: skill level, fitness level, play position
  - their consistent schedule for matchmaking
  - network and industry: allow user to choose from preset choices and improve matchmaking

## Coding Guidelines
- Organize code by their screen
- If a feature involves multiple screens, make a folder in each screen
- Generic, omni-present features or models go into /core
- Avoid nesting, prefer a flat folder structure
- Use Provider for state management, but use StatefulWidgets for ephemeral states
- Use SharedPreferences to persist important app states
- Use PlatformWidgets whenever possible
- Use Vietnamese for UI/ messages but do not translate jargon

## Internationalization
The app supports both English and Vietnamese languages. Translations are stored in JSON files in the `lib/l10n` directory:

- `en.json` - English translations
- `vi.json` - Vietnamese translations
- `industries_en.json` - English industry names
- `industries_vi.json` - Vietnamese industry names

### Adding or Updating Industry Translations
To add or update industry translations, edit the `industries_vi.json` file. The file structure is:

```json
{
  "industries": {
    "English Industry Name": "Vietnamese Translation",
    "Technology": "Công nghệ",
    "Healthcare": "Y tế"
  }
}
```

Make sure to keep the English industry names as keys exactly as they appear in the database, and provide the Vietnamese translations as values.
