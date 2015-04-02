class Person
    def initialize(name)
        @name = name
    end
end
class Instructor < Person
    def teach
        "Everything in Ruby is an Object!"
    end
end
class Student < Person
    def learn
        "I get it!"
    end
end
