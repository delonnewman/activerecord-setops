require "active_record/setops/version"

module ActiveRecord
  class Relation
    # Performs a set theoretic union works like `Array#+` but puts the load on the database
    # and allows you to chain more relation operations.
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
