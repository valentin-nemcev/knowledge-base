class ReviewGrade < ClassyEnum::Base
end

class ReviewGrade::Easy < ReviewGrade
  def number
    4
  end
end

class ReviewGrade::Good < ReviewGrade
  def number
    3
  end
end

class ReviewGrade::Hard < ReviewGrade
  def number
    2
  end
end

class ReviewGrade::Again < ReviewGrade
  def number
    1
  end
end
