# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.before' do
  let(:object) { User.new(name: 'John') }
  let(:resource) { klass.new(object: object) }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        before do
          @object.name = 'foo'
        end

        attribute :name
      end
    end

    it 'should change the name of the object before processing' do
      expect(resource.as_hash[:attributes]).to eq(name: 'foo')
    end
  end

  context 'Symbol value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        before :change_object_name

        attribute :name

        def change_object_name
          @object.name = 'foo'
        end
      end
    end

    it 'should change the name of the object before processing' do
      expect(resource.as_hash[:attributes]).to eq(name: 'foo')
    end
  end

  context 'Defining new global values' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        before { @new_object = 'foo' }

        attribute(:name) { @new_object }
      end
    end

    it 'return the name as defined by the new global value' do
      expect(resource.as_hash[:attributes]).to eq(name: 'foo')
    end
  end

  context 'Accessing exposures' do
  end
end
