require 'spec_helper'

describe DNSAdapter::MockClient do
  subject(:client) { described_class.new(zone_data) }

  let(:zone_data) do
    {
      'Direct.EXAMPLE.COM' => [
        { 'A' => '192.0.2.1' },
        { 'AAAA' => '2001:db8::1' },
        { 'MX' => [10, 'mail.example.com'] },
        { 'MX' => ['mail-only.example.com'] },
        { 'NS' => 'ns1.example.com' },
        { 'TXT' => ['v=spf1 ', '-all'] },
        { 'SPF' => ['v=spf1 ', '~all'] },
        { 'A' => 'NONE' },
        { 'SOA' => 'ns1.example.com' },
        'not a record'
      ],
      'example.com' => [
        { 'CNAME' => 'target.example.com' }
      ],
      'target.example.com' => [
        { 'A' => '198.51.100.1' },
        { 'TXT' => 'target text' }
      ],
      '4.3.2.1.in-addr.arpa' => [
        { 'PTR' => 'ptr.example.com' }
      ],
      'timeout.example.com' => [
        described_class::TIMEOUT
      ],
      'record-timeout.example.com' => [
        { 'A' => described_class::TIMEOUT }
      ]
    }
  end

  describe '#fetch_a_records' do
    it 'normalizes case and trailing dots before returning A records' do
      expect(client.fetch_a_records('DIRECT.EXAMPLE.COM.')).to contain_exactly(
        { type: 'A', address: '192.0.2.1' }
      )
    end

    it 'follows CNAME records for address lookups' do
      expect(client.fetch_a_records('example.com')).to contain_exactly(
        { type: 'A', address: '198.51.100.1' }
      )
    end
  end

  describe '#fetch_aaaa_records' do
    it 'returns AAAA records with address values' do
      expect(client.fetch_aaaa_records('direct.example.com')).to contain_exactly(
        { type: 'AAAA', address: '2001:db8::1' }
      )
    end
  end

  describe '#fetch_mx_records' do
    it 'returns MX records with preference values when provided' do
      expect(client.fetch_mx_records('direct.example.com')).to contain_exactly(
        { type: 'MX', preference: 10, exchange: 'mail.example.com' },
        { type: 'MX', exchange: 'mail-only.example.com' }
      )
    end
  end

  describe '#fetch_ns_records' do
    it 'returns NS records with name values' do
      expect(client.fetch_ns_records('direct.example.com')).to contain_exactly(
        { type: 'NS', name: 'ns1.example.com' }
      )
    end
  end

  describe '#fetch_cname_records' do
    it 'returns CNAME records without following them' do
      expect(client.fetch_cname_records('example.com')).to contain_exactly(
        { type: 'CNAME', name: 'target.example.com' }
      )
    end
  end

  describe '#fetch_txt_records' do
    it 'joins TXT record segments' do
      expect(client.fetch_txt_records('direct.example.com')).to contain_exactly(
        { type: 'TXT', text: 'v=spf1 -all' }
      )
    end
  end

  describe '#fetch_spf_records' do
    it 'joins SPF record segments' do
      expect(client.fetch_spf_records('direct.example.com')).to contain_exactly(
        { type: 'SPF', text: 'v=spf1 ~all' }
      )
    end
  end

  describe '#fetch_ptr_records' do
    it 'returns PTR records with name values' do
      expect(client.fetch_ptr_records('4.3.2.1.in-addr.arpa')).to contain_exactly(
        { type: 'PTR', name: 'ptr.example.com' }
      )
    end
  end

  describe '#fetch_records' do
    it 'returns an empty array when the domain is blank' do
      expect(client.fetch_records('', 'A')).to eq([])
    end

    it 'returns an empty array when the domain is nil' do
      expect(client.fetch_records(nil, 'A')).to eq([])
    end

    it 'returns an empty array when the domain has no records' do
      expect(client.fetch_records('missing.example.com', 'A')).to eq([])
    end

    it 'raises a timeout error for a domain timeout marker' do
      expect { client.fetch_records('timeout.example.com', 'A') }
        .to raise_error(DNSAdapter::TimeoutError)
    end

    it 'raises a timeout error for a record timeout marker' do
      expect { client.fetch_records('record-timeout.example.com', 'A') }
        .to raise_error(DNSAdapter::TimeoutError)
    end
  end

  describe '#raw_records' do
    it 'returns raw matching records without formatting them' do
      expect(client.raw_records('direct.example.com', 'NS')).to contain_exactly(
        { 'NS' => 'ns1.example.com' }
      )
    end
  end

  describe '#normalize_domain' do
    it 'returns nil when the domain is nil' do
      expect(client.send(:normalize_domain, nil)).to be_nil
    end
  end

  describe '#timeouts=' do
    it 'accepts timeout assignments without changing behavior' do
      expect { client.timeouts = 5 }.not_to raise_error
    end
  end
end
