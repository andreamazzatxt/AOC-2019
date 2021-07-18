input = File.read('6.txt').split(/\n/).map{|pair| pair.split(')')}
class Planet
    attr_reader :name, :orbits
    def initialize(name)
        @name = name
        @orbits
    end

    def orbits_around(planet)
        @orbits = planet
    end

    def count
        @orbits ? 1 + @orbits.count() : 0
    end
end

$planets = {}
input.each do |pair|
    $planets[pair[0]] = Planet.new(pair[0]) unless $planets[pair[0]]
    $planets[pair[1]] = Planet.new(pair[1]) unless $planets[pair[1]]
end
input.each do |pair|
    $planets[pair[1]].orbits_around $planets[pair[0]]
end

# part 1
count = 0
$planets.each do |name, planet|
    count = count + planet.count()
end
puts 'part one: '
puts count

#part 2 

you = $planets['YOU']
santa = $planets['SAN']

def chain_to_planet(planet, destination)
    chain = []
    while planet.name != destination
        chain << planet.orbits
        planet = planet.orbits
    end
    return chain
end

common_planets = chain_to_planet(santa, 'COM') & chain_to_planet(you, 'COM')
#find fastes route
fastest = nil
common_planets.each do |planet|
     route = chain_to_planet(santa.orbits, planet.name).size + chain_to_planet(you.orbits, planet.name).size
     fastest = route if fastest.nil? || fastest > route
end
puts 'part two: '
p fastest