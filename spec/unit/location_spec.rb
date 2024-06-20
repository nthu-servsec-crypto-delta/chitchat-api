# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test location' do
  it 'HAPPY: should return the correct distance between two location' do
    l1 = ChitChat::Location.new(latitude: 46.3625, longitude: 15.114444)
    l2 = ChitChat::Location.new(latitude: 46.055556, longitude: 14.508333)
    _(l1.distance_to(l2)).must_be_close_to 57_794.355108740354
  end
end
