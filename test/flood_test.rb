#!/usr/bin/env ruby

# run test suite
require 'test/unit'
require 'flood'

class TestFlood < Test::Unit::TestCase

  EVENT_LIMIT  = 15
  EXTRA_EVENTS = 5
  TIME_LIMIT   = 10
  EXTRA_TIME   = 5

  def setup
    @t = FloodControl.new(EVENT_LIMIT, TIME_LIMIT)
  end

  def test_basic

    EVENT_LIMIT.times do 
      assert_equal(0, @t.check('test'))
    end
    assert(@t.check('test') > 0, "Should return wait > 0")
    
    sleep TIME_LIMIT
    assert_equal(0, @t.check('test'))

    assert_not_nil(@t.storage)
    
  end 

  def test_call_with_args
    @t.reset

    EVENT_LIMIT.times do 
      assert_equal(0, @t.check('test'))
    end
    assert(@t.check('test') > 0, "Should return wait > 0")
    
    assert_equal(0, @t.check('test', EVENT_LIMIT + 1, TIME_LIMIT))
    assert(@t.check('test', EVENT_LIMIT - 1, TIME_LIMIT) > 0, 
           "Should return wait > 0")
    
    sleep TIME_LIMIT
    assert_equal(0, @t.check('test'))
    
    assert_not_nil(@t.storage)
    
  end 

  def test_reset_max
    @t.reset

    # test event
    EVENT_LIMIT.times do 
      assert_equal(0, @t.check('test'))
    end 
    assert(@t.check('test') != 0, "Should return wait > 0")

    # change limit
    new_limit = EVENT_LIMIT + EXTRA_EVENTS
    assert_equal(new_limit, @t.max_events=new_limit)
    EXTRA_EVENTS.times do 
      assert_equal(0, @t.check('test'))
    end
    assert(@t.check('test') != 0, "Should return wait > 0")   
    
  end

  def test_reset_time
    @t.reset
    
    # test event
    EVENT_LIMIT.times do 
      assert_equal(0, @t.check('test'))
    end 
    sleep TIME_LIMIT + EXTRA_TIME
    assert_equal(0, @t.check('test'))

    # change time
    assert_equal(TIME_LIMIT + EXTRA_TIME, @t.interval=TIME_LIMIT + EXTRA_TIME)
    assert_equal(0, @t.check('test'))
 
  end

  def test_generated_key
    @t.reset

    # test 
    EVENT_LIMIT + 1.times do |c|
      c < EVENT_LIMIT ? assert_equal(0, @t.check()) :  assert(@t.check() != 0, 
 		"Should return wait > 0")
    end
  end
  
  # TODO: Test store/restore flood data
  
end
 
