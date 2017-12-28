# frozen_string_literal: true

require 'eminent/json/version'

module Eminent
  module Json
    require 'eminent/json/resource'
    require 'eminent/json/renderer'

    def self.resources_for(objects, options, inferrer)
      return if objects.nil?

      if objects.respond_to?(:to_ary)
        Array(objects).map do |object|
          resource_for(object, options, inferrer)
        end
      else
        resource_for(objects, options, inferrer)
      end
    end

    def self.resource_for(object, options, inferrer)
      class_name     = object.class.name.to_sym
      jsonable_klass = inferrer[class_name]
      jsonable_klass.new(options.merge(object: object))
    end
  end
end
