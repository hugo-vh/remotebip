#require 'wiringpi'

class HardwareHelper
  PIN = 3
  PULSE_LENGTH_SEC = 2
  OUTPUT = 1
  HIGH = 1
  LOW = 0

  attr_accessor :gpio
  def initialize
    @gpio ||= GpioMock.new
    # @gpio ||= WiringPi::GPIO.new
  end

  def run
    gpio.mode(PIN,OUTPUT)
    gpio.write(PIN,HIGH)
    wait
    gpio.write(PIN,LOW)
  end

  def wait
    sleep(PULSE_LENGTH_SEC)
  end
end

class GpioMock
  def mode pin, mode
    puts "GPIO: Set mode #{mode} on pin #{pin}"
  end

  def write pin, value
    puts "GPIO: Write #{value} on pin #{pin}"
  end
end
