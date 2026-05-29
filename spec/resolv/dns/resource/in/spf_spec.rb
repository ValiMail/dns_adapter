require 'spec_helper'

describe Resolv::DNS::Resource::IN::SPF do
  it 'uses the DNS SPF resource type value' do
    expect(described_class::TypeValue).to eq(99)
  end

  it 'inherits TXT record behavior' do
    record = described_class.new('v=spf1 ', '-all')

    expect(record.strings).to eq(['v=spf1 ', '-all'])
  end
end
