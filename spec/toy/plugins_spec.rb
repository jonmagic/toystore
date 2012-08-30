require 'helper'

describe Toy::Plugins do
  uses_constants('User', 'Game')

  it "keeps track of class that include toy store" do
    Toy.models.should == [User, Game]
  end

  describe ".plugin" do
    before do
      class_methods_mod    = Module.new { def foo; 'foo' end }
      instance_methods_mod = Module.new { def bar; 'bar' end }

      @mod = Module.new { extend ActiveSupport::Concern }
      @mod.const_set(:ClassMethods,    class_methods_mod)
      @mod.send(:include, instance_methods_mod)

      Toy.plugin(@mod)
    end

    it "includes module in all models" do
      [User, Game].each do |model|
        model.foo.should     == 'foo'
        model.new.bar.should == 'bar'
      end
    end

    it "adds plugin to plugins" do
      Toy.plugins.should == [@mod]
    end

    it "adds plugins to classes declared after plugin was called" do
      klass = Class.new { include Toy::Store }
      klass.foo.should     == 'foo'
      klass.new.bar.should == 'bar'
    end
  end
end
