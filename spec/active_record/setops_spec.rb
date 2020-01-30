CONNECTION = {
  adapter: 'sqlite3',
  database: File.join(__dir__, '../spec.db')
}.freeze

class TestRecord < ActiveRecord::Base
  establish_connection(CONNECTION)

  self.abstract_class = true

  def self.generate_attributes
    { name: String, dob: Date, department: String }
  end

  def self.generate
    new(generate_attributes.generate)
  end
end

class Student < TestRecord
end

class Employee < TestRecord
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

  context 'intersect' do
  end
end
