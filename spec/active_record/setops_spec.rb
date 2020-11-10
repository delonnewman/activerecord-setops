CONNECTION = {
  adapter: 'sqlite3',
  database: File.join(__dir__, '../spec.db')
}.freeze

RecordAttrs = { name: String, dob: Date, department: String }

class TestRecord < ActiveRecord::Base
  establish_connection(CONNECTION)

  self.abstract_class = true

  def self.generate
    new(RecordAttrs.generate)
  end
end

class Student < TestRecord; end
class Employee < TestRecord; end

RSpec.describe ActiveRecord::Setops do
  include Gen::Test

  context 'union' do
    it 'should have the same cardinatilty as the two relations combined' do
      for_all (30..50), (10..70) do |n, m|
        TestRecord.transaction do
          n.times { Student.generate.save! }
          m.times { Employee.generate.save! }
        end
        expect((Student.all | Employee.all).count).to eq(Student.count + Employee.count)
        TestRecord.transaction do
          Student.delete_all
          Employee.delete_all
        end
      end
    end
  end

  context 'union_all' do
    it 'should have the same cardinatilty as the two relations combined' do
      for_all (30..50), (10..70) do |n, m|
        TestRecord.transaction do
          n.times { Student.generate.save! }
          m.times { Employee.generate.save! }
        end
        expect((Student.all + Employee.all).count).to eq(Student.count + Employee.count)
        TestRecord.transaction do
          Student.delete_all
          Employee.delete_all
        end
      end
    end
  end

  context 'intersect' do
    it 'should only include those records that are common' do
      for_all C::ArrayOf[RecordAttrs] do |attrs|
        TestRecord.transaction do
          n = Student.create!(attrs).count
          m = Employee.create!(attrs).count
          expect(n).to eq(m)
        end
        num_studs = Student.count
        num_emps = Employee.count
        expect(num_studs).to eq(num_emps)
        for_all C::ArrayOf[RecordAttrs] do |stud_attrs|
          Student.create!(stud_attrs)
          num_intersect = (Student.select(:name) & Employee.select(:name)).count
          expect(num_intersect).to eq(num_studs)
        end
        for_all C::ArrayOf[RecordAttrs] do |stud_attrs|
          Employee.create!(stud_attrs)
          num_intersect = (Student.select(:name) & Employee.select(:name)).count
          expect(num_intersect).to eq(num_emps)
        end
        TestRecord.transaction do
          Student.delete_all
          Employee.delete_all
        end
      end
    end
  end

  context 'difference' do
    it 'should only include those records that are not in the other' do
      for_all C::ArrayOf[RecordAttrs] do |attrs|
        Student.create!(attrs)
        Employee.create!(attrs)
        num_studs = Student.count
        num_emps = Employee.count
        expect(num_studs).to eq(num_emps)
        for_all C::ArrayOf[RecordAttrs] do |stud_attrs|
          Student.create!(stud_attrs)
          num_except = (Student.select(:name) - Employee.select(:name)).count
          expect(num_except).to eq(Student.count - num_emps)
        end
        TestRecord.transaction do
          Student.delete_all
          Employee.delete_all
        end
      end
    end
  end
end
