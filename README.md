# Redmine Issue To-Do Lists Plugin

This plugin allows creating of individual to-do lists per project with the ability to add issues and order them manually, no matter what issue priority these issues have.

Link to Redmine plugin page: https://www.redmine.org/plugins/redmine_issue_todo_lists

## Compatibility

* Last tested with Redmine 3.4, should also work with 2.6 - 3.3

## Features

* Create to-do lists per project
* Add individual issues per to-do list (also cross project possible)
* Order these issues per drag and drop
* Add and remove issues to/from to-do list by context menu (even bulk adding possible)
* Autocomplete for issues (as with issue relations)
* To-do lists show all configured default columns displayed on the normal issue list
* Remove closed issues from to-do list automatically (configurable per to-do list)

## Installation

* Read the Redmine plugin installation wiki: http://www.redmine.org/wiki/redmine/Plugins
* Run the migration of plugins: `rake redmine:plugins:migrate RAILS_ENV=production`
* Restart Redmine
* Login and configure rights and roles for this plugin
* Go to corresponding project settings and active project module *Issue To-do lists*
* Click *To-do lists* in project menu

## Screenshots

See screenshots/ folder

## License

GPLv2
