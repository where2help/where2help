class Command
  def self.call(params = {})
    op = new
    op.process(params)
  end

  def process(_params)
    raise NotImplementedError, "Need to implement the #process method in inherited classes"
  end
end
