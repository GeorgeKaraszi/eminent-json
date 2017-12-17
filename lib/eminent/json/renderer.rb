# frozen_string_literal: true

module Eminent
  module Json
    class Renderer
      def render(resources, options)
        options   = options.dup
        klass     = options.delete(:class) || {}
        exposures = options.delete(:expose) || {}
        exposures = exposures.merge(_class: klass)
        resource  = Eminent::Json.resources_for(resources, exposures, klass)
        { data: resource }
      end
    end
  end
end
