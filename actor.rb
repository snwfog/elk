require 'celluloid/current'

class MyActor
  include Celluloid

  def initialize
    puts 'Im created immediately'
  end
end

MyActor.pool(as: :actors, size: 2)
