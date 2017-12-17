# frozen_string_literal: true

require 'eminent/json/resource/dsl'

module Eminent
  module Json
    class Resource
      extend DSL

      id { @object.id.to_s if @object.respond_to?(:id) }

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def initialize(exposures = {})
        exposures.each { |k, v| instance_variable_set("@#{k}", v) }
        @_exposures = exposures

        with_hooks do
          @_id   = (self.class.id_block ? instance_eval(&self.class.id_block) : self.class.id_val).to_s
          @_type = self.class.type_val || :unknown
          @_meta = self.class.meta_val
          @_attrs = requested_attributes.each_with_object({}) do |(k, v), h|
            h[k] = instance_eval(&v)
          end
        end

        freeze
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def as_hash
        {}.tap do |hash|
          hash[:type]       = @_type
          hash[:id]         = @_id     unless @_id.empty?
          hash[:attributes] = @_attrs  unless @_attrs.empty?
          hash[:meta]       = @_meta   unless @_meta.nil?
        end
      end
      alias to_h    as_hash
      alias to_hash as_hash

      private

      def with_hooks
        run_before_blocks
        yield
        run_after_blocks
      end

      def requested_attributes
        self.class.attribute_blocks
      end

      def run_before_blocks
        run_hooks(self.class.before_blocks)
      end

      def run_after_blocks
        run_hooks(self.class.after_blocks)
      end

      def run_hooks(hooks)
        hooks.each { |hook| run_hook(hook) }
      end

      def run_hook(hook)
        hook.is_a?(Symbol) ? send(hook) : instance_eval(&hook)
      end
    end
  end
end
