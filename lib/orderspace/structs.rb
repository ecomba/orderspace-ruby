# frozen_string_literal: true

module Orderspace
  module Structs
    def self.from(json, struct)
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
          elsif new_object.respond_to? method_name
            new_object.send(method_name.to_sym, value)
          end
        end
      end
    end

    def self.hashify(struct)
      hash_dump(struct)
    end

    def self.validate(struct)
      validator = eval(struct.class.to_s + 'Validator')
      validator.validate(struct)
    end

    private

    def self.address?(key)
      key.eql?('shipping_address') || key.eql?('billing_address')
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
        Orderspace::Structs.from(data, class_eval("Orderspace::Structs::#{clazz}", __FILE__, __LINE__))
      end)
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
require_relative 'struct/oauth_credentials'
require_relative 'struct/order'
require_relative 'struct/webhook'
