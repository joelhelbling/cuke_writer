require 'date'

class SerialNumber
  @@prefix = ''
  @@number = nil

  def self.number
    @@number ||= generate_new_number
    "#{@@prefix}#{@@number}"
  end
  def self.number=(new_number)
    @@number = new_number
  end
  def self.prefix=(prefix)
    @@prefix = prefix
  end
  def self.generate_new_number
    DateTime.now.strftime('%Y%m%d%H%M%S')
  end
  def self.to_s
    number
  end
end

