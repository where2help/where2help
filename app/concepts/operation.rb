class Operation
  attr_reader :model

  def self.call(params = {})
    op = new
    op.process(params)
    op
  end

  def process(_params)
    raise NotImplementedError, "Need to implement the #process method in inherited classes"
  end

  def self.present(params = {})
    op = new
    op.setup_model!(params)
    op
  end

  def setup_model!(params)
    # noop
  end
end
