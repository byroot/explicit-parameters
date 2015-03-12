module ExplicitParameters
  module Controller
    extend ActiveSupport::Concern

    Boolean = Axiom::Types::Boolean

    class << self
      attr_accessor :last_parameters
    end

    included do
      rescue_from ExplicitParameters::InvalidParameters, with: :render_parameters_error
    end

    module ClassMethods
      attr_accessor :parameters

      def method_added(action)
        return unless Controller.last_parameters
        self.parameters ||= {}
        parameters[action.to_s] = Controller.last_parameters
        const_set("#{action.to_s.camelize}Parameters", Controller.last_parameters)
        Controller.last_parameters = nil
      end

      def params(&block)
        Controller.last_parameters = ExplicitParameters::Parameters.define(&block)
      end

      def parse_parameters_for(action_name, params)
        if declaration = parameters.try!(:[], action_name)
          declaration.parse!(params)
        else
          params
        end
      end
    end

    def params
      @validated_params ||= self.class.parse_parameters_for(action_name, super)
    end

    private

    def param_error!(parameter, error)
      raise ExplicitParameters::InvalidParameters.new({errors: {parameter => [error]}}.to_json)
    end

    def render_param_error(parameter, error)
      render json: {errors: {parameter => [error]}}, status: :unprocessable_entity
    end

    def render_parameters_error(error)
      render json: error.message, status: :unprocessable_entity
    end
  end
end
