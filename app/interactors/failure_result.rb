class FailureResult
  attr_reader :payload, :error

  def initialize(error)
    @payload = nil
    @error = error
  end

  def success?
    false
  end

  def failure?
    true
  end
end
