require 'spec_helper'

describe DNSAdapter::ResolvNsClient do
  describe '#dns_resolver' do
    it 'builds a resolver that uses Cloudflare nameservers without search domains' do
      resolver = instance_double(Resolv::DNS)

      expect(Resolv::DNS).to receive(:new).with(
        nameserver: DNSAdapter::CLIENT_NAMESERVERS,
        search: [],
        ndots: 1
      ).and_return(resolver)

      expect(described_class.new.send(:dns_resolver)).to eq(resolver)
    end
  end
end
