module Message
  def prefix_namespace(filename)
    namespace = filename.
      split('src/').
      last.
      gsub(/^clj(s|x|c)?\//, '').
      gsub(/.cljs?$/, '').
      gsub('/','.')
    "(ns #{namespace})"
  end
end
