# frozen_string_literal: true

RSpec.describe Eminent::Json::Resource, '.attribute' do
  let(:object) { User.new(name: 'John') }
  let(:resource) { klass.new(object: object) }

  subject { resource.as_hash[:attributes] }

  context 'Block value' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        attribute(:name) { 'foo' }
      end
    end

    it { is_expected.to eq(name: 'foo') }
  end

  context 'when defining multiple attributes' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        attribute(:name)    { 'foo' }
        attribute(:address) { 'bar' }
      end
    end

    it { is_expected.to eq(name: 'foo', address: 'bar') }
  end

  context 'When no block is supplied' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        attribute(:name)
      end
    end

    it { is_expected.to eq(name: 'John') }
  end

  context 'When no attributes are supplied' do
    let(:klass) { Class.new(Eminent::Json::Resource) }
    it { is_expected.to be_nil }
  end

  context 'Inheriting' do
    let(:klass) do
      Class.new(Eminent::Json::Resource) do
        attribute :name
      end
    end

    let(:subclass) do
      Class.new(klass) do
        attribute(:name) { 'Jenny' }
      end
    end

    it "overrides superclass definition but doesn't modify it" do
      expect(subclass.new(object: object).as_hash[:attributes]).to eq(name: 'Jenny')
      expect(subject).to eq(name: 'John')
    end
  end
end
