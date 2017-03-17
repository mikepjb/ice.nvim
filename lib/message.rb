module Message
  def prefix_namespace(filename)
    namespace = filename.
      split(/(src|test)\//).
      last.
      gsub('_', '-').
      gsub(/^clj(s|x|c)?\//, '').
      gsub(/.cljs?$/, '').
      gsub('/','.')
    "(ns #{namespace})"
  end
end
