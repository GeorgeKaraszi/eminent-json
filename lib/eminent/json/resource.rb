# frozen_string_literal: true

require 'eminent/json/resource/dsl'

module Eminent
  module Json
    class Resource
      extend DSL

      id { @object.id.to_s if @object.respond_to?(:id) }

      # rubocop:disable Metrics/AbcSize
      def initialize(exposures = {})
        exposures.each { |k, v| instance_variable_set("@#{k}", v) }
        @_exposures = exposures
        @_id        = (self.class.id_block ? instance_eval(&self.class.id_block) : self.class.id_val).to_s
        @_type      = self.class.type_val || :unknown
        @_meta      = self.class.meta_val
        freeze
      end
      # rubocop:enable Metrics/AbcSize

      def as_hash
        attrs = requested_attributes.each_with_object({}) do |(k, v), h|
          h[k] = instance_eval(&v)
        end

        {}.tap do |hash|
          hash[:type]       = @_type
          hash[:id]         = @_id   unless @_id.empty?
          hash[:attributes] = attrs  unless attrs.empty?
          hash[:meta]       = @_meta unless @_meta.nil?
        end
      end
      alias to_h    as_hash
      alias to_hash as_hash

      private

      def requested_attributes
        self.class.attribute_blocks
      end
    end
  end
end
