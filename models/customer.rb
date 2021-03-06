require_relative('../db/sql_runner.rb')

class Customer

  #####################################################################
  attr_reader :id
  attr_accessor :name, :budget, :email, :previous_brand
  #####################################################################
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @budget = options['budget'].to_i
    @email = options['email']
    @previous_brand = options['previous_brand']
  end
  #####################################################################
  #####################################################################
  ## CLASS METHODS ##

  def self.all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map{|customer| Customer.new(customer)}
    return result
  end
  #####################################################################

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end
  #####################################################################

  def self.find(id)
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    customer = Customer.new(result.first)
    return customer
  end
  #####################################################################
  #####################################################################
  ## OBJECT METHODS ##

  def save
    sql = "INSERT INTO customers(
    name,
    budget,
    email,
    previous_brand
    )
    VALUES ($1, $2, $3, $4)
    RETURNING id;"
    values = [@name, @budget, @email, @previous_brand]

    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end
  #####################################################################

  def update
    sql = "UPDATE customers
           SET(
             name,
             budget,
             email,
             previous_brand
             ) = ($1, $2, $3, $4)
             WHERE id = $5"
    values = [@name, @budget, @email, @previous_brand, @id]
    SqlRunner.run(sql, values)
  end
  #####################################################################

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end
  ######################################################

  def in_budget
    sql = "SELECT * FROM cars WHERE price <= $1;"
    values = [@budget]
    results = SqlRunner.run(sql, values)
    cars = results.map{|result| Car.new(result)}
    return cars
  end
  ######################################################
  def cars
    sql = "SELECT * FROM cars WHERE make = $1;"
    values = [@previous_brand]
    results = SqlRunner.run(sql, values)
    #full array not single hash
    #map them instead
    cars = results.map{|result| Car.new(result)}
    return cars
  end
  ######################################################

  def both
    sql = "SELECT * FROM cars
           WHERE make = $1
           AND price <= $2;"
    values = [@previous_brand, @budget]
    results = SqlRunner.run(sql, values)
    cars = results.map{|result| Car.new(result)}
    return cars
  end
  #####################################################################
  #####################################################################
  #####################################################################
end ## Class End ##
