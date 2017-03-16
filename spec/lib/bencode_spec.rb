require_relative '../../lib/bencode'

describe Bencode do
  include Bencode

  it 'can decode bencoded strings' do
    bencoded_string =
      "d2:id7:test-id"\
      "2:ns9:boot.user"\
      "7:session36:a647fb12-54ae-4313-8358-1161810de8f"\
      "35:value17:#'boot.user/devile"
    expect(decode_message(bencoded_string)).to eq(
      {"id" => "test-id",
       "ns" => "boot.user",
       "session" => "a647fb12-54ae-4313-8358-1161810de8f3",
       "value" => "#'boot.user/devil"}
    )
  end
end
