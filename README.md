# ActiveRecord::Setops

Union, Intersect, and Difference set operations for ActiveRecord (also, SQL's UnionAll).

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
class Student < ActiveRecord::Base
end

class Employee < ActiveRecord::Base
end

(Student.select(:name, :birth_date) | Employee.select(:name, :birth_date)).where("name like John%")
```

# See Also

- [Sequel](http://sequel.jeremyevans.net)
- [SQL Set Operations](https://en.wikipedia.org/wiki/Set_operations_(SQL))
