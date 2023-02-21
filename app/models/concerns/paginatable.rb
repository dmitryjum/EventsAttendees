# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginate, lambda { |params = {}|
      response = { records: self, entries_count: count, pages_per_limit: 1, page: 1 }
      unless params[:per_page].nil? && params[:page].nil?
        per_page = params[:per_page].nil? ? 9 : params[:per_page].to_i
        response[:page] = params[:page].nil? ? 1 : params[:page].to_i
        response[:pages_per_limit] = response[:entries_count] / per_page + 1
        response[:records] = if response[:entries_count] <= per_page
                               all
                             else
                               offset((response[:page] - 1) * per_page).limit(per_page)
                             end
        response
      end
      response
    }
  end
end
