CONNECTION = {
  adapter: 'sqlite',
  database: File.join(__dir__, '../spec.db')
}.freeze

class Student < ActiveRecord::Base
  establish_connection(CONNECTION)
end

class Employee < ActiveRecord::Base
  establish_connection(CONNECTION)
end

class ActiveRecord::Base
  def self.attribute_metadata
    a = attribute_names.map do |attr|
      [attr, { type: attribute_types[attr],
               column: column_for_attribute(attr) }]
    end
    ActiveSupport::HashWithIndifferentAccess[a]
  end

  def self.generate(attrs = {})
    attrs_ = ActiveSupport::HashWithIndifferentAccess[attrs]
    h = ActiveSupport::HashWithIndifferentAccess.new
    args = attribute_metadata.reduce(h) do |h_, (attr, meta)|
      if (gen = attrs_[attr])
        h_.merge(attr => Generative.run(gen))
      else
        h_.merge(attr => meta[:type].generate)
      end
    end
    self.new(args)
  end
end

100.times do
  Student.generate.save!
  Employee.generate.save!
end


RSpec.describe ActiveRecord::Setops do
  context 'union' do
    it 'should have the same cardinatilty as the two relations combined' do
      expect((Student.all | Employee.all).count).to be(Student.count + Employee.count)
    end
  end
end
