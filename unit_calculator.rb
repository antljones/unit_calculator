

require 'optparse'

require 'ostruct'

 

#-------------------------------------------------------------------------

class Unit

  attr_reader :symbol, :description, :area, :som

 

  def initialize(symbol, description, area, som, equivalent)

    @symbol = symbol

    @description = description

    @area = area

    @som = som

 

    #The equivalent value for 1 SI unit

    @equivalent = equivalent

  end

 

  def get_equivalent

    return @equivalent

  end

 

end

#-------------------------------------------------------------------------

class Measurement

 

  def initialize(unit, value)

    @unit = unit

    @value = value

  end

 

  def get_value

    return @value

  end

 

  def get_unit

    return @unit

  end

 

end

#-------------------------------------------------------------------------

units = Array.new

 

# SI Units

units << Unit.new( "s", "second", "time", "SI", 1 )

units << Unit.new( "m", "metre", "distance", "SI", 1 )

units << Unit.new( "kg", "kilogram", "mass", "SI", 1 )

units << Unit.new( "A", "ampere", "electric current", "SI", 1 )

units << Unit.new( "K", "kelvin", "thermodynamic temperature", "SI", 1 )

units << Unit.new( "mol" , "mole", "amount of substance", "SI", 1 )

units << Unit.new( "cd", "candela", "luminous intensity", "SI", 1 )

 

#SI Derived Units

units << Unit.new( "m2", "metres squared", "area", "SI", 1)

 

#Imperial Units

units << Unit.new( "mi", "mile", "distance", "Imperial", 1609.34 )

units << Unit.new( "", "furlong", "distance", "Imperial", 201.168 )

units << Unit.new( "", "chain", "distance", "Imperial", 20.1168 ) 

units << Unit.new( "", "rod", "distance", "Imperial", 5.0292)

units << Unit.new( "", "yard", "distance", "Imperial", 0.9144)

units << Unit.new( "in", "inch", "distance", "Imperial", 0.0254)

units << Unit.new( "", "acre", "area", "Imperial", 4046.86)

units << Unit.new( "", "ton", "mass", "Imperial", 907.185)

units << Unit.new( "cwt", "hundredweight", "mass", "Imperial", 50.8023)

units << Unit.new( "st", "stone", "mass", "Imperial", 6.35029)

units << Unit.new( "lb", "pound", "mass", "Imperial", 0.453592)

units << Unit.new( "oz", "ounce", "mass", "Imperial", 0.0283495)

 

options = OpenStruct.new

OptionParser.new do |opts|

  opts.banner = "Usage: example.rb [options]"

 

  opts.on("-i I", String,"Input Units") do |i|

    options.inputUnits = i

  end

 

  opts.on("-a A", Integer,"Amount") do |a|

    options.amount = a

  end

 

  opts.on("-o O", String, "Output Units") do |o|

    options.outputUnits = o

  end

 

end.parse!  

 

outputMeasurement = nil

 

if !options.inputUnits.nil? and !options.amount.nil? and !options.outputUnits.nil?

 

  inputUnitPlace = -1

  outputUnitPlace = -1

  # loop through the array to find the unit

  units.each_with_index { |unit,index|

    if unit.symbol.eql? options.inputUnits or unit.description.eql? options.inputUnits

      inputUnitPlace = index

    end

 

    if unit.symbol.eql? options.outputUnits or unit.description.eql? options.outputUnits

      outputUnitPlace = index

    end

  }

 

  if inputUnitPlace > -1

    if outputUnitPlace > -1

 

      # Create the input measurement

      im = Measurement.new(units[inputUnitPlace], options.amount)

 

      # perform the equivalent calculation

      incalc = im.get_value * im.get_unit.get_equivalent

 

      #perform the output calculation

      outcalc = incalc * units[outputUnitPlace].get_equivalent

 

      # Create the output measurement

      outputMeasurement = Measurement.new(units[outputUnitPlace], outcalc)

 

    else

      puts "output unit does not exist"

    end

  else

    puts "input unit does not exist"

  end

 

else

  puts "Specify -a, -i and -o for amount, input units and output units"

end

 

if !outputMeasurement.nil?

  puts outputMeasurement.get_value

else

  puts "something went wrong"

end