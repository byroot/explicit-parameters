require 'spec_helper'

RSpec.describe ExplicitParameters::Parameters do
  TestParameters = ExplicitParameters::Parameters.define do
    requires :id, Integer, numericality: {greater_than: 0}
    accepts :name, String
    accepts :title, String, default: 'Untitled'
  end

  let :parameters do
    {
      'id' => '42',
      'name' => 'George',
      'unexpected' => 'parameter',
    }
  end

  let(:params) { TestParameters.parse!(parameters.with_indifferent_access) }

  it 'casts parameters to the declared type' do
    expect(params.id).to be == 42
  end

  it 'provides the default if the parameter is missing' do
    expect(params.title).to be == 'Untitled'
  end

  it 'ignores unexpected parameters during iteration' do
    params.each do |name, value|
      expect(name).to_not be == 'unexpected'
    end
  end

  it 'allows access to raw parameters when accessed like a Hash' do
    expect(params[:id]).to be == '42'
    expect(params[:unexpected]).to be == 'parameter'
  end

  it 'can perform any type of active model validations' do
    message = {errors: {id: ['must be greater than 0']}}.to_json
    expect {
      TestParameters.parse!('id' => -1)
    }.to raise_error(ExplicitParameters::InvalidParameters, message)
  end
end
