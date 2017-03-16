require_relative '../../lib/bencode'

describe Bencode do
  include Bencode

  # XXX strings should be abstracted into lets
  it 'can decode bencoded strings' do
    bencoded_string =
      "d2:id7:test-id"\
      "2:ns9:boot.user"\
      "7:session36:a647fb12-54ae-4313-8358-1161810de8f3"\
      "5:value17:#'boot.user/devile"
    expect(decode(bencoded_string)).to eq(
      {"id" => "test-id",
       "ns" => "boot.user",
       "session" => "a647fb12-54ae-4313-8358-1161810de8f3",
       "value" => "#'boot.user/devil"}
    )
  end

  it 'can encode hashes into bencoded strings' do
    message = {"id" => "test-id",
               "ns" => "boot.user",
               "session" => "a647fb12-54ae-4313-8358-1161810de8f3",
               "value" => "#'boot.user/devil"}
    expect(encode(message)).to eq(
      "d2:id7:test-id"\
      "2:ns9:boot.user"\
      "7:session36:a647fb12-54ae-4313-8358-1161810de8f3"\
      "5:value17:#'boot.user/devile"
    )
  end
end
