![Ruby](https://github.com/delonnewman/activerecord-setops/workflows/Ruby/badge.svg)
[![Gem Version](https://badge.fury.io/rb/activerecord-setops.svg)](https://badge.fury.io/rb/activerecord-setops)

# ActiveRecord::Setops

Union, Intersect, and Difference set operations for ActiveRecord (also, SQL's UnionAll).
Has only been tested with Rails 5.

# Synopsis

```ruby
class Student < ActiveRecord::Base; end
class Employee < ActiveRecord::Base; end

(Student.select(:name, :birth_date) | Employee.select(:name, :birth_date)).where("name like John%")
```

# Why?

Joins can be difficult to reason about in Arel (and SQL for that matter). Many joins can be replaced
with set operations which are much simpler beasts, may offer performance gains, and have consistent
mathematical properties. But these operations while present in Arel are missing in ActiveRecord. This
module attempts to correct this lack.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-setops'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-setops

# Non-Installation

If you'd like the functionality, but would prefer to avoid yet another dependency, please fill free to paste the following code into your nearest lib directory, I'm certain it's not perfect but it has been [tested](spec/active_record/setops_spec.rb) with Rails 5, and is being used in production.

```ruby
module ActiveRecord
  class Relation
    def union(other)
      binary_operation(Arel::Nodes::Union, other)
    end
    alias | union

    def union_all(other)
      binary_operation(Arel::Nodes::UnionAll, other)
    end
    alias + union_all

    def intersect(other)
      binary_operation(Arel::Nodes::Intersect, other)
    end
    alias & intersect

    def difference(other)
      binary_operation(Arel::Nodes::Except, other)
    end
    alias - difference

    private

    def binary_operation(op_class, other)
      @klass.unscoped.from(Arel::Nodes::TableAlias.new(op_class.new(self.arel.ast, other.arel.ast), @klass.arel_table.name))
    end
  end
end
```

# See Also

- [Sequel](http://sequel.jeremyevans.net)
- [SQL Set Operations](https://en.wikipedia.org/wiki/Set_operations_(SQL))
- [active_record_union](https://github.com/brianhempel/active_record_union)
