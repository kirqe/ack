# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Suspendable, type: :concern do
  it 'suspends/resumes' do
    user = create(:user)
    expect(user.suspended?).to be_falsey

    user.suspend!
    expect(user.suspended?).to be_truthy
    expect(user.suspended_till.utc.to_s).to eq((DateTime.now + 1.day).utc.to_s)

    user.suspend!(3)
    expect(user.suspended?).to be_truthy
    expect(user.suspended_till.utc.to_s).to eq((DateTime.now + 3.day).utc.to_s)

    user.resume!
    expect(user.suspended?).to be_falsey
  end

  it 'scopes' do
    create(:user)
    create(:user).suspend!
    create(:user)

    expect(User.suspended.count).to eq(1)
  end
end
