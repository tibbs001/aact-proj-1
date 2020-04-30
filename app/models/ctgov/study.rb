module Ctgov
  class Study < CtgovBase
    after_initialize :readonly!
  end
end
