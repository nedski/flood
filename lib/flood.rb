
# Provides a means to limit events to a count/time
# ratio. This is a more or less straight port of the Perl 
# Algorithm::FloodControl library by Vladi Belperchinov-Shabanski.
# 
# See README for more information and examples of use.
class FloodControl

  attr_accessor :interval, :flood

  attr_reader :max_events

  def initialize(max_events, interval)
    @flood = Hash.new
    @max_events = max_events
    @interval = interval
  end

  # Reset the event count for a given event, or if no argument
  # supplied reset the event count for all events.
  def reset(event=nil)
    if event.nil?
      @flood.clear
    else
      @flood.delete(event)
    end
  end

  # Get/set the maximum number of events. Setting will truncate
  # all event queues so they're no longer than max_events.
  def max_events=(size)
    old_max_events = @max_events
    @max_events=size
    
    if (old_max_events > @max_events)
      # New event queue is shorter than old; 
      # trim long event queues if needed
      @flood.each do |e, v| 
        v = v[0..@max_events - 1] if v.length > @max_events
      end
    end
  end

  # Check if an event can proceed. 
  #
  # If no event id is given as an argument, the name of the 
  # caller is used.
  # 
  # max_events and interval can be overridden on a per-call basis.
  #
  # The return value is 0 if event can proceed, or a positive integer 
  # if the limit has been exceeded. The  value represents the number 
  # of seconds to wait so the event will occur within the limit set.
  def check(event='',max_events=@max_events, interval=@interval)

    #provide event key if not supplied
    if (event == '')
      # TEST: is this unique?
      event = caller[0].gsub(/\s/,'')
      # print STDERR "EN: $en\n";
    end
    
    # make empty flood array for this event key
    @flood[event] ||= Array.new;  
    
    event_count = @flood[event].length;
    
    if( event_count >= max_events )
      # flood array has enough events to do real flood check
      ot = @flood[event][0];      # oldest event timestamp in the flood array
      tp = Time.now.to_i - ot; # time period between current and oldest event
    
      # now calculate time in seconds until next allowed event
      wait = ot + ( event_count * interval / max_events ) - Time.now.to_i
      if( wait > 0 )
        # positive number of seconds means flood in progress
        # event_count should be rejected or postponed
        # print "WARNING: next event will be allowed in $wait seconds\n";
        return wait;
      end

      # negative or 0 seconds means that event should be accepted
      # oldest event is removed from the flood array
      @flood[event].shift;

    end
    # flood array is not full or oldest event is already removed
    # so current event has to be added

    @flood[event].push(Time.now.to_i);
    # event is ok
    return 0
  end

  # Get flood data
  def storage
    @flood
  end

  # Set flood data
  def storage=(flood)
    @flood=flood
  end

end
