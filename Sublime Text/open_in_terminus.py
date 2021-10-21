import sublime
import sublime_plugin

import os


class OpenInTerminusCommand(sublime_plugin.WindowCommand):
    """
    Drop in replacement for terminus_open that will open the 
    """
    def run(self, dirs, panel=True, **kwargs):
        command = "terminus_open"
        kwargs["cwd"] = dirs[0]

        if panel:
            command = "toggle_terminus_panel"
            kwargs["panel_name"] = "Terminus: %s" % os.path.split(dirs[0])[-1]

        self.window.run_command(command, kwargs)

    def is_enabled(self, dirs, panel=True):
        return len(dirs) == 1

    def is_visible(self, dirs, panel=True):
        return len(dirs) == 1