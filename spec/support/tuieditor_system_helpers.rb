# frozen_string_literal: true

module TuiEditorSystemHelpers
  def tuieditor_setcontent(selector, content)
    execute_script(<<-JS
      var editor = document.getElementById('#{selector}')['editorObj']
      editor.setMarkdown('#{content}')
    JS
                  )
  end
end
