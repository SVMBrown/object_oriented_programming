class Rover
    @@clockwise = ["n", "e", "s", "w"]
    def initialize(x, y, d)
        @x = x
        @y = y
        @d = @@clockwise.index(d.downcase)
    end
    def turn(clockwise)
        modifier = clockwise ? 1 : -1
        @d += modifier
        @d %= 4
    end
    def move
        @x += (@d % 2) * (2 - @d)
        @y += ((@d + 1) % 2) * (1 - @d)
    end
    def to_s
        "x: #{@x}, y: #{@y}, d: #{@@clockwise[@d]}"
    end
end
class MissionControl
    def initialize
        @rovers = {}
    end
    def launch_rover(name, x, y, d)
        @rovers[name] = Rover.new(x, y, d)
    end
    def command_rover(name, command)
        rover = @rovers[name]
        command.each_char do |c|
            case c.downcase
            when 'l' then rover.turn(false)
            when 'r' then rover.turn(true)
            when 'm' then rover.move
            else
                puts "'#{c}' is an invalid command"
            end
        end
    end
    def get_rover(name, rover)
        @rovers[name] = rover
    end
    def list_controlled_rovers
        @rovers.each{ |k, v| puts "Rover #{k} is at (#{v})" }
    end
    def rover_status(name)
        puts "#{name} is at (#{@rovers[name]})"
    end
end
cape_canaveral = MissionControl.new
cape_canaveral.launch_rover("discovery", 0, 0, 'n')
cape_canaveral.launch_rover("endeavour", 1, 0, 'e')

cape_canaveral.command_rover("discovery", "mmrmlmmm")
cape_canaveral.list_controlled_rovers
cape_canaveral.command_rover("endeavour", "mmmlmm")
cape_canaveral.list_controlled_rovers
