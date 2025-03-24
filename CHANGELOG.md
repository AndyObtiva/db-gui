# Change Log

## 0.1.1

- Automatically extend DB command timeout after timing out by retrying 6 times (7 times total) with exponential timeout increases
- Avoid DB command timeout if DB result row count is received
- Show error when DB command fails

## 0.1.0

- Remember last DB command
- Move saved configuration from ~/.db_gui as a file to ~/.db_gui as a directory with multiple files underneath: ~/.db_gui/.db_configs & ~/.db_gui/.db_commands

## 0.0.4

- Make SQL command entry a non_wrapping_multiline_entry

## 0.0.3

- Show count of rows produced by a DB command result
- Terminate DB commands (SQL statements) with a semi-colon for convenience if they did not have a semi-colon already (to avoid having them fail)
- Increase max timeout to 60*60*1000 (1 hour)

## 0.0.2

- Support displaying DB command results in a table instead of a non_wrapping_multiline_entry
- Ensure connecting to DB disables DB configuration fields
- Make DB command timeout configurable via Timeout field (in milliseconds)
- Make DB command timeout configurable via ENV var DB_COMMAND_TIMEOUT_IN_MILLISECONDS (default is 300 milliseconds)

## 0.0.1

- DB GUI for PostgreSQL database with support for running SQL queries and seeing their result as text
