require 'test_helper'
class ConcurrencyTest < ActiveSupport::TestCase
  def setup
    Protocol.destroy_all if defined? Protocol
    time = Time.local(2011, 9, 25, 12, 0, 0)
    Timecop.travel(time)
  end

  def teardown
    reset_models
  end

  def reset_models
    ConcurrencyTest.send(:remove_const, 'Protocol') if defined? Protocol
    ConcurrencyTest.send(:remove_const, 'Call')     if defined? Call
  end

  test "should be able to handle concurrency" do
    class Protocol < ActiveRecord::Base
      protokoll :number
    end

    10.times do
      fork do
        p "Starting new process...."
        protocol = Protocol.create
        sleep(rand(10))
        protocol.save
        p "CREATED: #{protocol.number}"
      end
    end
    Process.waitall
    assert_equal 10, Protocol.count
  end
end


