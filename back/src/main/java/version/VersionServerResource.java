package version;

import org.restlet.representation.StringRepresentation;
import org.restlet.resource.Get;
import org.restlet.resource.ServerResource;

import java.io.InputStream;
import java.util.Properties;

/**
 * Created by guillaume on 13/02/16.
 */
public class VersionServerResource extends ServerResource{

    private static Properties PROPERTIES = new Properties();

    static {
        versionPropertiesInitializer();
    }

    static void versionPropertiesInitializer() {
        InputStream resourceAsStream = VersionServerResource.class.getResourceAsStream("/version.properties");
        try {
            PROPERTIES.load( resourceAsStream );
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Get
    public VersionRepresentation getVersion() {
        VersionRepresentation versionRepresentation = new VersionRepresentation();
        versionRepresentation.setVersion(PROPERTIES.getProperty("version"));
        return versionRepresentation;
    }
}
