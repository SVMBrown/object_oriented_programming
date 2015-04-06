class Rover
    @@clockwise = ["n", "e", "s", "w"]
    attr_reader :x
    attr_reader :y
    attr_reader :name
    def initialize(name, x, y, d)
        @name = name
        @x = x
        @y = y
        @d = @@clockwise.index(d.downcase)
    end
    def turn(clockwise)
        return radio_silence if @destroyed
        modifier = clockwise ? 1 : -1
        @d += modifier
        @d %= 4
    end
    def move
        return radio_silence if @destroyed
        @x += (@d % 2) * (2 - @d)
        @y += ((@d + 1) % 2) * (1 - @d)
    end
    def to_s
        return radio_silence if @destroyed
        "#{@name.upcase} x: #{@x}, y: #{@y}, d: #{@@clockwise[@d]}"
    end
    def destroy
        return radio_silence if @destroyed
        puts "CRITICAL ERROR. #{@name.upcase} FAILING."
        @x = nil
        @y = nil
        @d = nil
        @destroyed = true
    end
    def radio_silence
        "There is no signal to #{@name}."
    end
end
class MissionControl
    def initialize(planet)
        @rovers = {}
        @location = planet
    end
    def launch_rover(name, x, y, d)
        @rovers[name] = Rover.new(name, x, y, d)
        @location.add_occupant(@rovers[name])
        @location.resolve_collisions
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
            @location.resolve_collisions
        end
    end
    def get_rover(name, rover)
        @rovers[name] = rover
    end
    def list_controlled_rovers
        @rovers.each{ |k, v| puts "(Rover #{v})" }
    end
    def rover_status(name)
        puts "#{name} is at (#{@rovers[name]})"
    end
end
class Plateau
    def initialize(x, y)
        @x = x
        @y = y
        @occupants = []
    end
    def add_occupant(rover)
        @occupants.push(rover)
        resolve_collisions
    end
    def resolve_collisions
        @occupants.each do |rover|
            if rover.x >= @x || rover.x < 0 || rover.y >= @y || rover.y < 0
                rover.destroy
                @occupants.delete(rover)
            end
            @occupants.each do |collision|
                if collision.x == rover.x && collision.y == rover.y && collision.name != rover.name
                    collision.destroy
                    @occupants.delete(collision)
                    rover.destroy
                    @occupants.delete(rover)
                end
            end
        end
    end
    def print_map
        @x.times do |i|
            @y.times do |j|
                if @occupants.any? { |rover| rover.x == i && rover.y == j }
                    print " R "
                else
                    print " - "
                end
            end
            print "\n"
        end
    end
end



mars = Plateau.new(6, 6)
cape_canaveral = MissionControl.new(mars)
cape_canaveral.launch_rover("discovery", 0, 0, 'n')
cape_canaveral.launch_rover("endeavour", 1, 0, 'e')

cape_canaveral.command_rover("discovery", "mmrmlmmm")
cape_canaveral.list_controlled_rovers
cape_canaveral.command_rover("endeavour", "mmmlmm")
cape_canaveral.list_controlled_rovers
mars.print_map
cape_canaveral.command_rover("endeavour", "mmmll")
cape_canaveral.command_rover("discovery", "rmmmmml")
cape_canaveral.list_controlled_rovers
