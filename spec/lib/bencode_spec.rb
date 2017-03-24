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
    expect(decode(single_dict_message)).to eq(
      {"id" => "test-id",
        "ns" => "boot.user",
        "session" => "a647fb12-54ae-4313-8358-1161810de8f3",
        "value" => "#'boot.user/devil"}
    )
  end

  context "Exception messages" do
    it 'can decode the initial exception message' do
      exception_message =
        "d"\
        "2:ex45:class clojure.lang.Compiler$CompilerException"\
        "2:id7:test-id"\
        "7:root-ex45:class clojure.lang.Compiler$CompilerException"\
        "7:session36:b9336d5c-abde-4dc3-b555-86628e3d26d6"\
        "6:statusl10:eval-erroree"
      expect(decode_all(exception_message)).to eq(
        [{"ex" => "class clojure.lang.Compiler$CompilerException",
          "id" => "test-id",
          "root-ex" => "class clojure.lang.Compiler$CompilerException",
          "session" => "b9336d5c-abde-4dc3-b555-86628e3d26d6",
          "status" => "eval-error"}]
      )
    end

    it 'can decode the more detailed exception message' do
      detailed_exception_message =
        "d"\
        "2:id7:test-id"\
        "3:out244:             \e[1;31mjava.lang.RuntimeException\e[m: \e[3mNo such namespace: io\e[m\n\e[1;31mclojure.lang.Compiler$CompilerException\e[m: \e[3mjava.lang.RuntimeException: No such namespace: io, compiling:(/tmp/boot.user6662229202639790268.clj:2:86)\e[m\n"\
        "7:session36:b9336d5c-abde-4dc3-b555-86628e3d26d6"\
        "e"
      expect(decode(detailed_exception_message)).to eq(
        {"id" => "test-id",
         "out" => "             \e[1;31mjava.lang.RuntimeException\e[m: \e[3mNo such namespace: io\e[m\n\e[1;31mclojure.lang.Compiler$CompilerException\e[m: \e[3mjava.lang.RuntimeException: No such namespace: io, compiling:(/tmp/boot.user6662229202639790268.clj:2:86)\e[m\n",
         "session" => "b9336d5c-abde-4dc3-b555-86628e3d26d6"}
      )
    end
  end

  it 'extracts the next keypair in sequence' do
    expect(
      extract_next_keypair(
        {"cool" => "keypair"},
        "7:session36:b9336d5c-abde-4dc3-b555-86628e3d26d6e")
    ).to eq(
      [{"cool"=>"keypair", "session"=>"b9336d5c-abde-4dc3-b555-86628e3d26d6"}, "e"]
    )
  end
end
