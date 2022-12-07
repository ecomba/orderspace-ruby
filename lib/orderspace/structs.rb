# frozen_string_literal: true

module Orderspace
  ##
  # The structs module scopes the structs returned and sent to the Orderspace API
  module Structs
    ##
    # Converts (if possible) a json payload into the desired struct
    # @param json [object] a json object
    # @param struct [Struct] the desired struct
    # @return [Struct] the fully initialized struct
    def self.from(json, struct)
      if json.is_a? Array
        json.collect {|element| assign_values_to_struct(element, struct)}
      else
        assign_values_to_struct(json, struct)
      end
    end

    ##
    # Converts a struct into a hash
    # @param struct [Struct] the struct we want to convert
    # @return [Hash] the hash representation of the struct
    def self.hashify(struct)
      hash_dump(struct)
    end

    ##
    # Used to make sure the struct is valid before it's posted to the server
    # @param struct [Struct] the struct we want to validate
    # @raise [ValidationFailedError] with the error message
    def self.validate(struct)
      validator = eval(struct.class.to_s + 'Validator')
      validator.validate(struct)
    end

    private

    def self.assign_values_to_struct(json, struct)
      struct.new.tap do |new_object|
        json.each do |key, value|
          method_name = "#{key}="
          if value.is_a? Array
            begin
              build_structs(key, method_name, new_object, value)
            rescue
              new_object.send(method_name.to_sym, value)
            end
          elsif address?(key)
            new_object.send(method_name.to_sym, Orderspace::Structs.from(value, Orderspace::Structs::Address))
          elsif data?(key)
            event_struct = assign_values_to_struct(value[value.keys.first], eval_to_struct(value.keys.first.capitalize))
            new_object.send(method_name.to_sym, event_struct)
          elsif new_object.respond_to? method_name
            new_object.send(method_name.to_sym, value)
          end
        end
      end
    end

    def self.address?(key)
      key.eql?('shipping_address') || key.eql?('billing_address')
    end

    def self.data?(key)
      key.eql? 'data'
    end

    def self.hash_dump(struct)
      hash = {}

      struct.members.collect do |member|
        value = extract_value_from(struct, member)
        hash[member.to_sym] = value unless value.nil?
      end
      hash
    end

    def self.build_structs(key, method_name, new_object, value)
      clazz = infer_class(key)
      return unless new_object.respond_to? method_name

      new_object.send(method_name.to_sym, value.map do |data|
        Orderspace::Structs.from(data, eval_to_struct(clazz))
      end)
    end

    def self.eval_to_struct(clazz)
      class_eval("Orderspace::Structs::#{clazz}", __FILE__, __LINE__)
    end

    def self.infer_class(key)
      if key.include? '_'
        clazz = key.chomp('s').split('_').map{|e| e.capitalize}.join
      elsif key.end_with?('es')
        clazz = key.capitalize.chomp('es')
      elsif key.end_with?('s')
        clazz = key.capitalize.chomp('s')
      end
      clazz
    end

    def self.extract_value_from(struct, member)
      if struct.send(member.to_sym).is_a? Array
        begin
          struct.send(member.to_sym).map { |member| hash_dump(member) }
        rescue
          struct.send(member.to_sym)
        end
      else
        struct.send(member.to_sym)
      end
    end
  end
end

require_relative 'struct/address'
require_relative 'struct/buyer'
require_relative 'struct/customer'
require_relative 'struct/event'
require_relative 'struct/oauth_credentials'
require_relative 'struct/order'
require_relative 'struct/webhook'
