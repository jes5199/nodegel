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
    if now - @timestamp < 1.hour
      fives = (((now - @timestamp) / 60).to_i / 5) * 5
      return fives.humanize + " minutes ago"
    end
    if now - @timestamp < 1.day
      hours = (((now - @timestamp) / 60).to_i / 60)
      return hours.humanize + " hours ago"
    end
    if now - @timestamp < 2.days
      return "yesterday"
    end
    if now - @timestamp < 7.days
      return %w[sunday monday tuesday wednesday thursday friday saturday][@timestamp.wday]
    end
    if now - @timestamp < 14.days
      return "last " + %w[sunday monday tuesday wednesday thursday friday saturday][@timestamp.wday]
    end
    if now - @timestamp < 21.days
      return "a couple weeks ago"
    end
    if @timestamp.month == now.month and @timestamp.year == now.year
      return "at the beginning of this month"
    end
    if @timestamp.year == now.year
      return "in " + %w[january february march april may june july august september october november december][@timestamp.month]
    end
    if @timestamp.year == now.year - 1 and @timestamp.month >= now.month
      return "last " + %w[january february march april may june july august september october november december][@timestamp.month]
    end
    return "in " + %w[january february march april may june july august september october november december][@timestamp.month] + " of " + @timestamp.year.to_s
    return "sometime ago"
  end
end
