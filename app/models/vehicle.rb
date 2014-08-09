# vehicle = Vehicle.new           # => #<Vehicle:0xb7cf4eac @state="parked", @seatbelt_on=false>
# vehicle.state                   # => "parked"
# vehicle.state_name              # => :parked
# vehicle.human_state_name        # => "parked"
# vehicle.parked?                 # => true
# vehicle.can_ignite?             # => true
# vehicle.ignite_transition       # => #<StateMachine::Transition attribute=:state event=:ignite from="parked" from_name=:parked to="idling" to_name=:idling>
# vehicle.state_events            # => [:ignite]
# vehicle.state_transitions       # => [#<StateMachine::Transition attribute=:state event=:ignite from="parked" from_name=:parked to="idling" to_name=:idling>]
# vehicle.speed                   # => 0
# vehicle.moving?                 # => false
#
# vehicle.ignite                  # => true
# vehicle.parked?                 # => false
# vehicle.idling?                 # => true
# vehicle.speed                   # => 10
# vehicle                         # => #<Vehicle:0xb7cf4eac @state="idling", @seatbelt_on=true>
#
# vehicle.shift_up                # => true
# vehicle.speed                   # => 10
# vehicle.moving?                 # => true
# vehicle                         # => #<Vehicle:0xb7cf4eac @state="first_gear", @seatbelt_on=true>
#
# # A generic event helper is available to fire without going through the event's instance method
# vehicle.fire_state_event(:shift_up) # => true
#
# # Call state-driven behavior that's undefined for the state raises a NoMethodError
# vehicle.speed                   # => NoMethodError: super: no superclass method `speed' for #<Vehicle:0xb7cf4eac>
# vehicle                         # => #<Vehicle:0xb7cf4eac @state="second_gear", @seatbelt_on=true>
#
# # The bang (!) operator can raise exceptions if the event fails
# vehicle.park!                   # => StateMachine::InvalidTransition: Cannot transition state via :park from :second_gear
#
# # Generic state predicates can raise exceptions if the value does not exist
# vehicle.state?(:parked)         # => false
# vehicle.state?(:invalid)        # => IndexError: :invalid is an invalid name
#
# # Namespaced machines have uniquely-generated methods
# vehicle.alarm_state             # => 1
# vehicle.alarm_state_name        # => :active
#
# vehicle.can_disable_alarm?      # => true
# vehicle.disable_alarm           # => true
# vehicle.alarm_state             # => 0
# vehicle.alarm_state_name        # => :off
# vehicle.can_enable_alarm?       # => true
#
# vehicle.alarm_off?              # => true
# vehicle.alarm_active?           # => false
#
# # Events can be fired in parallel
# vehicle.fire_events(:shift_down, :enable_alarm) # => true
# vehicle.state_name                              # => :first_gear
# vehicle.alarm_state_name                        # => :active
#
# vehicle.fire_events!(:ignite, :enable_alarm)    # => StateMachine::InvalidTransition: Cannot run events in parallel: ignite, enable_alarm
#
# # Human-friendly names can be accessed for states/events
# Vehicle.human_state_name(:first_gear)               # => "first gear"
# Vehicle.human_alarm_state_name(:active)             # => "active"
#
# Vehicle.human_state_event_name(:shift_down)         # => "shift down"
# Vehicle.human_alarm_state_event_name(:enable)       # => "enable"
#
# # States / events can also be references by the string version of their name
# Vehicle.human_state_name('first_gear')              # => "first gear"
# Vehicle.human_state_event_name('shift_down')        # => "shift down"
#
# # Available transition paths can be analyzed for an object
# vehicle.state_paths                                       # => [[#<StateMachine::Transition ...], [#<StateMachine::Transition ...], ...]
# vehicle.state_paths.to_states                             # => [:parked, :idling, :first_gear, :stalled, :second_gear, :third_gear]
# vehicle.state_paths.events                                # => [:park, :ignite, :shift_up, :idle, :crash, :repair, :shift_down]
#
# # Find all paths that start and end on certain states
# vehicle.state_paths(:from => :parked, :to => :first_gear) # => [[
#                                                           #       #<StateMachine::Transition attribute=:state event=:ignite from="parked" ...>,
#                                                           #       #<StateMachine::Transition attribute=:state event=:shift_up from="idling" ...>
#                                                           #    ]]
# # Skipping state_machine and writing to attributes directly
# vehicle.state = "parked"
# vehicle.state                   # => "parked"
# vehicle.state_name              # => :parked
#
# # *Note* that the following is not supported (see StateMachine::MacroMethods#state_machine):
# # vehicle.state = :parked

class Vehicle
  attr_accessor :seatbelt_on, :time_used, :auto_shop_busy

  state_machine :state, :initial => :parked do
    before_transition :parked => any - :parked, :do => :put_on_seatbelt

    after_transition :on => :crash, :do => :tow
    after_transition :on => :repair, :do => :fix
    after_transition any => :parked do |vehicle, transition|
      vehicle.seatbelt_on = false
    end

    after_failure :on => :ignite, :do => :log_start_failure

    around_transition do |vehicle, transition, block|
      start = Time.now
      block.call
      vehicle.time_used += Time.now - start
    end

    event :park do
      transition [:idling, :first_gear] => :parked
    end

    event :ignite do
      transition :stalled => same, :parked => :idling
    end

    event :idle do
      transition :first_gear => :idling
    end

    event :shift_up do
      transition :idling => :first_gear, :first_gear => :second_gear, :second_gear => :third_gear
    end

    event :shift_down do
      transition :third_gear => :second_gear, :second_gear => :first_gear
    end

    event :crash do
      transition all - [:parked, :stalled] => :stalled, :if => lambda {|vehicle| !vehicle.passed_inspection?}
    end

    event :repair do
      # The first transition that matches the state and passes its conditions
      # will be used
      transition :stalled => :parked, :unless => :auto_shop_busy
      transition :stalled => same
    end

    state :parked do
      def speed
        0
      end
    end

    state :idling, :first_gear do
      def speed
        10
      end
    end

    state all - [:parked, :stalled, :idling] do
      def moving?
        true
      end
    end

    state :parked, :stalled, :idling do
      def moving?
        false
      end
    end
  end

  state_machine :alarm_state, :initial => :active, :namespace => 'alarm' do
    event :enable do
      transition all => :active
    end

    event :disable do
      transition all => :off
    end

    state :active, :value => 1
    state :off, :value => 0
  end

  def initialize
    @seatbelt_on = false
    @time_used = 0
    @auto_shop_busy = true
    super() # NOTE: This *must* be called, otherwise states won't get initialized
  end

  def put_on_seatbelt
    @seatbelt_on = true
  end

  def passed_inspection?
    false
  end

  def tow
    # tow the vehicle
  end

  def fix
    # get the vehicle fixed by a mechanic
  end

  def log_start_failure
    # log a failed attempt to start the vehicle
  end
end