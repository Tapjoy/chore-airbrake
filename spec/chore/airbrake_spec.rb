require 'spec_helper'
require 'airbrake'

describe Chore do
  
  class TestException < StandardError ; end

  Airbrake.configure do |config|
    config.api_key = "something"
  end

  $test_msg = {"class"=> "TestJob", "args" => {"message"=> "test message"} }
  
  describe "airbrake failure callback" do
    let(:worker) { double('worker', :work => [work]) }
    let(:work) { Chore::UnitOfWork.new(1,'test',60,$test_msg,0,nil) }

    before(:all) do 
      # tests run in random order so we can only check the require
      # loading in before all
      Chore.respond_to?(:airbrake).should == false
      Chore.hooks_for(:on_failure).should be_empty
      # hook it up
      require 'chore/airbrake'
      
      Chore.respond_to?(:airbrake).should == true
      Chore.hooks_for(:on_failure).should_not be_empty
    end
    after(:each) do 
      Chore.airbrake.options = {}
    end

    # These are the airbrake options we send by default
    # This is implemented in chore/airbrake
    def get_default_airbrake_options
      expected_options = {}
      # should be set by the class of the message
      expected_options[:action] = "TestJob"
      expected_options[:parameters] = {:message => $test_msg}
      expected_options[:component] = "chore"
      expected_options
    end


    it "should send an airbrake exception if chore/airbrake as been required" do
      expected_options = get_default_airbrake_options
      Airbrake.should_receive(:notify).with(kind_of(RuntimeError), expected_options)
      Chore.run_hooks_for(:on_failure, $test_msg, RuntimeError.new("exception"))
    end
    
    it 'should send an airbrake exception on fork failures if chore/airbrake has been required' do
      expected_options = get_default_airbrake_options.merge(
        :action => 'Unknown message class',
        :parameters => {:message => {:body => 'Error within fork.', :messages => [$test_msg]}}
      )
      Airbrake.should_receive(:notify).with(kind_of(RuntimeError), expected_options)
      lambda do
        Chore.run_hooks_for(:within_fork, worker) do
          raise RuntimeError, "exception"
        end
      end.should raise_error(RuntimeError)
    end

    it "should accept options modified by Chore.airbrake" do 
      # app can send arbitrary options to airbrake through options wrapper
      additional_airbrake_options = {:test_param => "test value"}
      Chore.airbrake.options = additional_airbrake_options
      
      expected_options = get_default_airbrake_options
      expected_options = expected_options.merge(additional_airbrake_options)
      
      Airbrake.should_receive(:notify).with(kind_of(RuntimeError), expected_options)
      Chore.run_hooks_for(:on_failure, $test_msg, RuntimeError.new("exception"))
    end

  end
end
