require_relative('../db/sql_runner.rb')

class Car
######################################################################
  attr_reader( :id, :shop_id)
  attr_accessor( :make, :model, :style, :price, :image)
  ####################################################################
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @shop_id = options['shop_id'].to_i
    @make = options['make']
    @model = options['model']
    @style = options['style']
    @price = options['price'].to_i
    @image = options['image']
  end

  ####################################################################
  ####################################################################
  ## CLASS METHODS ##

  def self.all()
    sql = "SELECT * FROM cars"
    cars = SqlRunner.run(sql)
    result = cars.map{|car| Car.new(car)}
    return result
  end
  ####################################################################

  def self.delete_all()
    sql = "DELETE FROM cars"
    SqlRunner.run(sql)
  end
  ####################################################################

  def self.find(id)
    # I want to get all information from the cars table about a specific car
    sql = "SELECT * FROM cars WHERE id = $1"
    # Need to define the value to be plugged in to the sql runner here
    values = [id]
    # get the hash object back by using the runner
    car = SqlRunner.run(sql, values)
    # create a new object from that hash
    result = Car.new(car.first)
    # binding.pry
    return result
  end
  ######################################################
  ## I want to return all cars where the shop_id matches a specific shop
  ## need to select all from cars where the shop id matches the id of the dealer I'm passing in?
  # not here! do in shop.rb
  # def self.all_here(id)
  #   sql = "SELECT * FROM cars WHERE shop_id = $1"
  #   values = [id]
  #   car = SqlRunner.run(sql, values)
  #   result = Car.new(car.first)
  #   return result
  # end
  ####################################################################
  ####################################################################
  ## OBJECT METHODS ##

  def save
    sql = "INSERT INTO cars(
          shop_id,
          make,
          model,
          style,
          price,
          image
        )
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id;"
        values = [@shop_id, @make, @model, @style, @price, @image]
        @id = SqlRunner.run(sql,values)[0]['id'].to_i
  end
  ####################################################################

  def update
    sql = "UPDATE cars
        SET (
          shop_id,
          make,
          model,
          style,
          price,
          image
          ) =
          ($1, $2, $3, $4, $5, $6)
          WHERE id = $7"
          values = [@shop_id, @make, @model, @style, @price, @image, @id]
          SqlRunner.run(sql, values)
  end
  ####################################################################

  def delete()
    sql = "DELETE FROM cars
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end
  ####################################################################
  def high_end?
    for car in cars
      if car.price >= 60000
        return "This is a high-end car!"
      elsif
        car.price >= 40000
        return "This is a midway car!"
      else
        return "This is a low-end car!"
      end
    end
  end
  ######################################################
  def shop
    sql = "SELECT * FROM shops
           WHERE id = $1"
           values = [@shop_id]
    result = SqlRunner.run(sql, values)
    shop = Shop.new(result.first)
    return shop.name
  end
  ######################################################
  def shop_id
    sql = "SELECT * FROM shops
           WHERE id = $1"
           values = [@shop_id]
    result = SqlRunner.run(sql, values)
    shop = Shop.new(result.first)
    return shop.id
  end
  ###################################################################
  ###################################################################
  ###################################################################
end ## class end
