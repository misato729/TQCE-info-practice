module MethodReplacement
  private

  def with_method_replacement(object, name, replacement)
    singleton = object.singleton_class
    owned = singleton.instance_methods(false).include?(name)
    original = object.method(name)
    singleton.define_method(name) do |*args, **kwargs, &block|
      replacement.respond_to?(:call) ? replacement.call(*args, **kwargs, &block) : replacement
    end
    yield
  ensure
    if owned
      singleton.define_method(name, original)
    else
      singleton.remove_method(name)
    end
  end
end
