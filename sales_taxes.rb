def round_to_nickel(n)
    (n * 20.00).round / 20.00
end

class Item
    @@exempt_words = ["chocolate", "pill", "book"]
    attr_reader :long_name
    attr_reader :shelf_price
    def initialize(string)
        arr = string.split(" at ")
        @long_name = arr[0]
        @shelf_price = arr[1].to_f
    end
    def exempt
        @long_name.split.any? { |word| @@exempt_words.include?(word) }
    end
    def imported
        @long_name.split.include?("imported")
    end
    def tax_rate
        tax_rate = 10
        tax_rate -= 10 if exempt
        tax_rate += 5 if imported
        tax_rate
    end
    def net_price
        @shelf_price * (100 + tax_rate) / 100
    end
end
class ShoppingCart
    def initialize(input)
        @items = []
        take_input(input)
    end
    def take_input(input)
        input.each_line do |line|
            quantity = line.slice!(/[0-9]* /).strip.to_i
            quantity.times{ add_item(line) }
        end
    end
    def add_item(line)
        @items.push(Item.new(line))
    end
    def sort_items
        @items.sort!{ |a, b| a.long_name <=> b.long_name }
    end
    def itemized_list
        sort_items
        list = @items.inject([]) do |array, element|
            if array[-1] && (array[-1][:item].long_name == element.long_name)
                array[-1][:count] += 1
            else
                tmp = { :item => element, :count => 1}
                array.push( tmp )
            end
            array
        end
        list
    end
    def print_receipt
        list = itemized_list
        taxes = 0
        total = 0
        puts ""
        list.each do |elem|
            count = elem[:count]
            item = elem[:item]
            puts "#{count} #{item.long_name}: #{round_to_nickel(item.net_price * count)}"
            taxes += (item.net_price - item.shelf_price) * count
            total += item.net_price * count
        end
        puts "Sales Taxes: #{round_to_nickel(taxes)}"
        puts "Total: #{round_to_nickel(total)}"
    end
end
inputs = []
inputs[0] = "1 book at 12.49\n1 music CD at 14.99\n1 chocolate bar at 0.85\n"
inputs[1] = "1 imported box of chocolates at 10.00\n1 imported bottle of perfume at 47.50\n"
inputs[2] = "1 imported bottle of perfume at 27.99\n1 bottle of perfume at 18.99\n1 packet of headache pills at 9.75\n1 box of imported chocolates at 11.25"
inputs.each do |e|
    puts "INPUT:\n #{e}"
    transaction = ShoppingCart.new(e)
    transaction.print_receipt
end

