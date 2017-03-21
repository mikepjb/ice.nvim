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

  it 'can decode multiple dictionaries from a single socket message' do
    multi_dict_message =
      "d"\
      "2:id7:test-id"\
      "2:ns16:watermarker.core"\
      "7:session36:57fea508-bc66-42af-b167-a3469da03ec"\
      "35:value30:#'watermarker.core/this-method"\
    "e"\
      "d"\
      "2:id7:test-id"\
      "7:session36:57fea508-bc66-42af-b167-a3469da03ec"\
      "36:statusl4:done"\
      "e"\
      "e"
    expect(decode_all(multi_dict_message)).to eq(
      [{"id"=>"test-id", "ns"=>"watermarker.core", "session"=>"57fea508-bc66-42af-b167-a3469da03ec3", "value"=>"#'watermarker.core/this-method"},
       {"id"=>"test-id", "session"=>"57fea508-bc66-42af-b167-a3469da03ec3", "status"=>"done"}]
    )
  end

  it 'can decode single dictionaries from a single socket message' do
    single_dict_message =
      "d2:id7:test-id"\
      "2:ns9:boot.user"\
      "7:session36:a647fb12-54ae-4313-8358-1161810de8f3"\
      "5:value17:#'boot.user/devile"
    expect(decode_all(single_dict_message)).to eq(
      [{"id" => "test-id",
        "ns" => "boot.user",
        "session" => "a647fb12-54ae-4313-8358-1161810de8f3",
        "value" => "#'boot.user/devil"}]
    )
  end
end
