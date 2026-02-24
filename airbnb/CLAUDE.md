# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A dbt project analyzing Airbnb listings, hosts, and reviews on Snowflake. The primary analytical focus is temporal patterns (full moon impact on reviews).

## Common Commands

```bash
# Install/update packages
dbt deps

# Run all models
dbt run

# Run a specific model and its dependencies
dbt run --select +fct_airbnb__reviews

# Run tests
dbt test

# Run tests for a specific model
dbt test --select dim_airbnb__listings

# Run unit tests only
dbt test --select unit_test__full_moon_matcher

# Load seed data
dbt seed

# Run snapshots
dbt snapshot

# Build (seed + run + test in dependency order)
dbt build

# Generate and serve documentation
dbt docs generate
dbt docs serve

# Check source freshness
dbt source freshness

# Clean build artifacts
dbt clean
```

## Architecture

Data flows through three layers:

```
Snowflake RAW schema (raw_listings, raw_hosts, raw_reviews)
    ↓
Staging (ephemeral) → stg_airbnb__listings, stg_airbnb__hosts, stg_airbnb__reviews
    ↓
Intermediate (tables) → dim_airbnb__listings, dim_airbnb__hosts, dim__listings_w_hosts
                       → fct_airbnb__reviews (incremental)
    ↓
Mart (tables) → mart__full_moon_reviews (joined with seed_full_moon_dates)
```

- **Staging models** are `ephemeral` — they compile to CTEs, not database objects
- **Intermediate and mart models** materialize as `table`
- **`fct_airbnb__reviews`** uses `incremental` materialization, filtering on `review_date`
- **`dim_airbnb__hosts`** has a dbt contract enforced (column names and data types locked)

## Snapshots (SCD Type 2)

`scd_raw_listings` and `scd_raw_hosts` track historical changes using `timestamp` strategy with `hard_deletes: invalidate`.

## Testing Structure

- **Generic tests** live in `tests/generic/` — `min_row_count` and `positive_values`
- **Singular tests** live in `tests/` — `consistent_created_at` and `dim_airbnb__listings_minimum_nights`
- **Unit tests** live in `models/mart/unit_test.yml` — tests the full moon date join logic
- Schema tests (unique, not_null, relationships, accepted_values) are defined in `models/schema.yml`

## Key Conventions

- Model naming: `<layer>_airbnb__<entity>` (e.g., `stg_airbnb__listings`, `dim_airbnb__hosts`)
- Macros: `no_empty_strings(model)` generates dynamic WHERE clauses for all string columns; `select_positive_values(model, column_name)` filters for positive values
- The `dbt_utils.generate_surrogate_key()` macro (from `dbt-labs/dbt_utils` v1.3.3) is used in `fct_airbnb__reviews` to generate `review_id`
- Documentation blocks are defined in `models/docs.md` and referenced in `schema.yml`

## Database Connection

Snowflake via private key authentication (`~/dbt_rsa_key_pkcs8.pem`). Connection profile is in `profiles.yml`:
- Account: `ICQGBLU-NG13937`, Database: `AIRBNB`, Dev schema: `DEV`
- Role: `TRANSFORM`, Warehouse: `COMPUTE_WH`
