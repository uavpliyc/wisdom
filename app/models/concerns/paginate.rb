module Paginate
  extend ActiveSupport::Concern
  include Kaminari::PageScopeMethods

  included do
    scope :paginate, -> (p){ page(p[:page]).per(10).order("created_at DESC") }  #引数を(paramsではなく)pとすることで、scopeを使える
  end
end