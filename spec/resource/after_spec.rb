# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.after' do
  let(:object) { User.new(name: 'John') }
  let(:resource) { klass.new(object: object) }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        after { @object.name = 'foo' }

        attribute :name
      end
    end

    it 'should not change the name of the object before processing' do
      expect(resource.as_hash[:attributes]).to eq(name: 'John')
    end
  end

  context 'Symbol value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        after :change_object_name

        attribute :name

        def change_object_name
          @object.name = 'foo'
        end
      end
    end

    it 'should not change the name of the object before processing' do
      expect(resource.as_hash[:attributes]).to eq(name: 'John')
    end
  end

  context 'Printing logs' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        after { print 'foo' }
      end
    end

    it 'Should raise an exception' do
      expect { resource }.to output('foo').to_stdout
    end
  end
end
