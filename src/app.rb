require_relative "view/ruby2d" # Permite inlcuir otros archivos de Ruby
require_relative "model/state"
require_relative "actions/actions"


class App
    def initialize
        @state = Model::initial_state
    end
    def start
       puts "Starting game"
       @view = View::Ruby2dView.new(self)       
       timer_thread= Thread.new { init_timer }
       @view.start(@state)
       timer_thread.join       
       
    end
    def init_timer
        loop do 
            #Trigger movement
            if @state.game_finished
                puts "Game Over"
                puts "Points: #{@state.snake.positions.length}"
                break
            end
            @state=Actions::move_snake(@state)
            @view.render(@state)
            sleep 0.5            
        end
    end
    def send_action(action, params)
       # :change_direction,Model::Direction::RIGTH
        new_state=  Actions.send(action, @state, params)
        if new_state.hash != @state.hash
            @state = new_state
            @view.render(@state)
        end
        
    end
end

app = App.new
app.start