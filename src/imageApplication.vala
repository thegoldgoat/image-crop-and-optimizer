/* imageApplication.vala
 *
 * Copyright 2018 Andrea Somaini <andrea.somaini00@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */



using Gtk;
using Posix;

public class imageApplication : Gtk.Application {

    private const Gtk.TargetEntry[] targets = {
        {"text/uri-list", 0, 0}
    };

    public imageApplication () {
        Object (application_id: "Image Compressor",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    private Gtk.Image image;
    private Gtk.ApplicationWindow window;
    private Gtk.Label dropHere;
    private string output_path = "/tmp/prova.jpg";

    protected override void activate () {
        // The main window with its title and size
        this.window = new Gtk.ApplicationWindow (this);
        window.title = "Image Compressor";
        window.set_default_size (500, 500);

        Gtk.Box vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, -1);

        Gtk.Box hBoxWidth = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 20);
        Gtk.Box hBoxSize = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 20);

        // Width elements
        Gtk.Label labelWidth = new Gtk.Label("Image Witdh:");
        Gtk.SpinButton spinButtonWidth = new Gtk.SpinButton.with_range (0, 10000, 1);
        spinButtonWidth.set_value(800.0);

        // Size elements
        Gtk.Label labelSize = new Gtk.Label("Image Maximum size (Kb):");
        Gtk.SpinButton spinButtonSize = new Gtk.SpinButton.with_range (0, 100000, 1);
        spinButtonSize.set_value(25.0);
        
        // Drop element
        this.dropHere = new Gtk.Label("Drop image here");
        
        // Box adds:
        // * Width
        hBoxWidth.pack_start(labelWidth, true, true, 0);
        hBoxWidth.pack_start(spinButtonWidth, true, true, 0);
        // * Size
        hBoxSize.pack_start(labelSize, true, true, 0);
        hBoxSize.pack_start(spinButtonSize, true, true, 0);
        // * vbox
        vbox.add(hBoxWidth);
        vbox.add(hBoxSize);
        vbox.pack_start(this.dropHere, true, true, 0);

        //connect drag drop handlers
        Gtk.drag_dest_set (window,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
        // When the file is dropped
        this.window.drag_data_received.connect(this.on_drag_data_received);

        // Add the box
        this.window.add(vbox);
        this.window.show_all ();
    }

    private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y,
                                         Gtk.SelectionData data, uint info, uint time) {
        //loop through list of URIs
        foreach(string uri in data.get_uris ()){
            string file = uri.replace("file://","").replace("file:/","").replace("%20", "\\ ");
            // If it ends with .jpg or .jpeg
            if ( file.has_suffix(".jpg") || file.has_suffix(".jpeg") ) {
                Posix.stdout.printf("File immagine jpeg!\n");
                //convert sample.jpg -define jpeg:extent=300kb -scale 800 output.jpg
                Posix.system("convert " + file + " -define jpeg:extent=500kb -scale 800 " + this.output_path);
            }
            Posix.stdout.printf("%s\n", file);
        }

        Gtk.drag_finish (drag_context, true, false, time);
    }

    public static int main (string[] args) {
        var app = new imageApplication ();
        return app.run (args);
    }
}
