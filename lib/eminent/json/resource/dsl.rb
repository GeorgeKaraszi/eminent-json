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

        def before(*hooks, &block)
          hooks << block if block
          hooks.each { |hook| before_blocks.unshift(hook) }
        end

        def after(*hooks, &block)
          hooks << block if block
          hooks.each { |hook| after_blocks.unshift(hook) }
        end

        def id(value = nil, &block)
          self.id_val   = value if value
          self.id_block = block
        end

        def type(value = nil, &block)
          self.type_val = evaluate(value, &block)&.to_sym
        end

        def attribute(name, _options = {}, &block)
          block ||= proc { @object.public_send(name) }
          attribute_blocks[name.to_sym] = block
        end

        def attributes(*args)
          args.each { |attr| attribute(attr) }
        end

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
