# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Approvable, type: :concern do
  it 'publish/unpublish' do
    board = create(:board)
    expect(board.approved?).to be_falsey

    board.approve!
    expect(board.approved?).to be_truthy
    expect(board.rejected?).to be_falsey

    board.reject!
    expect(board.approved?).to be_falsey
    expect(board.rejected?).to be_truthy

    board.reset!
    expect(board.approved?).to be_falsey
    expect(board.rejected?).to be_falsey
    expect(board.pending?).to be_truthy
  end

  it 'scopes' do
    create(:board).approve!
    create(:board).approve!
    create(:board).reject!
    create(:board)

    expect(Board.approved.count).to eq(2)
    expect(Board.rejected.count).to eq(1)
    expect(Board.pending.count).to eq(1)
  end
end
