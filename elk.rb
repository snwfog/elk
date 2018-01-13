require 'celluloid/current'
require 'benchmark'
require 'faker'
require 'redis'
require 'connection_pool'
require 'securerandom'
require 'active_support/core_ext/numeric/time'
require 'cassandra'

module Elk
  class ActorBase
    PAGE_VIEW  = 'page_view'.freeze
    LAST_VISIT = 'last_visit'.freeze
    VISITOR    = 'visitor'.freeze

    # t1_pool redis
    # t2_pool cassandra
    attr_reader :t1_pool
    attr_reader :t2_pool

    def initialize(t1_pool, t2_pool)
      @t1_pool = t1_pool
      @t2_pool = t2_pool
    end
  end
end

require_relative './actors/butler'
require_relative './actors/collector'

module Elk
  class ButlerSupervisor < Celluloid::Supervision::Container
  end
end

