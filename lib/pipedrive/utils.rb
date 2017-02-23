module Pipedrive
  module Utils
    extend ActiveSupport::Concern

    def follow_pagination(method, args, params)
      start = params[:start] || 0
      loop do
        res = __send__(method, *args, params.merge(start: start))
        break if !res.try(:data) || !res.success?
        res.data.each do |item|
          yield item
        end
        break unless res.try(:additional_data).try(:pagination).try(:more_items_in_collection?)
        start = res.try(:additional_data).try(:pagination).try(:next_start)
      end
    end

    def unfollow_pagination(method, args, params)
      start = params[:start] || 0
      res = __send__(method, *args, params.merge(start: start))
    end
  end
end
