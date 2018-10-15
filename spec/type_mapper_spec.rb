require "spec_helper"

RSpec.describe TypeMapper do
  class TestSubject < TypeMapper
    def_mapping(Fixnum) { |i| i + 1 }
    def_mapping(Numeric) { |n| n * 2.0 }
    def_mapping(String, Symbol) { |s| s.to_s }
    def_mapping(Array) do |array|
      array.map { |value| map(value) }
    end
  end

  subject { TestSubject.new }

  it 'chooses a mapping based on the type of the value' do
    expect(subject.(5)).to eq(6)
  end

  it 'chooses the closest mapping based on inheritance, if no direct mapping is found' do
    expect(subject.(4.0)).to eq(8.0)
  end

  it 'maps composite values' do
    expect(subject.([1, 2.0, :three])).to eq([2, 4.0, 'three'])
  end

  it 'maps multiple types with the same block' do
    expect(subject.('string')).to eq('string')
    expect(subject.(:sym)).to eq('sym')
  end

  it 'raises a nice exception when no mapping is found' do
    expect { subject.({}) }.to raise_error("No mapping defined for Hash")
  end

  it "has a version number" do
    expect(TypeMapper::VERSION).not_to be nil
  end
end
