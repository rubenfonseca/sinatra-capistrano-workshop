class RackFuturama
  FUTURAMA = File.read('./public/quotes.txt').split("\n\n").map { |q| q.sub /\n|\t/, ' ' }
  
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['X-Futurama'] = FUTURAMA[rand(FUTURAMA.length)]
    
    [status, headers, body]
  end
end