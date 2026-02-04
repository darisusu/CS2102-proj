# P01 — What To Do + Key Info

This README summarizes the P01 materials in this folder based on `P01.pdf` and the provided data/scripts.

## What P01 Is About (from `P01.pdf`)
P01 uses a Tour de France (2025) themed dataset. The PDF provides background on:
- The Tour de France as a multi‑stage race with a cumulative time winner (General Classification).
- Multiple classifications (General, Points, King of the Mountains, Young Rider).
- Teams of 8 riders, with a team leader and support roles.

The PDF in this folder appears to be a single-page background description (no explicit task list or grading rubric). If there is a longer version of the PDF, add it and I can extend this README.

## Files In This Folder
- `P01.pdf`: Background description of the Tour de France dataset/context.
- `P01-schema.sql`: PostgreSQL DDL for the database schema.
- `P01-data.sql`: Prebuilt INSERTs for countries, locations, teams, riders, stages, and results.
- `tdF-2025.csv`: Source dataset (stage results + denormalized attributes).
- `tdF-exits.csv`: Riders exiting the race (DNS/withdrawal) by stage.
- `csv_processor.py`: Example CSV processing script.

## Schema Summary (PostgreSQL)
Tables and key constraints:
- `country(ioc_code PK, name UNIQUE, region)`
- `location(name PK, country_code FK -> country)`
- `team(name PK, country_code FK -> country)`
- `rider(bib PK, team_name FK -> team, country_code FK -> country)`
- `stage(stage_number PK, day UNIQUE, start_location FK, finish_location FK, length, type)`
  - `type` constrained to: `flat`, `hilly`, `mountain`, `individual time-trial`, `team time-trial`
- `result(bib, stage_number PK, rank UNIQUE per stage, time, bonus, penalty)`
- `exit(bib PK, stage_number FK, reason CHECK in ('withdrawal','DNS'))`

## Dataset Facts (from `tdF-2025.csv`)
These are useful sanity checks:
- 21 stages.
- 182 riders.
- 23 teams.
- Stage types: `flat`, `hilly`, `mountain`, `individual time-trial`, `team time-trial`.

## What To Do (Practical Steps)
1. Create the schema in Postgres:
   - Run `P01-schema.sql`.
2. Load the provided data:
   - Run `P01-data.sql` to insert countries, locations, teams, riders, stages, and results.
3. Load exits:
   - `tdF-exits.csv` contains riders who exited (DNS/withdrawal).
   - `csv_processor.py` shows how to generate INSERTs from a CSV.
   - Important: `csv_processor.py` currently writes to `P01-data.sql` and would overwrite it. Change the output filename before running.
4. Validate constraints with the CSVs:
   - Ensure stage types match the `CHECK` constraint in `stage.type`.
   - Ensure every `result.rank` is unique per stage (the CSV appears to follow this).
   - Ensure `exit` records reference valid `rider.bib` and `stage.stage_number`.

## Notes / Gotchas
- `exit` data is not currently inserted in `P01-data.sql`.
- The provided `csv_processor.py` is an example and not wired to the full dataset; you will likely need to customize it if you want to regenerate all INSERTs from CSV.
- `P01-data.sql` already contains extensive inserts for `stage` and `result`. Regenerating them from CSV would overwrite or duplicate unless you reset the database.

## If You Have A Longer P01.pdf
If there is a multi‑page PDF with task instructions, add it here (or replace the current file). I will re‑extract and extend this README with the specific requirements and deliverables.
