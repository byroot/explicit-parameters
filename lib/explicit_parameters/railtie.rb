module ExplicitParameters
  class Railtie < ::Rails::Railtie
    initializer 'explicit_parameters.controller' do
      ActiveSupport.on_load(:action_controller) do
        include ExplicitParameters::Controller
      end
    end
  end
end
