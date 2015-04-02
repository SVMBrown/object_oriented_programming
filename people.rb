class Person
    def initialize(name)
        @name = name
    end
    #greeting is something all people should be able to do
    def greeting
        "Hi, my name is #{@name}"
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
chris = Instructor.new("Chris")
puts chris.greeting
cristina = Student.new("Cristina")
puts cristina.greeting
puts chris.teach
puts cristina.learn
#Doesn't work because students can't teach (only instructors)
#puts cristina.teach

