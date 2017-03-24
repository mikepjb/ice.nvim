module Message
  def self.prefix_namespace(filename, code)
    if filename =~ /.?(src|test)\/.*/
      namespace = filename.
        split(/(src|test)\//).
        last.
        gsub('_', '-').
        gsub(/^clj(s|x|c)?\//, '').
        gsub(/.cljs?$/, '').
        gsub('/','.')
      "(ns #{namespace})\n\n#{code}"
    else
      code
    end
  end
end
