require_relative '../../lib/message'

describe Message do
  include Message

  context 'Prefixing Namespaces' do
    it 'takes a filename and creates the equivalent namespace sexp' do
      expect(prefix_namespace('src/watermarker/core.clj')).to eq(
        '(ns watermarker.core)'
      )
    end

    it 'removes clj(s|c) from paths with clj after src' do
      expect(prefix_namespace('src/clj/watermarker/core.clj')).to eq(
        '(ns watermarker.core)'
      )
      expect(prefix_namespace('src/cljs/watermarker/core.clj')).to eq(
        '(ns watermarker.core)'
      )
      expect(prefix_namespace('src/cljc/watermarker/core.clj')).to eq(
        '(ns watermarker.core)'
      )
      expect(prefix_namespace('src/cljx/watermarker/core.clj')).to eq(
        '(ns watermarker.core)'
      )
    end

    xit 'works for where a filepath has src or test' do
    end

    xit 'avoids prefixing a namespace altogether if src/test are not found on the filepath' do
    end
  end
end
# 'src/clj/sbsl/price_services/schema/deals.clj'
