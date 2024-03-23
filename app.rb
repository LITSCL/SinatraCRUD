require 'sinatra'
require 'json'
require 'securerandom'

class Producto
  attr_accessor(
    :codigo,
    :nombre,
    :precio
  )

  def initialize nombre, precio
    @codigo = SecureRandom.uuid
    @nombre = nombre
    @precio = precio
  end

  def to_json opciones = {} #Sobreescribiendo el método "to_json".
    return { codigo: @codigo, nombre: @nombre, precio: @precio }.to_json opciones
  end
end

productos = []

get "/" do
  return JSON.generate productos #El método "generate" permite convertir el objeto a un json, internamente este método hace uso del método to_json de la clase.
end

get "/:codigo" do
  codigo = params[:codigo]

  producto = productos.find { |producto| producto.codigo == codigo }
  halt 404, { mensaje: "SERVIDOR: No existe el producto con el codigo #{codigo}" }.to_json unless producto #El método "halt" premite interrumpir la ejecución de la ruta y enviar un mensaje al cliente.

  return JSON.generate producto #El método "generate" permite convertir el objeto a un json, internamente este método hace uso del método to_json de la clase.
end

post "/" do
  nombre = params[:nombre]
  precio = params[:precio]

  producto = Producto.new nombre, precio
  productos << producto #Agregande el producto al final del array mediante el operador "<<".

  return JSON.generate producto #El método "generate" permite convertir el objeto a un json, internamente este método hace uso del método to_json de la clase.
end

put "/:codigo" do
  codigo = params[:codigo]
  nombre = params[:nombre]
  precio = params[:precio]

  producto = productos.find { |producto| producto.codigo == codigo } #El resultado de la búsqueda, corresponde a una referencia del array.
  halt 404, { mensaje: "SERVIDOR: No existe el producto con el codigo #{codigo}" }.to_json unless producto #El método "halt" premite interrumpir la ejecución de la ruta y enviar un mensaje al cliente.

  producto.nombre = nombre #Modificando el nombre del producto (Se esta modificando el elemento del array).
  producto.precio = precio #Modificando el precio del producto (Se esta modificando el elemento del array).

  return JSON.generate producto #El método "generate" permite convertir el objeto a un json, internamente este método hace uso del método to_json de la clase.
end

delete "/:codigo" do
  codigo = params[:codigo]

  producto = productos.find { |producto| producto.codigo == codigo }
  halt 404, { mensaje: "SERVIDOR: No existe el producto con el codigo #{codigo}" }.to_json unless producto #El método "halt" premite interrumpir la ejecución de la ruta y enviar un mensaje al cliente.

  productos.delete producto

  return JSON.generate producto #El método "generate" permite convertir el objeto a un json, internamente este método hace uso del método to_json de la clase.
end
