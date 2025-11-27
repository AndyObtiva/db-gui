# TODO

## 0.3.0

- Fix No database configurations stored yet. undefined method `notify_observers' for #<DbGui::Presenter::DbPresenter:0x00000001067b7da0 @new_db=#<DbGui::Model::Db:0x-2d6d336c2fab2834>, @dbs=[#<DbGui::Model::Db:0x-2d6d336c2fab2834>, #<DbGui::Model::Db:0x311955cd94f035e7>, #<DbGui::Model::Db:0x-3864b27306b3955e>], @selected_db=#<DbGui::Model::Db:0x311955cd94f035e7>>

- Remove the need to escape special values in a password, such as ticks (`) and dollar sign ($). That should be handled automatically by the implementation as to allow the user to enter the DB password raw as they would normally.
- Remember all DB commands in a history of commands (show them in a dropdown)
- Ability to update a remembered DB command
- Ability to delete a remembered DB command
- Provide preference screen for editing DB command history (deleting or clearing all commands)

## Future

- Remember result history
- Copy a specific cell (offer a dialog that takes column name or number)
- Allow copying raw result as is as well (not just rows)
- Render the error message using area to choose a monospace font that would align the error cursor with the erroneous word
- Replace table with refined_table with pagination and filtering support to handle larger amounts of data
- Save multiple DB configs (accounts)
- Support DML DB commands (SQL commands for mutating database data like insert/update/delete)
- Support MySQL DB
- Support CSV files
- If an incorrect table or column name is entered, automatically seek the existence of the closest name to it and use it instead while correcting the SQL query automatically
- Support showing multiple SQL query results in multiple tabs
