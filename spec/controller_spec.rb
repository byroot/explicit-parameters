require 'spec_helper'

class DummyController < ActionController::Base
  include ExplicitParameters::Controller

  params do
    accepts :page_size, Integer
    accepts :published, Boolean, default: false
  end
  def index
    render json: {value: params.page_size, type: params.page_size.class.name}
  end

  def error
    param_error!(:page_size, "Out of bound")
    render body: 'OK'
  end

  def no_declaration
    render body: 'OK'
  end

end

RSpec.describe DummyController do
  it 'is optional' do
    get :no_declaration
    expect(response.code).to be == '200'
  end

  it 'coerce parameters to the required type' do
    get :index, page_size: '42'
    expect(json_response).to be == {value: 42, type: 'Fixnum'}
  end

  it 'returns a 422 if parameters are invalid' do
    get :index, page_size: 'foobar'
    expect(response.code).to be == '422'
  end

  it 'returns the list of errors if parameters are invalid' do
    get :index, page_size: 'foobar'
    expect(json_response).to be == {errors: {page_size: ['"foobar" is not a valid Integer']}}
  end

  it 'param_error! interupt the request immediately' do
    get :error
    expect(json_response).to be == {errors: {page_size: ['Out of bound']}}
  end

  private

  attr_reader :response

  def json_response
    JSON.load(response.body).deep_symbolize_keys
  end

  def get(action, parameters = {})
    request(action, 'GET', query: parameters)
  end

  if ActionController::Base.instance_method(:dispatch).arity > 2
    def request(action, method, query: {}, body: '')
      request = ActionDispatch::Request.new(
        'REQUEST_METHOD' => method,
        'QUERY_STRING' => query.to_query,
        'rack.input' => StringIO.new(body)
      )
      @response = ActionDispatch::Response.create.tap do |res|
        res.request = request
      end
      subject.dispatch(action, request, @response)
    end
  else
    def request(action, method, query: {}, body: '')
      rack_response = subject.dispatch(action, ActionDispatch::Request.new(
        'REQUEST_METHOD' => method,
        'QUERY_STRING' => query.to_query,
        'rack.input' => StringIO.new(body)
      ))
      @response = ActionDispatch::Response.new(*rack_response)
    end
  end
end
