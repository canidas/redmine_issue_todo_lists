# CHANGELOG
### 1.4.0

* make compatible with Redmine 5
* add full context menu
* add sortable columns in picker
* add CSV export
* add sidebar in issue details
* add filter
* correct flicker in gui
* add support for liquid
* add method `issue.todolists_with_positions.items`

### 1.3.2

* allow configuration of issue columns per todo list
* added functionality to include issue columns for text items
* wiki toolbar for new items
* show text item field editor as date in case column name contains `date` word
* refactoring of item editing functionality
* added ginstr credits
* DB MIGRATION IS REQUIRED FOR THIS VERSION (to 7) 

### 1.3.1

* first extended version
* changes to init.rb
* added wiki toolbar to todo list description
* modifications of sortable behavior
* remove autoscroll for table wrapper
* added "Add" button for items (just in case)
* added possibility to edit item comment with wiki toolbar
* added textile support for comments
* added "Order" column to table
* new permission "update items"