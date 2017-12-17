# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.type' do
  let(:object) { User.new }
  let(:resource) { klass.new(object: object) }

  subject { resource.as_hash[:type] }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        type { 'foo' }
      end
    end

    it { is_expected.to eq(:foo) }
  end

  context "Symbolize's string value" do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        type 'foo'
      end
    end

    it { is_expected.to eq(:foo) }
  end

  context 'When no value is set' do
    let(:klass) { Class.new(Eminent::Json::Resource) }
    it { is_expected.to eq(:unknown) }
  end
end
