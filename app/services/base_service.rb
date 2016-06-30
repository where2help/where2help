class BaseService
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError, "call method not implemented for #{self.class}"
  end
end
