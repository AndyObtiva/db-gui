# DB GUI (Database Graphical User Interface) 0.3.0
## [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 /> Glimmer DSL for LibUI Application](https://github.com/AndyObtiva/glimmer-dsl-libui)
[![Gem Version](https://badge.fury.io/rb/db-gui.svg)](http://badge.fury.io/rb/db-gui)

This is an early alpha database graphical user interface that enables interaction with a relational SQL database.

It currently supports PostgreSQL as a start, with the potential of supporting many other databases in the future.

![db gui](/screenshots/db-gui-mac.png)

## Setup

Run:
```
gem install db-gui -v0.3.0
```

## Usage

Run:
```
dbui
```

Or, run one of the aliases: `db-ui` / `dbgui` / `db-gui`

Note that it stores the last connection details under `~/.db_gui`, and will auto-connect using that configuration on startup for extra convenience (in the future, there is the potential to support multiple connection configurations).

### Menu Items

**Edit -> Copy Table**

Click on this menu item to copy the table data as a formatted string to the clipboard.

**Edit -> Copy Table (with headers)**

Click on this menu item to copy the table data with headers as a formatted string to the clipboard.

**Edit -> Copy Table (with query & headers)**

Click on this menu item to copy the table data with query (e.g. SQL) & headers as a formatted string to the clipboard.

**Edit -> Copy Selected Row**

Click on this menu item to copy the selected row data as a formatted string to the clipboard.

**Edit -> Copy Selected Row (with headers)**

Click on this menu item to copy the selected row data with headers as a formatted string to the clipboard.

## Change Log

[CHANGELOG.md](/CHANGELOG.md)

## TODO

[TODO.md](/TODO.md)

## Contributing to db_gui

-   Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't
    requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it
    in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If
    you want to have your own version, or is otherwise necessary, that
    is fine, but please isolate to its own commit so I can cherry-pick
    around it.

## Copyright

Copyright (c) 2025 Andy Maleh.
[MIT](/LICENSE.txt)
See [LICENSE.txt](/LICENSE.txt) for further details.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built with [Glimmer DSL for LibUI](https://github.com/AndyObtiva/glimmer-dsl-libui) (Ruby Desktop Development GUI Library)
