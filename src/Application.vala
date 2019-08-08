 /*
* Copyright © 2019 Alain M. (https://github.com/alainm23/planner)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alain M. <alain23@protonmail.com>
*/

public class Application : Gtk.Application {
    public MainWindow main_window;
    public static GLib.Settings settings;

    public Application () {
        Object (
            application_id: "com.github.alainm23.ion-color-generator",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {  
        settings = new Settings ("com.github.alainm23.ion-color-generator");
    }

    public static Application _instance = null;

    public static Application instance {
        get {
            if (_instance == null) {
                _instance = new Application ();
            }
            return _instance;
        }
    }

    protected override void activate () {
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        var window_size = settings.get_value ("window-size");
        var rect = Gtk.Allocation ();
        rect.height = (int32) window_size.get_child_value (0);
        rect.width =  (int32) window_size.get_child_value (1);

        var window_position = settings.get_value ("window-position");
        var window_x = (int32) window_position.get_child_value (0);
        var window_y = (int32) window_position.get_child_value (1);

        main_window = new MainWindow (this);
        if (window_x != -1 ||  window_y != -1) {
            main_window.move (window_x, window_y);
        }

        main_window.set_allocation (rect);
        main_window.show_all ();

        // Actions
        var quit_action = new SimpleAction ("quit", null);
        set_accels_for_action ("app.quit", {"<Control>q"});

        quit_action.activate.connect (() => {
            if (main_window != null) {
                main_window.destroy ();
            }
        });

        add_action (quit_action);

        // Stylesheet
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/alainm23/ion-color-generator/stylesheet.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    public static int main (string[] args) {
        Application app = Application.instance;
        return app.run (args);
    }
}