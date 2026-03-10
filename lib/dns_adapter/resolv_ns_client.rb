require_relative 'resolv_client'

module DNSAdapter
  # An adapter client for the internal Resolv DNS client that uses
  # Cloudflare's DNS for queries in order to avoid operative system cache
  CLIENT_NAMESERVERS = ['1.1.1.1', '1.0.0.1'].freeze

  class ResolvNsClient < ResolvClient
    def dns_resolver
      @dns_resolver ||= Resolv::DNS.new(nameserver: CLIENT_NAMESERVERS, search: [], ndots: 1)
    end
  end
end
