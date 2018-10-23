using Gtk;

public class imageApplication : Gtk.Application {

    private const Gtk.TargetEntry[] targets = {
        {"text/uri-list", 0, 0}
    };

    public imageApplication () {
        Object (application_id: "Image Compressor",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        // The main window with its title and size
        var window = new Gtk.ApplicationWindow (this);
        window.title = "Image Compressor";
        window.set_default_size (500, 500);

        
        
        //connect drag drop handlers
        Gtk.drag_dest_set (window,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
        window.drag_data_received.connect(this.on_drag_data_received);

        window.show_all ();
    }

    private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, 
                                         Gtk.SelectionData data, uint info, uint time) 
    {
        //loop through list of URIs
        foreach(string uri in data.get_uris ()){
            string file = uri.replace("file://","").replace("file:/","");
            // If it ends with .jpg or .jpeg
            if ( file.has_suffix(".jpg") || file.has_suffix(".jpeg") ) {
                stdout.printf("File immagine!\n");
            }
            stdout.printf("%s\n", file);
        }

        Gtk.drag_finish (drag_context, true, false, time);
    }

    public static int main (string[] args) {
        var app = new imageApplication ();
        return app.run (args);
    }
}
