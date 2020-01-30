![Ruby](https://github.com/delonnewman/activerecord-setops/workflows/Ruby/badge.svg)

# ActiveRecord::Setops

Union, Intersect, and Difference set operations for ActiveRecord (also, SQL's UnionAll).
Has only been tested with Rails 5.

# Why?

Joins can be difficult to reason about in Arel (an SQL for that matter). Many joins can be replaced
with set operations which are much simpler beasts, may offer performance gains, and have consistent
mathematical properties. But these operations while present in Arel are lacking in ActiveRecord. This
module attempts to correct that oversight.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-setops'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-setops

# Synopsis

```ruby
class Student < ActiveRecord::Base; end
class Employee < ActiveRecord::Base; end

(Student.select(:name, :birth_date) | Employee.select(:name, :birth_date)).where("name like John%")
```

# See Also

- [Sequel](http://sequel.jeremyevans.net)
- [SQL Set Operations](https://en.wikipedia.org/wiki/Set_operations_(SQL))
