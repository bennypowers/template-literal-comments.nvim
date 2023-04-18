; extends
((comment) @_com
           (#lua-match? @_com "/%*%s*(%w+)%s*%*/")
           (template_string) @lang
             (#set-template-literal-lang-from-comment! @_com)
             (#offset! @lang 0 1 0 -1))
