# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.id' do
  let(:object) { User.new(id: 1) }
  let(:resource) { klass.new(object: object) }

  subject { resource.as_hash[:id] }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        id { 1 }
      end
    end

    it { is_expected.to eq('1') }
  end

  context 'accepts string values' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        id 'new-id'
      end
    end

    it { is_expected.to eq('new-id') }
  end

  context 'accepts number values and converts to string' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        id 9999
      end
    end

    it { is_expected.to eq('9999') }
  end

  context 'when no value is supplied' do
    let(:klass) { Class.new(Eminent::Json::Resource) }

    context 'When the object has an id method' do
      it { is_expected.to eq(object.id.to_s) }
    end

    context 'When the object has no id method' do
      let!(:object) { User.new }
      it { is_expected.to be_nil }
    end
  end
end
