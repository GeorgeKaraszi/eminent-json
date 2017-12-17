# frozen_string_literal: true

require 'eminent/json'

class Model
  def initialize(**params)
    params.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end
end

class User < Model
  attr_accessor :id, :name, :address
end

class JsonableUser < Eminent::Json::Resource
  type 'user'
  attribute :name
  attribute :address
end
