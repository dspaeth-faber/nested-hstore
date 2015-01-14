require 'spec_helper'

describe ActiveRecord::Coders::NestedHstore do
  class Post < ActiveRecord::Base
    serialize :properties, ActiveRecord::Coders::NestedHstore
  end

  before :all do
    CreatePosts.up
  end

  after :all do
    CreatePosts.down
  end

  describe "dumping and loading" do
    context "with a nested hash" do
      let(:value) { { 'foo' => { 'bar' => 'baz' } } }
      
      it "preserves the value" do
        post = Post.new(properties: value)
        post.save!
        post.reload
        post.properties.should == value
      end
    end

    context "with a nested array" do
      let(:value) { { 'foo' => { 'bar' => 'baz' } } }

      it "preserves the value" do
        post = Post.new
        post.attributes = { properties:{"a"=>[{"b"=>"c"}], "d"=>"e"} }
        post.save!

        loaded_post = Post.find post.id
        loaded_post.attributes = { properties: {"a"=>[{"b"=>"c", "h" => "j"}], "d"=>"e"} }

        loaded_post.save!

        loaded_post = Post.find post.id

        expect(loaded_post.properties).to eq({"a"=>[{"b"=>"c", "h" => "j"}], "d"=>"e"})
      end
    end
  end
end
