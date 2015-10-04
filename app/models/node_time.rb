class NodeTime
  def initialize(timestamp)
    @timestamp = timestamp
  end

  def to_s
    now = Time.now
    if now - @timestamp < 60
      return "just now"
    end
    if now - @timestamp < 60 * 5
      return "just minutes ago"
    end
    if now - @timestamp < 60 * 60
      fives = ((now - @timestamp) / 5) * 5
      return fives.humanize + " minutes ago"
    end
    return "sometime ago"
  end
end
