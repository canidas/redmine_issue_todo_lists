# Redmine Issue To-Do Lists Plugin

This plugin allows creating of individual to-do lists per project with the ability to add issues and order them manually, no matter what issue priority these issues have.

Link to Redmine plugin page: https://www.redmine.org/plugins/redmine_issue_todo_lists

## Compatibility

* Version 1.3 for >= Redmine 4 **ONLY**
* Version 1.2 for <= Redmine 3.4
* Currently there's no difference between 1.2 and 1.3 except Redmine 4 compatibility

## Features

* Create to-do lists per project
* Add individual issues with or without comments per to-do list (also cross project possible)
* Or create to-do lists with solely text items
* Order these issues / items per drag and drop
* Add and remove issues to/from to-do list by context menu (even bulk adding possible)
* Autocomplete for issues (as with issue relations)
* To-do lists show all configured default columns displayed on the normal issue list
* Remove closed issues from to-do list automatically (configurable per to-do list)

## Screenshots

See [screenshots folder](https://github.com/canidas/redmine_issue_todo_lists/tree/master/screenshots)

## Install

* Read the Redmine plugin installation wiki: http://www.redmine.org/wiki/redmine/Plugins
* Run the migration for database: `bundle exec rake redmine:plugins:migrate NAME=redmine_issue_todo_lists RAILS_ENV=production`
* Restart Redmine
* Login and configure rights and roles for this plugin
* Go to corresponding project settings and active project module *Issue To-do lists*
* Click *To-do lists* in project menu

## Update

* Update plugin with Git or download sources manually
* Run migration as described above
* Restart Redmine

## Uninstall

* Run migration backwards: `bundle exec rake redmine:plugins:migrate NAME=redmine_issue_todo_lists VERSION=0 RAILS_ENV=production`
* Remove plugin folder
* Restart Redmine

## License

GPLv2
