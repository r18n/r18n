module Slice
  class Main < Merb::Controller
    controller_for_slice
    def index
      render i18n.slice + ' and ' + i18n.app
    end
  end
end
