# Learning Objectives

* When we write our ORM code in each individual class--there is a lot of repition. We define attr_accessors, initialize methods, and ORM-related methods like #save, #find, #update, #destroy
* What if, instead, we could write one flexible class that, if other classes inherit from it, could give ALL children classes the above attributes and behaviors?
* So, the focus of building a flexible, or "dynamic" ORM it to build a class that, if given access to a database with tables that are named in accordance with child classes (i.e a "dogs" table will correspond to a "Dog" class), we don't have to:
  * Define individual initialize methods
  * Define individual attr_accessors
  * Define individual ORM metohds like #save, #find, #destroy

* Instead, our dynamic ORM class will use metaprogramming to take info about a specific database table and use that info in methods that will write flexible, dynamic (i.e. not specific to a class or table name) methods to achieve the above for us. 

We'll learn how to:
* dynamically define attr_accessor and assign values in a dynamic initialize method
* build a dynamic #save, #find method
* BONUS: build a dynamic #all and #find method that returns Ruby objects instead of database records in messy arrays
