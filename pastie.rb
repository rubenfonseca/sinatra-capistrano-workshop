require 'rubygems'
require 'json'
require 'uuid'

class Pastie
  DATA_DIR = File.join(File.dirname(__FILE__), 'data')
  UUID = UUID.new
  
  @@count = 10
  
  def self.save_new_pastie(pastie)
    object = {
      :pastie => pastie,
      :created_at => Time.now.to_i,
      :id => UUID.generate
    }
    
    path = "#{DATA_DIR}/#{object[:created_at]}-"
    path << "#{object[:id]}.json"
    
    File.open(path, 'w') do |f|
      f.write object.to_json
    end
    
    object[:id]
  end
  
  def self.get_latest_pasties
    r = Dir.glob("#{DATA_DIR}/[0-9]**.json")
    r.sort.last(@@count).reverse
  end
  
  def self.get_pastie(id)
    path = "#{DATA_DIR}/*#{id}.json"
    
    if not Dir.glob(path).empty?
      Dir.glob(path).first
    else
      raise PastieNotFound
    end
  end
  
  def self.number_of_pasties_to_list=(count)
    @@count = count
  end
end

class PastieNotFound < StandardError
  def message
    'Pastie does not exist'
  end
end