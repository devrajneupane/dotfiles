import os
import sublime_plugin


class CmdCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        file_name = self.view.file_name()
        path = file_name.split("\\")
        current_driver = path[0]
        path.pop()
        current_directory = "\\".join(path)
        # command = "cd " + current_directory + " & " + current_driver + " &  cmd"
        command = 'wt -d "' + current_directory + '"' + \
            '; split-pane -p "Command Prompt" -d ' + '"' + current_directory + '"'
        os.system(command)
