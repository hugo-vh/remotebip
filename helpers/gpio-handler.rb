require 'wiringpi'

class GpioHandler
  MY_PIN = 3

  def run
    io = WiringPi::GPIO.new
    io.mode(MY_PIN,OUTPUT)
    puts "Switching Pin #{MY_PIN} to #{HIGH}"
    io.write(MY_PIN,HIGH)
    
    sleep(2)
    puts "Switching Pin #{MY_PIN} to #{LOW}"
    io.write(MY_PIN,LOW)
  end
end
