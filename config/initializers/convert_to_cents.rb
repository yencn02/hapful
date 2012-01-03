class Numeric
  def to_cents
    (self.to_f * 100).round
  end
end