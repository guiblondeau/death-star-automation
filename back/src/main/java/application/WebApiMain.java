package application;

import org.restlet.Component;
import org.restlet.data.Protocol;

/**
 * Created by guillaume on 13/02/16.
 */
public class WebApiMain {

    public static void main(String[] args) throws Exception {

        String frontAppBasePath = args[0];

        // Attach application to http://localhost:9000/v1
        Component c = new Component();
        c.getServers().add(Protocol.HTTP, 9000);

        // Declare client connector based on the classloader
        c.getClients().add(Protocol.CLAP);
        c.getClients().add(Protocol.FILE);

        c.getDefaultHost().attach(new WebApiApplication(frontAppBasePath));

        c.start();
    }
}
