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
    def do_command(str)
        str.each_char do |c|
            case c.downcase
            when 'l' then turn(false)
            when 'r' then turn(true)
            when 'm' then move
            else
                puts "'#{c}' is an invalid command"
            end
        end
    end
end
discovery = Rover.new(0, 0, 'e')
discovery.do_command('mmlmmlmrmmm')
puts discovery
