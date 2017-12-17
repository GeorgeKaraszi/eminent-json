# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.meta' do
  let(:object) { User.new }
  let(:resource) { klass.new(object: object) }

  subject { resource.as_hash[:meta] }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        meta do
          { foo: 'bar' }
        end
      end
    end

    it { is_expected.to eq(foo: 'bar') }
  end

  context 'accepts value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        meta foo: 'bar'
      end
    end

    it { is_expected.to eq(foo: 'bar') }
  end

  context 'when no value is supplied' do
    let(:klass) { Class.new(Eminent::Json::Resource) }

    it { is_expected.to be_nil }
  end
end
