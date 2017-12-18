# frozen_string_literal: true

module Eminent
  module Json
    class Resource
      module DSL
        def self.extended(klass)
          class << klass
            attr_accessor :id_val, :id_block, :type_val, :meta_val, :attribute_blocks
            attr_accessor :before_blocks, :after_blocks
          end

          klass.attribute_blocks = {}
          klass.before_blocks    = []
          klass.after_blocks     = []
        end

        def inherited(klass)
          klass.id_val           = id_val
          klass.id_block         = id_block
          klass.type_val         = type_val
          klass.meta_val         = meta_val
          klass.before_blocks    = before_blocks.dup
          klass.after_blocks     = after_blocks.dup
          klass.attribute_blocks = attribute_blocks.dup
        end

        # @overload before(value)
        #   Run code before any attributes are ran
        #
        # @example
        #   before :run_code
        #
        #   attribute :name     #=> foo
        #
        #   def run_code
        #     @object.name = "foo"
        #   end
        #
        # @overload before(&block)
        #   Run code before any attributes are ran
        #
        #   @example
        #     before { @object.name = "foo"}
        #
        #     attribute :name    #=> foo
        #
        def before(*hooks, &block)
          hooks << block if block
          hooks.each { |hook| before_blocks.unshift(hook) }
        end

        # @overload before(value)
        #   Runs code after all attributes have been processed
        #
        # @example
        #   after :run_code
        #
        #   def run_code
        #     print "foo"
        #   end
        #
        # @overload before(&block)
        #   Runs code after all attributes have been processed
        #
        #   @example
        #     after { print "foo" }
        #
        def after(*hooks, &block)
          hooks << block if block
          hooks.each { |hook| after_blocks.unshift(hook) }
        end

        # Explicitly declare the id the model
        #
        # @example
        #   id { @object.id.to_s }
        #  or
        #   id '1'
        def id(value = nil, &block)
          self.id_val   = value if value
          self.id_block = block
        end

        # @overload type(value)
        #   Defines what type of resource this is
        #   @param [String] value The value of the type.
        #
        #   @example
        #     type 'users'
        #
        # @overload type(&block)
        #   Defines what type of resource this is
        #   @yieldreturn [String] The value of the type.
        #
        #   @example
        #     type { @object.type }
        def type(value = nil, &block)
          self.type_val = evaluate(value, &block)&.to_sym
        end

        # Declare an attribute for this resource.
        #
        # @param [Symbol] name The key of the attribute.
        # @yieldreturn [Hash, String, nil] The block to compute the value.
        #
        # @example
        #   attribute(:name) { @object.name }
        #
        def attribute(name, _options = {}, &block)
          block ||= proc { @object.public_send(name) }
          attribute_blocks[name.to_sym] = block
        end

        # Declare a list of attributes for this resource.
        #
        # @param [Array] *args The attributes keys.
        #
        # @example
        #   attributes :title, :body, :date
        #
        def attributes(*args)
          args.each { |attr| attribute(attr) }
        end

        # @overload meta(value)
        #   Declare the meta information for this resource.
        #   @param [Hash] value The meta information hash.
        #
        #   @example
        #     meta key: value
        #
        # @overload meta(&block)
        #   Declare the meta information for this resource.
        #   @yieldreturn [String] The meta information hash.
        #   @example
        #     meta do
        #       { key: value }
        #     end
        def meta(value = nil, &block)
          self.meta_val = evaluate(value, &block)
        end

        private

        def evaluate(value, &block)
          return unless value || block
          value ? value : instance_eval(&block)
        end
      end
    end
  end
end
