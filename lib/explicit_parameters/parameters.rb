require 'virtus'
require 'active_model'

module ExplicitParameters
  class Parameters
    include Virtus.model
    include ActiveModel::Validations
    include Enumerable

    class CoercionValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.validate_attribute_coercion!(attribute, value)
      end
    end

    class RequiredValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.validate_attribute_provided!(attribute, value)
      end
    end

    class << self
      def parse!(params)
        new(params).validate!
      end

      def define(name = nil, &block)
        name_class(Class.new(self, &block), name)
      end

      def requires(name, type = nil, options = {}, &block)
        accepts(name, type, options.merge(required: true), &block)
      end

      def accepts(name, type = nil, options = {}, &block)
        if block_given?
          subtype = define(name, &block)
          if type == Array
            type = Array[subtype]
          elsif type == nil
            type = subtype
          else
            raise ArgumentError, "`type` argument can only be `nil` or `Array` when a block is provided"
          end
        end
        attribute(name, type, options.slice(:default, :required))
        validations = options.except(:default)
        validations[:coercion] = true
        validates(name, validations)
      end

      def optional_attributes
        @optional_attributes ||= []
      end

      private

      def name_class(klass, name)
        if name.present?
          name = name.to_s.camelize
          klass.singleton_class.send(:define_method, :name) { name }
        end
        klass
      end
    end

    def initialize(attributes = {})
      @original_attributes = attributes.stringify_keys
      super
    end

    def validate!
      raise InvalidParameters.new({errors: errors}.to_json) unless valid?
      self
    end

    def validate_attribute_provided!(attribute_name, value)
      if !@original_attributes.key?(attribute_name.to_s)
        errors.add attribute_name, 'is required'
      elsif attribute_set[attribute_name].type.primitive == Array && value == [].freeze
        errors.add attribute_name, 'is required'
      end
    end

    def validate_attribute_coercion!(attribute_name, value)
      return unless @original_attributes.key?(attribute_name.to_s)
      attribute = attribute_set[attribute_name]
      return if value.nil? && !attribute.required?
      return if attribute.value_coerced?(value)
      errors.add attribute_name, "#{@original_attributes[attribute_name].inspect} is not a valid #{attribute.type.name.demodulize}"
    end

    def to_hash
      super.except(*missing_attributes)
    end

    delegate :each, :stringify_keys, to: :to_hash
    delegate :[], to: :@original_attributes

    private

    def missing_attributes
      @missing_attributes ||= (attribute_set.map(&:name).map(&:to_s) - @original_attributes.keys).map(&:to_sym)
    end
  end
end
