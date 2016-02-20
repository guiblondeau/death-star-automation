package application;

import org.restlet.Application;
import org.restlet.Restlet;
import org.restlet.resource.Directory;
import org.restlet.routing.Router;
import version.VersionServerResource;

public class WebApiApplication extends Application {

    private String frontAppBasePath;

    public WebApiApplication(String frontAppBasePath) {
        setName("Death Star API");
        setDescription("API of the Death Star");

        this.frontAppBasePath = frontAppBasePath;
    }

    @Override
    public Restlet createInboundRoot() {
        Router router = new Router();
        router.attach("/api", createApiRouter());
        router.attachDefault(createStaticFilesRouter());
        return router;
    }

    private Router createStaticFilesRouter() {
        Router router = new Router();

        router.attach("/scripts", new Directory(getContext(), frontAppBasePath + "/scripts"));
        router.attach("/styles", new Directory(getContext(), frontAppBasePath + "/styles"));
        router.attach("/images", new Directory(getContext(), frontAppBasePath + "/images"));
        router.attach("/", new Directory(getContext(), frontAppBasePath + "/"));

        return router;
    }

    private Router createApiRouter() {
        Router router = new Router();
        router.attach("/version", VersionServerResource.class);
        return router;
    }

}
