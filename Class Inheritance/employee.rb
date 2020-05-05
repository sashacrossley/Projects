class Employee

    attr_reader :name, :title, :salary, :boss

    def initialize(name, salary, title, boss = nil)
        @name = name
        @title = title
        @salary = salary
        @boss = boss
    end

    def bonus(multiplier)
        @salary * multiplier
    end

end

class Manager < Employee

    attr_accessor :employees

    def initialize(name, salary, title, boss = nil)
        super(name, salary, title, boss)
        @employees = []
    end

    def add_employee(subby)
        employees << subby
        subby
    end

    def bonus(multiplier) #Managers should get a bonus based on the total salary of all of their subordinates, as well as the manager's subordinates' subordinates, and the subordinates' subordinates' subordinates, etc.
        subsalary * multiplier
    end
    
    def subsalary
        subsalary = 0
        employees.each do |employee|
            if employee.is_a?(Manager)
                subsalary += employee.salary + employee.subsalary
            else
                subsalary += employee.salary
            end
        end
        subsalary
    end
end

ned = Manager.new("Ned", 1000000, "Founder")
darren = Manager.new("Darren", 78000, "TA Manager", "Ned")
david = Employee.new("David", 10000, "TA", "Darren")
shawna = Employee.new("Shawna", 12000, "TA", "Darren")
ned.add_employee(darren)
darren.add_employee(david)
darren.add_employee(shawna)

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000